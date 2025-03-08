from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import api_view

from .serializers import ChallengeSerializer
from .models import Challenge


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
