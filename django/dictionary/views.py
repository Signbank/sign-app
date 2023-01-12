from django.http import HttpResponse
from dictionary.graph import Graph


def search_with_sign_properties():
    """
    API endpoint that return sign properties with which the user can search for a sign.
    It uses a graph datastructure to pick the right properties and return them to the user.
    """
    graph = Graph()
    graph.create_graph_from_file('../../data_scripts/Data/sign_property_data.txt')

    print(graph)

    return HttpResponse('hi')
