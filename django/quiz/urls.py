from django.urls import path, include
from rest_framework import routers

from .views import UserSignListViewSet, SignListViewSet

router = routers.DefaultRouter()
router.register(r'user-sign-lists', UserSignListViewSet)
router.register(r'sign-lists', SignListViewSet)

urlpatterns = [
    path('', include(router.urls)),
]
