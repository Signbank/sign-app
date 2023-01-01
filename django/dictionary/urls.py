from django.urls import include, path
from rest_framework import routers
from dictionary import views

router = routers.DefaultRouter()
router.register(r'signs', views.SignViewSet)

# Wire up our API using automatic URL routing.
# Additionally, we include login URLs for the browsable API.
urlpatterns = [
    path('', include(router.urls)),
]
        # path('', views.IndexView.as_view(), name='index'),
