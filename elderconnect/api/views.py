from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response 
from rest_framework import viewsets, views

from .serializers import ReminderSerializer
from app.models import Reminder


