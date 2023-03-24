from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from .models import UserQuizList, QuizList
from .serializers import UserQuizListSerializer, QuizListSerializer
from knox.auth import TokenAuthentication


class UserQuizListViewSet(viewsets.ModelViewSet):
    """
    View set with which CRUD operations can be performed on the UserQuizList model
    """
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)
    serializer_class = UserQuizListSerializer
    queryset = UserQuizList.objects.none()

    def get_queryset(self):
        current_user = self.request.user
        return UserQuizList.objects.filter(user=current_user.id)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user.id)


class QuizListViewSet(viewsets.ModelViewSet):
    """
    View set with which CRUD operations can be performed on the QuizList model
    """
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)
    queryset = QuizList.objects.none()
    serializer_class = QuizListSerializer

    def get_queryset(self):
        current_user = self.request.user
        return UserQuizList.objects.filter(user=current_user.id)
