from rest_framework.serializers import ModelSerializer
from .models import User, UserStats


class UserSerializer(ModelSerializer):
    class Meta:
        model = User
        fields = '__all__'
        read_only_fields = ['id']


class UserStatsSerializer(ModelSerializer):
    class Meta:
        model = UserStats
        fields = '__all__'