from django.urls import path
from . import views

urlpatterns = [
    path('challenges/', views.get_challenges),
    path('challenges/<str:challenge_id>/', views.get_challenge),
    path('user_challenges/complete/', views.complete_challenge),
]
