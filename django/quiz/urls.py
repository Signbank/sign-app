from django.urls import path, include
from rest_framework import routers

from .views import UserQuizListViewSet, QuizListViewSet

router = routers.DefaultRouter()
router.register(r'user-quiz-lists', UserQuizListViewSet)
router.register(r'quiz-lists', QuizListViewSet)

urlpatterns = [
    path('', include(router.urls)),
]
