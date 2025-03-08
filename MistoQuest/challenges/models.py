from django.db import models
from django.utils import timezone


class Challenge(models.Model):
    title = models.CharField(max_length=255)
    description = models.TextField()

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

    created_date = models.DateField(default=timezone.now)
    max_duration = models.IntegerField(default=7)

    points = models.IntegerField(default=0)

    is_active = models.BooleanField(default=True)

    def __str__(self):
        return self.title

    class Meta:
        ordering = ['-created_date']
