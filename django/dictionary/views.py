from pathlib import Path
from rest_framework.decorators import api_view
from rest_framework.response import Response
from dictionary.serializers import PropertyTypeSerializer
from dictionary.graph import Graph
from django.conf import settings

# Create a global variable this keeps the graph in memory
graph = Graph()
file_path = Path(settings.BASE_DIR) / 'Data/sign_property_data.txt'
graph.create_graph_from_file(file_path)


@api_view(['POST'])
def search_with_sign_properties(request):
    """
    API endpoint that return sign properties with which the user can search for a sign.
    It uses a graph datastructure to pick the right properties and return them to the user.
    """
    # Get data from request and put it in a list
    node_list = [(item['group'], item['index']) for item in request.data]

    # Pick the best set to ask the user
    property_set = graph.pick_property_set(node_list)

    list_of_sign_ids = []
    for node in property_set:
        for sign_id in node.sign_ids:
            list_of_sign_ids.append(sign_id)

    # Return signs ids when there are only a few left
    # Or when there is only one option return the list of signs because there is no choice
    if len(list_of_sign_ids) <= 5 or len(property_set) == 2:
        return Response(list_of_sign_ids)

    group_type = ''

    if property_set[0].group == 0:
        group_type = 'location'

    if property_set[0].group == 1:
        group_type = 'movement'

    if property_set[0].group == 2:
        group_type = 'handshape'

    pt = Propery_type(group_type, property_set)

    serializer = PropertyTypeSerializer(pt)

    return Response(serializer.data)


class Propery_type:
    """
    """

    def __init__(self, group_type, nodes):
        self.group_type = group_type
        self.properties = nodes
