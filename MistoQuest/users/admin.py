from django.contrib import admin


from .models import User, UserStats
admin.site.register(User)
admin.site.register(UserStats)