from django.db import models


class UserQuizList(models.Model):
    """
    Model representing meta data from the user of list of signs.
    """
    user = models.IntegerField(default=0)
    name = models.CharField(max_length=100)
    sign_ids = models.CharField(max_length=100)
    last_practiced = models.DateTimeField(null=True, blank=True)
    last_sign_index = models.IntegerField(default=0)
