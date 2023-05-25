from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from .models import UserQuizList
from .serializers import UserQuizListSerializer
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
