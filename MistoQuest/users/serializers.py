from django.contrib.auth import get_user_model
from rest_framework import serializers
from rest_framework.validators import UniqueTogetherValidator

from .models import UserStats


class UserSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(required=True)
    username = serializers.CharField(required=True)
    password = serializers.CharField(write_only=True, required=True)

    class Meta:
        model = get_user_model()
        fields = ['id', 'username', 'email', 'password']
        read_only_fields = ['id']  # Make id read-only
        validators = [
            UniqueTogetherValidator(
                queryset=get_user_model().objects.all(),
                fields=['username', 'email']
            )
        ]

    def create(self, validated_data):
        user = get_user_model().objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password']
        )
        return user


class UserStatsSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserStats
        fields = '__all__'