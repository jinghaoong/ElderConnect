from rest_framework import serializers
from app.models import Reminder, BloodPressure


class ReminderSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Reminder
        fields = ['url', 'id', 'title', 'description', 'date_current', 'date_end',
                    'time_1', 'time_2', 'time_3', 'time_4', 'medicine_image']
