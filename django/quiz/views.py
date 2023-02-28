from rest_framework import viewsets
# from rest_framework.permissions import IsAuthenticated
from .models import UserSignList, SignList
from .serializers import UserSignListSerializer, SignListSerializer


class UserSignListViewSet(viewsets.ModelViewSet):
    """
    View set with which CRUD operations can be performed on the UserSignList model
    """
    # current_user = self.request.user
    # queryset = UserSignList.objects.filter(user=current_user)
    queryset = UserSignList.objects.all()
    serializer_class = UserSignListSerializer

    # permission_classes = [IsAuthenticated]


class SignListViewSet(viewsets.ModelViewSet):
    """
    View set with which CRUD operations can be performed on the SignList model
    """
    queryset = SignList.objects.all()
    serializer_class = SignListSerializer
    # permission_classes = [IsAuthenticated]
