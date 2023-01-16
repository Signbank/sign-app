from rest_framework import serializers


class NodeIndexSerializer(serializers.Serializer):
    """
    A class that allows the Node class to be serialized and send in json format
    """

    group = serializers.IntegerField(read_only=True)
    index = serializers.IntegerField(read_only=True)

    def create(self, validated_data):
        """
        Override base methode
        """
        return (validated_data.get['group'], validated_data.get['index'])

    def update(self, instance, validated_data):
        """
        Update a tuple instace
        """
        instance.group = validated_data.get('group', instance.group)
        instance.index = validated_data.get('index', instance.index)

        return instance

    def desirialize_list(self):
        """
        Return a list of tuples that contain the group and index of the nodes
        """
        return [(item['group'], item['index']) for item in self.initial_data]
