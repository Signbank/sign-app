from pathlib import Path
from rest_framework.decorators import api_view
from rest_framework.response import Response
from dictionary.serializers import NodeIndexSerializer
from dictionary.graph import Graph
from django.conf import settings

# Create a global variable this keeps the graph in memory
graph = Graph()
file_path = Path(settings.BASE_DIR) / 'Data/sign_property_data.txt'
# graph.create_graph_from_file('../data_scripts/Data/sign_property_data.txt')
graph.create_graph_from_file(file_path)


@api_view(['POST'])
def search_with_sign_properties(request):
    """
    API endpoint that return sign properties with which the user can search for a sign.
    It uses a graph datastructure to pick the right properties and return them to the user.
    """

    # Get data from request and put it in a list
    serializer = NodeIndexSerializer(data=request.data)
    node_list = serializer.desirialize_list()

    # Pick the best set to ask the user
    property_set = graph.pick_property_set(node_list)
    serializer = NodeIndexSerializer(property_set, many=True)
    return Response(serializer.data)
