from django.urls import path
from dictionary import views

urlpatterns = [
        path(r'search', views.search_with_sign_properties,
             name='search properties')
]
