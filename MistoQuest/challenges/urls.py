from django.urls import path
from . import views

urlpatterns = [
    path('', views.get_challenges),
    path('create/', views.create_challenge),
    path('user/complete_challenge', views.complete_user_challenge),
    path('user/terminate_challenge', views.terminate_user_challenge),
    path('user/', views.get_user_challenges),
    path('<str:challenge_id>/update/', views.update_challenge),
    path('<str:challenge_id>/delete/', views.delete_challenge),
    path('<str:challenge_id>/', views.get_challenge),
]
