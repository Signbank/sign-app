from django.http import HttpResponse
from dictionary.Graph import Graph


def search_with_sign_properties(reqeust):
    test = Graph('../../data_scripts/Data/sign_property_data.txt')

    return HttpResponse('hi')
