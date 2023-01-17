from rest_framework import serializers
from dictionary.graph import Node


class NodeSerializer(serializers.Serializer):
    """
    A class that allows the Node class to be serialized and send in json format
    """

    identifier = serializers.CharField()
    group = serializers.IntegerField(read_only=True)
    index = serializers.IntegerField(read_only=True)

    def create(self, validated_data):
        """
        Override base methode
        """
        return Node(validated_data.get['identifier'], validated_data.get['group'])

    def update(self, instance, validated_data):
        """
        Update a node instace
        """
        instance.identifier = validated_data.get('identifier', instance.identifier)
        instance.group = validated_data.get('group', instance.group)
        instance.index = validated_data.get('index', instance.index)

        return instance
