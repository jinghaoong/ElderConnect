from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated

from .serializers import ReminderSerializer
from app.models import Reminder


class ReminderViewSet(viewsets.ModelViewSet):
    serializer_class = ReminderSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Reminder.objects.filter(user=self.request.user)
