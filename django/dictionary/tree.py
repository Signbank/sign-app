import json
import numpy as np


class Tree:
    """
    This class manages the different sign properties for the search by properties feature.
    The different properties are stored in their respective lists and can be managed by the different methods in this class.
    """

    def __init__(self):
        self.nodes = []

    def create_from_file(self, file_path):

        if not file_path.exists():
            return

        with open(file_path, 'r', encoding='utf-8') as file:
            dictionary_of_signs = json.load(file)

        self.weight_dictionary = {}

        for key in dictionary_of_signs:
            self.weight_dictionary[key] = dictionary_of_signs[key].pop(0)

        parent_node = Node('p', list(dictionary_of_signs.keys()))

        best_index = self.get_best_spread_of_signs(dictionary_of_signs, self.weight_dictionary, 3)
        self.add_edges(parent_node, dictionary_of_signs, best_index)

        self.nodes = parent_node.edges

    def get_best_spread_of_signs(self, dictionary_of_signs, weight_dictionary, number_of_items):
        if number_of_items == 1:
            return 0

        list_of_weight_dictionaries = [{} for _ in range(number_of_items)]

        for i, sign_id in enumerate(dictionary_of_signs):
            sign = dictionary_of_signs[sign_id]
            weight = weight_dictionary[sign_id]

            for j, property in enumerate(sign):
                property_weight_dictionary = list_of_weight_dictionaries[j]
                if property in property_weight_dictionary:
                    property_weight_dictionary[property] += weight
                else:
                    property_weight_dictionary[property] = weight

            if i >= 5 or i == len(dictionary_of_signs)-1:
                return self.get_index_of_best_spread_set(list_of_weight_dictionaries)
                break

    def get_index_of_best_spread_set(self, list_of_weight_dictionaries):
        best_set = 999999999
        best_index = -1
        for i, dic in enumerate(list_of_weight_dictionaries):
            weight_list = list(dic.values())
            std = np.std(weight_list)
            if std < best_set:
                best_set = std
                best_index = i

        return best_index

    def add_edges(self, node, dictionary_of_signs, best_set_index):
        for sign_id in node.sign_ids:
            sign = dictionary_of_signs[sign_id]
            if sign == []:
                break
            property = sign.pop(best_set_index)

            edge = Node(property, [sign_id])
            node.add_edge(edge)

        for edge in node.edges:
            self.add_edges(edge, dictionary_of_signs, len(sign)-1)

    def get_next_node_list_for_user(self, list_of_node_indexes):
        """
        Retrieves and return the node base on the list of indexes
        """
        node_list = self.nodes

        for index in list_of_node_indexes:
            if index >= len(node_list):
                return []
            node_list = node_list[index].edges

        return node_list

    def __str__(self):
        return_string = ""

        for node in self.nodes:
            return_string = return_string + str(node) + "\n"

        return return_string

    def __eq__(self, other):
        if Tree != type(other):
            return False

        if self.nodes != other.nodes:
            return False

        return True


class Node:
    """
    This class represents a property in the tree
    It holds a list of edges that represent all
    the other properties that are used in the same sign as this property
    """

    def __init__(self, identifier, sign_ids=[]):
        self.identifier = identifier
        self.edges = []
        self.sign_ids = sign_ids

    def add_edge(self, new_edge):
        """
        This method checks if this node already contains the same edge.
        This make sure there are no duplicate edges
        """
        try:
            edge_index = self.edges.index(new_edge)
            if new_edge.sign_ids != []:
                self.edges[edge_index].add_sign_id(new_edge.sign_ids[0])
        except ValueError:
            self.edges.append(new_edge)

    def add_sign_id(self, sign_id):
        """
        Checks if a sign id is already pressant before adding it.
        This way there are no duplicate id's
        """
        if sign_id not in self.sign_ids:
            self.sign_ids.append(sign_id)

    def __eq__(self, other):
        if Node != type(other):
            return False

        if self.identifier != other.identifier:
            return False

        if self.edges != other.edges:
            return False

        return True

    def __str__(self):
        return_string = f"Node Id:{self.identifier}, sign id's: {self.sign_ids}"
        return return_string
