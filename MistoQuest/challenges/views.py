from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework import status
from django.utils import timezone

from .serializers import ChallengeSerializer, UserChallengeSerializer
from .models import Challenge, UserChallenge


@api_view(['GET'])
def get_challenges(request):
    challenges = Challenge.objects.all()
    serializer = ChallengeSerializer(challenges, many=True)
    return Response(serializer.data)


@api_view(['GET'])
def get_challenge(request, challenge_id):
    challenge = Challenge.objects.get(id=challenge_id)
    serializer = ChallengeSerializer(challenge, many=False)
    return Response(serializer.data)


@api_view(['POST'])
def complete_challenge(request):
    id_user = request.data.get('id_user')
    id_challenge = request.data.get('id_challenge')

    try:
        # Fetch the UserChallenge object by primary key (pk)
        user_challenge = UserChallenge.objects.get(id_user=id_user, id_challenge=id_challenge)
    except UserChallenge.DoesNotExist:
        return Response({"error": "UserChallenge not found"}, status=status.HTTP_404_NOT_FOUND)

    # Update fields with the provided data or keep the existing values if not provided

    user_challenge.user_complete_date = timezone.now()

    user_challenge.save()

    # Serialize the updated UserChallenge object
    serializer = UserChallengeSerializer(user_challenge)

    # Return the updated UserChallenge object
    return Response(serializer.data, status=status.HTTP_200_OK)
