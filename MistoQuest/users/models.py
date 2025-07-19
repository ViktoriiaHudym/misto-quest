from django.contrib.auth.models import AbstractUser
from django.db import models


class User(AbstractUser):
    def __str__(self):
        return self.username


class UserStats(models.Model):
    id_user = models.OneToOneField(User, on_delete=models.CASCADE)
    level = models.IntegerField(default=1)
    karma = models.IntegerField(default=0)
    total_challenges = models.IntegerField(default=0)