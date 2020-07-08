from rest_framework import routers
from .views import ReminderViewSet, ReminderArchiveViewSet, BloodPressureViewSet

router = routers.DefaultRouter()
router.register(r'api_reminders', ReminderViewSet, basename='api-reminder')
router.register(r'api_reminders_archive', ReminderArchiveViewSet, basename='api-reminder-archive')
router.register(r'api_bp', BloodPressureViewSet, basename='api-bp')

urlpatterns = router.urls
