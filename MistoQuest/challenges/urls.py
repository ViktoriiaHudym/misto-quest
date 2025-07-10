from django.urls import path
from . import views

urlpatterns = [
    path('challenges/', views.get_challenges),
    path('challenges/create/', views.create_challenge),
    path('challenges/<str:challenge_id>/update/', views.update_challenge),
    path('challenges/<str:challenge_id>/delete/', views.delete_challenge),
    path('challenges/<str:challenge_id>/', views.get_challenge),
    path('user/complete_challenge', views.complete_user_challenge),
    path('user/terminate_challenge', views.terminate_user_challenge),
    path('user/<str:user_id>/challenges/', views.get_user_challenges),
]
