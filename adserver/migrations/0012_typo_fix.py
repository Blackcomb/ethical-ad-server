# -*- coding: utf-8 -*-
# Generated by Django 1.11.23 on 2020-01-27 18:09
from __future__ import unicode_literals

from django.db import migrations
from django.db import models


class Migration(migrations.Migration):

    dependencies = [
        ('adserver', '0011_data-calculate-flight-impressions'),
    ]

    operations = [
        migrations.AlterField(
            model_name='advertiser',
            name='slug',
            field=models.SlugField(max_length=200, verbose_name='Advertiser Slug'),
        ),
    ]
