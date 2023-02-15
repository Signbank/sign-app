from rest_framework import serializers


class NodeSerializer(serializers.Serializer):
    """
    A class that allows the Node class to be serialized and send in json format
    """

    identifier = serializers.CharField()
    sign_ids = serializers.ListField(child=serializers.IntegerField())
