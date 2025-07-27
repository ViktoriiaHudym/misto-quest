from rest_framework.serializers import ModelSerializer
from .models import Challenge, UserChallenge


class ChallengeSerializer(ModelSerializer):
    class Meta:
        model = Challenge
        fields = '__all__'
        read_only_fields = ['id']
        extra_kwargs = {
            'description': {'required': False},
            'created_date': {'required': False},
            'is_active': {'required': False},
        }


class UserChallengeSerializer(ModelSerializer):
    id_challenge = ChallengeSerializer(read_only=True)

    class Meta:
        model = UserChallenge
        fields = '__all__'
        extra_kwargs = {
            'user_complete_date': {'required': False},
        }