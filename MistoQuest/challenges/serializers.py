from rest_framework.serializers import ModelSerializer
from .models import Challenge


class ChallengeSerializer(ModelSerializer):
    class Meta:
        model = Challenge
        fields = '__all__'
        read_only_fields = ['id']

