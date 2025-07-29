from rest_framework.serializers import ModelSerializer
from rest_framework import serializers
from .models import Challenge, UserChallenge


class ChallengeSerializer(ModelSerializer):
    # Hold the full URL to the image.
    image_url = serializers.SerializerMethodField()

    class Meta:
        model = Challenge
        fields = ['id', 'title', 'description', 'difficulty', 'created_date',
                  'max_duration', 'points', 'is_active', 'image', 'image_url']
        read_only_fields = ['id', 'image_url']
        extra_kwargs = {
            'description': {'required': False},
            'created_date': {'required': False},
            'is_active': {'required': False},
        }

    def get_image_url(self, obj):
        request = self.context.get('request')
        if obj.image and request is not None:
            return request.build_absolute_uri(obj.image.url)
        return None


class UserChallengeSerializer(serializers.ModelSerializer):
    id_challenge = ChallengeSerializer(read_only=True)

    class Meta:
        model = UserChallenge
        fields = '__all__'
        extra_kwargs = {
            'user_complete_date': {'required': False},
        }