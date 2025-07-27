from django.db import models
from users.models import User
from datetime import date


class Challenge(models.Model):
    title = models.CharField(max_length=255)
    description = models.TextField(default="There is no description yet.")

    difficulty_choices = [
        ('easy', 'Easy'),
        ('medium', 'Medium'),
        ('hard', 'Hard'),
    ]
    difficulty = models.CharField(
        max_length=6,
        choices=difficulty_choices,
        default='easy',
    )

    created_date = models.DateField(default=date.today)
    max_duration = models.IntegerField(default=7)

    points = models.IntegerField(default=0)

    is_active = models.BooleanField(default=True)

    image = models.ImageField(upload_to='challenge_images/', null=True, blank=True)

    def __str__(self):
        return self.title

    class Meta:
        ordering = ['-created_date']


class UserChallenge(models.Model):
    id_user = models.ForeignKey(User, on_delete=models.CASCADE)
    id_challenge = models.ForeignKey(Challenge, on_delete=models.CASCADE)
    user_pick_up_date = models.DateField(default=date.today)
    user_complete_date = models.DateField(null=True, blank=True)

    USER_STATUS_CHOICES = [
        (0, 'Not Started'),
        (1, 'In Progress'),
        (2, 'Completed'),
        (3, 'Failed'),
        (4, 'Terminated'),
    ]
    user_complete_status = models.IntegerField(
        choices=USER_STATUS_CHOICES,
        default=0
    )

    def __str__(self):
        return f"{self.id_user.username} - {self.id_challenge.title}"
