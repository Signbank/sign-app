from django.urls import path, include
from rest_framework import routers

from .views import UserQuizListViewSet, QuizListViewSet

router = routers.DefaultRouter()
router.register(r'user-sign-lists', UserQuizListViewSet)
router.register(r'sign-lists', QuizListViewSet)

urlpatterns = [
    path('', include(router.urls)),
]
