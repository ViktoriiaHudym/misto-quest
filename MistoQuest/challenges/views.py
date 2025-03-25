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


@api_view(['POST'])
def create_challenge(request):
    challenge_data = request.data

    challenge = Challenge.objects.create(
        title=challenge_data['title'],
        description=challenge_data['description'],
        difficulty=challenge_data['difficulty'],
        max_duration=challenge_data['max_duration'],
        points=challenge_data['points'],
        is_active=challenge_data['is_active']
    )
    serializer = ChallengeSerializer(challenge, many=False)
    return Response(serializer.data)