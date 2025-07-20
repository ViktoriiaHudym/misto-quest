from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, IsAdminUser, AllowAny
from rest_framework import status
from django.utils import timezone

from .serializers import ChallengeSerializer, UserChallengeSerializer
from .models import Challenge, UserChallenge


@api_view(['GET'])
@permission_classes([AllowAny])
def get_challenges(request):
    challenges = Challenge.objects.all()
    serializer = ChallengeSerializer(challenges, many=True)
    return Response(serializer.data)


@api_view(['GET'])
@permission_classes([AllowAny])
def get_challenge(request, challenge_id):
    challenge = Challenge.objects.get(id=challenge_id)
    serializer = ChallengeSerializer(challenge, many=False)
    return Response(serializer.data)


@api_view(['POST'])
@permission_classes([IsAdminUser])
def create_challenge(request):

    if not request.user.is_staff:
        return Response(
            {"detail": "You do not have permission to perform this action."},
            status=status.HTTP_403_FORBIDDEN
        )

    serializer = ChallengeSerializer(data=request.data)

    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_200_OK)
    else:
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['PUT'])
@permission_classes([IsAdminUser])
def update_challenge(request, challenge_id):

    if not request.user.is_staff:
        return Response(
            {"detail": "You do not have permission to perform this action."},
            status=status.HTTP_403_FORBIDDEN
        )

    try:
        challenge = Challenge.objects.get(id=challenge_id)
    except Challenge.DoesNotExist:
        return Response(
            {"detail": f"Challenge with id={challenge_id} not found."},
            status=status.HTTP_404_NOT_FOUND
        )

    serializer = ChallengeSerializer(challenge, data=request.data, partial=True)

    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_200_OK)
    else:
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['DELETE'])
@permission_classes([IsAdminUser])
def delete_challenge(request, challenge_id):

    if not request.user.is_staff:
        return Response(
            {"detail": "You do not have permission to perform this action."},
            status=status.HTTP_403_FORBIDDEN
        )

    try:
        challenge = Challenge.objects.get(id=challenge_id)
        challenge.delete()
    except Challenge.DoesNotExist:
        return Response(
            {"detail": f"Challenge with id={challenge_id} not found."},
            status=status.HTTP_404_NOT_FOUND
        )

    return Response(f"Challenge with id={challenge_id} was deleted.")


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def complete_user_challenge(request):
    id_challenge = request.data.get('id_challenge')

    try:
        user_challenge = UserChallenge.objects.get(id_user=request.user, id_challenge=id_challenge)
    except UserChallenge.DoesNotExist:
        return Response({"error": "UserChallenge not found"}, status=status.HTTP_404_NOT_FOUND)

    user_challenge.user_complete_date = timezone.now().date()
    user_challenge.user_complete_status = 2
    user_challenge.save()
    serializer = UserChallengeSerializer(user_challenge)

    return Response(serializer.data, status=status.HTTP_200_OK)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def terminate_user_challenge(request):
    id_challenge = request.data.get('id_challenge')

    try:
        user_challenge = UserChallenge.objects.get(id_user=request.user, id_challenge=id_challenge)
    except UserChallenge.DoesNotExist:
        return Response({"error": "UserChallenge not found"}, status=status.HTTP_404_NOT_FOUND)

    user_challenge.user_complete_status = 4
    user_challenge.save()
    serializer = UserChallengeSerializer(user_challenge)

    return Response(serializer.data, status=status.HTTP_200_OK)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_user_challenges(request):
    user_challenges = UserChallenge.objects.filter(id_user=request.user)

    if not user_challenges.exists():
        return Response(
            {"message": f"No challenges found for user or user doesn't exist"},
            status=status.HTTP_200_OK
        )

    serializer = UserChallengeSerializer(user_challenges, many=True)
    return Response(serializer.data, status=status.HTTP_200_OK)
