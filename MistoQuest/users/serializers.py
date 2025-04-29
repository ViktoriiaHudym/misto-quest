from django.contrib.auth import get_user_model
from rest_framework.serializers import ModelSerializer
from django.contrib.auth.models import User
from .models import UserStats
from rest_framework import serializers
from django.contrib.auth import get_user_model


class UserSerializer(ModelSerializer):
    class Meta:
        model = User
        fields = ['username', 'password', 'email']
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        user = User.objects.create_user(**validated_data)
        return user
        # fields = '__all__'
        # read_only_fields = ['id']
        # model = get_user_model()
        # fields = ['id', 'username']

# Serializer for registration
class RegisterSerializer(serializers.ModelSerializer):
    class Meta:
        model = get_user_model()  # Ensure the custom User model is used if defined
        fields = ['username', 'password', 'email']
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        user = get_user_model().objects.create_user(**validated_data)
        return user


class UserStatsSerializer(ModelSerializer):
    class Meta:
        model = UserStats
        fields = '__all__'