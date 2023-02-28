from django.db import models


class Sign(models.Model):
    """
    Info for the sign which the user learns.

    NOTE: should be replaced by a list of sign ids

    """
    name = models.CharField(max_length=100)
    video_url = models.CharField(max_length=100)
    image_url = models.CharField(max_length=100)


class SignList(models.Model):
    """
    Model representing a list of signs from that can be used to learn those signs.
    """
    name = models.CharField(max_length=100)
    signs = models.ManyToManyField(Sign)


class UserSignList(models.Model):
    """
    Model representing meta data from the user of list of signs.
    """
    user = models.IntegerField(default=0)
    sign_list = models.ForeignKey(SignList, on_delete=models.CASCADE)
    last_practiced = models.DateTimeField(null=True, blank=True)
    last_sign_index = models.IntegerField(default=0)
