from rest_framework.serializers import ModelSerializer
from .models import Challenge, UserChallenge


class ChallengeSerializer(ModelSerializer):
    class Meta:
        model = Challenge
        fields = '__all__'
        read_only_fields = ['id']


class UserChallengeSerializer(ModelSerializer):
    class Meta:
        model = UserChallenge
        fields = '__all__'

