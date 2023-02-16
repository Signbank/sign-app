from pathlib import Path
from rest_framework.decorators import api_view
from rest_framework.response import Response
from dictionary.serializers import NodeSerializer
from dictionary.tree import Tree
from django.conf import settings

# Create a global variable this keeps the tree in memory
tree = Tree()
file_path = Path(settings.BASE_DIR) / 'Data/sign_property_data.txt'
tree.create_from_file(file_path)


@api_view(['POST'])
def search_with_sign_properties(request):
    """
    API endpoint that return sign properties with which the user can search for a sign.
    It uses a tree data structure to pick the right properties and return them to the user.
    """
    # Get data from request and put it in a list
    chosen_property_indexes = request.data

    node_list = tree.get_next_node_list_for_user(chosen_property_indexes)

    serializer = NodeSerializer(node_list, many=True)

    return Response(serializer.data)
