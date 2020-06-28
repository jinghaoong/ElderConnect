from rest_framework import serializers
from app.models import Reminder, BloodPressure


class ReminderSerializer(serializers.ModelSerializer):
    class Meta:
        model = Reminder
        fields = '__all__'
