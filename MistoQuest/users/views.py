from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated, AllowAny, IsAdminUser

from django.contrib.auth import get_user_model

from .serializers import UserSerializer, UserStatsSerializer
from .models import UserStats


class RegisterUserProfileView(APIView):
    """
    API View to register a new user profile.
    """
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = UserSerializer(data=request.data)

        if serializer.is_valid(raise_exception=ValueError):
            serializer.create(validated_data=request.data)
            return Response(
                serializer.data,
                status=status.HTTP_201_CREATED
            )
        return Response(
            {
                "error": True,
                "error_msg": serializer.error_messages,
            },
            status=status.HTTP_400_BAD_REQUEST
        )


class UserProfileView(APIView):
    """
    API View to get the user profile.
    """
    permission_classes = [IsAuthenticated, IsAdminUser]

    def get(self, request):
        user = request.user
        serializer = UserSerializer(user, many=False)
        return Response(serializer.data)


class UserProfilesView(APIView):
    """
    API View to get all user profiles.
    """
    permission_classes = [IsAdminUser]

    def get(self, request):
        users = get_user_model().objects.all()
        serializer = UserSerializer(users, many=True)
        return Response(serializer.data)


class UserStatsView(APIView):
    """
    API View to get the user statistics.
    """
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
