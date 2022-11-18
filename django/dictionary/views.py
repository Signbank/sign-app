from dictionary.models import Sign
from rest_framework import viewsets
from rest_framework import permissions
from dictionary.serializers import SignSerializer


class SignViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows users to be viewed or edited.
    """
    queryset = Sign.objects.all()
    serializer_class = SignSerializer
    permission_classes = [permissions.IsAuthenticated]

# from django.views import generic
#
# from .models import Sign
#
# class IndexView(generic.ListView):
#     template_name = 'dictionary/index.html'
#     context_object_name = 'signs'
#
#
#     def get_queryset(self):
#
#         if self.request.method == 'GET':
#             queryset = Sign.objects.all()
#             filter = self.request.GET.get('q')
#
#             if(filter):
#                 queryset = queryset.filter(sign_name__icontains=filter) 
#                 return queryset
#
#         return Sign.objects.order_by('sign_name')
