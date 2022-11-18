from django.db import models

# Create your models here.
class Sign(models.Model):
    sign_name = models.CharField(max_length=100)
    video_url = models.CharField(max_length=200)
