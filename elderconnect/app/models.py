from django.db import models
from django.contrib.auth.models import User
from django.urls import reverse
from django.core.validators import MaxValueValidator
from datetime import date
from PIL import Image


class Reminder(models.Model):
    title = models.CharField(max_length=100)
    description = models.CharField(max_length=300)
    date_current = models.DateField(default=date.today)
    date_end = models.DateField()
    time_1 = models.TimeField()
    time_2 = models.TimeField(blank=True, null=True)
    time_3 = models.TimeField(blank=True, null=True)
    time_4 = models.TimeField(blank=True, null=True)
    medicine_image = models.ImageField(default='default.jpg', upload_to='reminders')
    user = models.ForeignKey(User, on_delete=models.CASCADE)

    def __str__(self):
        return self.title

    def save(self, *args, **kwargs):
        super(Reminder, self).save(*args, **kwargs)

        img = Image.open(self.medicine_image.path)

        if img.height > 300 or img.width > 500:
            output_size = (300, 500)
            img.thumbnail(output_size)
            img.save(self.medicine_image.path)

    def get_absolute_url(self):
        return reverse('web-reminder-detail', kwargs={'pk': self.pk})


class BloodPressure(models.Model):
    title = models.CharField(max_length=100)
    comments = models.CharField(max_length=300)
    date = models.DateField(default=date.today)
    time = models.TimeField()
    systolic = models.PositiveIntegerField(validators=[MaxValueValidator(200)])
    diastolic = models.PositiveIntegerField(validators=[MaxValueValidator(150)])
    user = models.ForeignKey(User, on_delete=models.CASCADE)

    def __str__(self):
        return self.title

    def get_absolute_url(self):
        return reverse('web-bp-detail', kwargs={'pk': self.pk})