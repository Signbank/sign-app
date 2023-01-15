from rest_framework import serializers
from dictionary.graph import Node


class NodeSerializer(serializers.Serializer):
    """
    A class that allows the Node class to be serialized and send in json format
    """

    identifier = serializers.IntegerField(read_only=True)
    group = serializers.IntegerField(read_only=True)

    def desirialize_list(self):
        """
        Return a list of Nodes instances
        """
        list_of_instances = []
        for item in self.initial_data:
            try:
                node = Node(item['identifier'], item['group'])
                list_of_instances.append(node)
            except KeyError:
                raise serializers.ValidationError("Missing required fields")
            except ValueError:
                raise serializers.ValidationError("Invalid data type")
        return list_of_instances
