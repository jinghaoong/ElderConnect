# Generated by Django 3.0.7 on 2020-06-29 09:44

import django.core.validators
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0003_bloodpressure'),
    ]

    operations = [
        migrations.AlterField(
            model_name='bloodpressure',
            name='diastolic',
            field=models.PositiveIntegerField(validators=[django.core.validators.MaxValueValidator(150)]),
        ),
        migrations.AlterField(
            model_name='bloodpressure',
            name='systolic',
            field=models.PositiveIntegerField(validators=[django.core.validators.MaxValueValidator(200)]),
        ),
    ]
