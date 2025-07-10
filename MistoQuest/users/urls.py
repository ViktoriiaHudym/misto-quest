from django.urls import path
from . import views
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from .views import register

urlpatterns = [
    path('register/', register, name='register'),
    path('login/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('login/refresh/', TokenRefreshView.as_view(), name='token_refresh'), # Keep one refresh path
    path('profile/', views.get_profile, name='get_profile'), # Corrected path
    path('stats/<str:username>/', views.get_statistics, name='get_statistics'), # Added trailing slash
]