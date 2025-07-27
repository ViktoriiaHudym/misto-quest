from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

from .views import (
    UserProfileView, UserProfilesView, RegisterUserProfileView, UserStatsView,
    StartChallengeView, UserChallengeListView, CompleteChallengeView, TerminateChallengeView
)

urlpatterns = [
    path('all/', UserProfilesView.as_view(), name='all_user_profiles'),
    path('register/', RegisterUserProfileView.as_view(), name='register_user_profile'),
    path('login/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('login/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('profile/', UserProfileView.as_view(), name='user_profile'),
    path('stats/', UserStatsView.as_view(), name='user_statistics'),

    # path for the "Start" button
    path('start_challenge/', StartChallengeView.as_view(), name='start_challenge'),
    path('complete_challenge/', CompleteChallengeView.as_view(), name='complete_challenge'),
    path('terminate_challenge/', TerminateChallengeView.as_view(), name='terminate_challenge'),
    path('my_challenges/', UserChallengeListView.as_view(), name='user_challenges_list'),
]