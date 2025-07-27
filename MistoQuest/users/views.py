from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated, AllowAny, IsAdminUser

from django.contrib.auth import get_user_model
from challenges.models import UserChallenge
from challenges.serializers import UserChallengeSerializer

from .serializers import UserSerializer, UserStatsSerializer
from .models import UserStats


class RegisterUserProfileView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()  # .save() will call the .create() method in serializer
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        # Return the actual validation errors from the serializer
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class StartChallengeView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        id_challenge = request.data.get('id_challenge')
        if not id_challenge:
            return Response({"error": "id_challenge is required"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user_challenge = UserChallenge.objects.get(
                id_user=request.user,
                id_challenge_id=id_challenge
            )
        except UserChallenge.DoesNotExist:
            return Response({"error": "You have not accepted this challenge"}, status=status.HTTP_404_NOT_FOUND)

        user_challenge.user_complete_status = 1  # In Progress
        user_challenge.save()
        serializer = UserChallengeSerializer(user_challenge)
        return Response(serializer.data, status=status.HTTP_200_OK)


class CompleteChallengeView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        id_challenge = request.data.get('id_challenge')
        if not id_challenge:
            return Response({"error": "id_challenge is required"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user_challenge = UserChallenge.objects.get(id_user=request.user, id_challenge_id=id_challenge)
        except UserChallenge.DoesNotExist:
            return Response({"error": "You have not accepted this challenge"}, status=status.HTTP_404_NOT_FOUND)

        user_challenge.user_complete_status = 2  # Completed
        user_challenge.save()
        serializer = UserChallengeSerializer(user_challenge)
        return Response(serializer.data, status=status.HTTP_200_OK)


class TerminateChallengeView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        id_challenge = request.data.get('id_challenge')
        if not id_challenge:
            return Response({"error": "id_challenge is required"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user_challenge = UserChallenge.objects.get(id_user=request.user, id_challenge_id=id_challenge)
        except UserChallenge.DoesNotExist:
            return Response({"error": "You have not accepted this challenge"}, status=status.HTTP_404_NOT_FOUND)

        user_challenge.user_complete_status = 4  # Terminated
        user_challenge.save()
        serializer = UserChallengeSerializer(user_challenge)
        return Response(serializer.data, status=status.HTTP_200_OK)


class UserChallengeListView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        # Get all UserChallenge objects for the current user
        user_challenges = UserChallenge.objects.filter(id_user=request.user)
        # Use the nested serializer to include full challenge details for performance
        serializer = UserChallengeSerializer(user_challenges, many=True)
        return Response(serializer.data)


class UserProfileView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        serializer = UserSerializer(request.user, many=False)
        return Response(serializer.data)


class UserProfilesView(APIView):
    permission_classes = [IsAdminUser]

    def get(self, request):
        users = get_user_model().objects.all()
        serializer = UserSerializer(users, many=True)
        return Response(serializer.data)


class UserStatsView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        try:
            user_stat = UserStats.objects.get(id_user=request.user)
            serializer = UserStatsSerializer(user_stat, many=False)
            return Response(serializer.data)
        except UserStats.DoesNotExist:
            return Response(
                {"error": "Stats not found for this user"},
                status=status.HTTP_404_NOT_FOUND
            )