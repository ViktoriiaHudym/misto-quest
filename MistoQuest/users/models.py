from django.db import models


class User(models.Model):
    name = models.CharField(max_length=50)
    username = models.CharField(max_length=20, unique=True)


class UserStats(models.Model):
    id_user = models.OneToOneField(User, on_delete=models.CASCADE)
    level = models.IntegerField(default=1)
    karma = models.IntegerField(default=0)
    total_challenges = models.IntegerField(default=0)