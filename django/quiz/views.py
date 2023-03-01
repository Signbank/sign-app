from rest_framework import viewsets
# from rest_framework.permissions import IsAuthenticated
from .models import UserQuizList, QuizList
from .serializers import UserQuizListSerializer, QuizListSerializer


class UserQuizListViewSet(viewsets.ModelViewSet):
    """
    View set with which CRUD operations can be performed on the UserQuizList model
    """
    # current_user = self.request.user
    # queryset = UserQuizList.objects.filter(user=current_user)
    queryset = UserQuizList.objects.all()
    serializer_class = UserQuizListSerializer
    # permission_classes = [IsAuthenticated]


class QuizListViewSet(viewsets.ModelViewSet):
    """
    View set with which CRUD operations can be performed on the QuizList model
    """
    queryset = QuizList.objects.all()
    serializer_class = QuizListSerializer
    # permission_classes = [IsAuthenticated]
