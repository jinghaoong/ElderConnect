from datetime import date
from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated

from .serializers import ReminderSerializer, BPSerializer
from app.models import Reminder, BloodPressure


class ReminderViewSet(viewsets.ModelViewSet):
    serializer_class = ReminderSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Reminder.objects.filter(user=self.request.user).exclude(date_end__lt=date.today()).order_by('time_1', 'date_end')


class ReminderArchiveViewSet(viewsets.ModelViewSet):
    serializer_class = ReminderSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Reminder.objects.filter(user=self.request.user).exclude(date_end__gte=date.today()).order_by('-date_end')


class BloodPressureViewSet(viewsets.ModelViewSet):
    serializer_class = BPSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return BloodPressure.objects.filter(user=self.request.user).order_by('-date', 'time')
