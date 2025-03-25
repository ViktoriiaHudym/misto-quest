from django.urls import path
from . import views

urlpatterns = [
    path('user/profile/<str:username>', views.get_profile),
    path('user/stats/<str:username>', views.get_statistics),
]
