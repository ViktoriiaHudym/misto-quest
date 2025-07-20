from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

from .views import UserProfileView, UserProfilesView, RegisterUserProfileView, UserStatsView


urlpatterns = [
    path('all/', UserProfilesView.as_view(), name='all_user_profiles'),
    path('register_user/', RegisterUserProfileView.as_view(), name='register_user_profile'),
    path('login/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('login/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('user_profile/', UserProfileView.as_view(), name='user_profile'),
    path('user_stats/', UserStatsView.as_view(), name='user_statistics'),
]
