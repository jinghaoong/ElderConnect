from rest_framework import serializers
from app.models import Reminder, BloodPressure


class ReminderSerializer(serializers.ModelSerializer):
    user = serializers.HiddenField(default=serializers.CurrentUserDefault())
    
    class Meta:
        model = Reminder
        fields = '__all__'


class BPSerializer(serializers.ModelSerializer):
    user = serializers.HiddenField(default=serializers.CurrentUserDefault())

    class Meta:
        model = BloodPressure
        fields = '__all__'