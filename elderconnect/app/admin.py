from django.contrib import admin
from .models import Reminder, BloodPressure

# Register your models here.
admin.site.register(Reminder)
admin.site.register(BloodPressure)