from django.shortcuts import render

from rest_framework.response import Response
from rest_framework.decorators import api_view

from .serializers import UserSerializer, UserStatsSerializer
from .models import User, UserStats


@api_view(['GET'])
def get_profile(request, username):
    user = User.objects.get(username=username)
    serializer = UserSerializer(user, many=False)
    return Response(serializer.data)


@api_view(['GET'])
def get_statistics(request, username):
    user_stat = UserStats.objects.get(id_user=username)
    serializer = UserStatsSerializer(user_stat, many=False)
    return Response(serializer.data)



