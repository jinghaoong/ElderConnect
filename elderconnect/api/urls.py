from rest_framework import routers
from .views import ReminderViewSet

router = routers.DefaultRouter()
router.register(r'api_reminders', ReminderViewSet, basename='api-reminder')

urlpatterns = router.urls
