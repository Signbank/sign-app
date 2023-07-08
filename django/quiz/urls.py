from django.urls import path, include
from rest_framework import routers
from .views import UserQuizListViewSet

router = routers.DefaultRouter()
router.register(r'user-quiz-lists', UserQuizListViewSet)

urlpatterns = [
    path('', include(router.urls)),
]
