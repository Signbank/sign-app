"""Module for use of graph with different sign properties"""
import json
import numpy as np


class Graph:
    """
    This class manages the different sign properties
    for the search by properties feature.
    The different properties are stored in theire
    respecitve lists and can be managed by the
    different methodes in this class.

    A property is a node of the graph and has at least two outgoing edges.
    These edges are the properties that are al used in a sign.
    """

    LOCATION = 0
    MOVEMENT = 1
    HANDSHAPE = 2

    def __init__(self):

        self.location_nodes = []
        self.movement_nodes = []
        self.handshape_nodes = []

    def create_graph_from_file(self, file_path):
        """
        This function creates the graph from a file that is
        generated by the data scripts.
        It is based of the different sign properties and
        relevanance base on the value in that file.
        """

        if not file_path.exists():
            return

        with open(file_path, 'r', encoding='utf-8') as file:
            dic_of_properties = json.load(file)

        for item in dic_of_properties.values():
            weight = item[0]
            location = item[1]
            movement = item[2]
            handshape = item[3]

            loc_node = Node(location, self.LOCATION)
            mov_node = Node(movement, self.MOVEMENT)
            hand_node = Node(handshape, self.HANDSHAPE)

            loc_node = self.add_node(loc_node)
            mov_node = self.add_node(mov_node)
            hand_node = self.add_node(hand_node)

            loc_node.add_edge(Edge(mov_node, weight))
            loc_node.add_edge(Edge(hand_node, weight))

            mov_node.add_edge(Edge(loc_node, weight))
            mov_node.add_edge(Edge(hand_node, weight))

            hand_node.add_edge(Edge(loc_node, weight))
            hand_node.add_edge(Edge(mov_node, weight))

        self.location_nodes.sort()
        self.movement_nodes.sort()
        self.handshape_nodes.sort()

    def add_node(self, new_node):
        """
        Adds a new node to the correct list
        """
        node = self.get_node_if_exists(new_node)

        if node is not None:
            return node

        match new_node.group:
            case self.LOCATION:
                self.location_nodes.append(new_node)
            case self.MOVEMENT:
                self.movement_nodes.append(new_node)
            case self.HANDSHAPE:
                self.handshape_nodes.append(new_node)

        return new_node

    def get_node_if_exists(self, node):
        """
        Check the correct list by group if the node exists
        """
        match node.group:
            case self.LOCATION:
                return self.get_node_from_list(node, self.location_nodes)
            case self.MOVEMENT:
                return self.get_node_from_list(node, self.movement_nodes)
            case self.HANDSHAPE:
                return self.get_node_from_list(node, self.handshape_nodes)

    def get_node_from_list(self, new_node, node_list):
        """
        Checks if the node is already in the list and return it if it does
        """
        for node in node_list:
            if node.identifier == new_node.identifier:
                return node

        return None

    def pick_property_set(self, list_of_chosen_nodes):
        """
        Pick the best property based on already chosen nodes
        """

        for node in list_of_chosen_nodes:
            node = self.get_node_if_exists(node)

        match len(list_of_chosen_nodes):
            case 0:
                return self.pick_first_set()
            case 1:
                return self.pick_second_set(list_of_chosen_nodes[0])
            case 2:
                return self.pick_third_set(list_of_chosen_nodes[0], list_of_chosen_nodes[1])

    def pick_first_set(self):
        """
        Returns the list of nodes that has the most even spread
        """
        location_spread = self.calculated_set_spread(self.location_nodes)
        movement_spread = self.calculated_set_spread(self.movement_nodes)
        handshapes_spread = self.calculated_set_spread(self.handshape_nodes)

        if location_spread < movement_spread and \
                location_spread < handshapes_spread:
            return self.location_nodes

        if movement_spread < location_spread and \
                movement_spread < handshapes_spread:
            return self.movement_nodes

        return self.handshape_nodes

    def pick_second_set(self, picked_node):
        """
        Pick the best spread propertie from all the outgoing edges
        from the chosen node
        """
        set_of_weights = []

        picked_node.edges.sort(reverse=True)

        first_group = picked_node.edges[0].node.group
        second_group = picked_node.edges[-1].node.group

        current_group = first_group

        temp_list = []
        for edge in picked_node.edges:
            if edge.node.group != current_group:
                current_group = edge.node.group
                set_of_weights.append(temp_list)
                temp_list = []

            temp_list.append(edge.weight)

        set_of_weights.append(temp_list)

        first_set_spread = np.std(set_of_weights[0]) * \
            np.ptp(set_of_weights[0])
        second_set_spread = np.std(set_of_weights[1]) * \
            np.ptp(set_of_weights[1])

        if first_set_spread < second_set_spread:
            return [x.node for x in picked_node.edges
                    if x.node.group == first_group]

        return [x.node for x in picked_node.edges
                if x.node.group == second_group]

    def pick_third_set(self, first_node, second_node):
        """
        This function returns all the nodes
        that are in the first and second node
        """
        return [x.node for x in second_node.edges if x in first_node.edges]

    def calculated_set_spread(self, node_list):
        """
        Looks to all the weights form all edges of the node list
        and returns the spread of these weights.
        """
        weight_list = []

        for node in node_list:
            weight_list += [x.weight for x in node.edges]

        return np.std(weight_list) * np.ptp(weight_list)

    def __eq__(self, other):
        if Graph != type(other):
            return False

        if self.location_nodes != other.location_nodes:
            return False

        if self.movement_nodes != other.movement_nodes:
            return False

        if self.handshape_nodes != other.handshape_nodes:
            return False

        return True

    def __str__(self):
        return_string = ""
        for node in self.location_nodes:
            return_string = return_string + str(node) + "\n"

        for node in self.movement_nodes:
            return_string = return_string + str(node) + "\n"

        for node in self.handshape_nodes:
            return_string = return_string + str(node) + "\n"
        return return_string


class Node:
    """
    This class reperesents a propertie in the graph
    It holds a list of edges that represent all
    the other properties that are used in the same
    sign as this propertie
    """

    def __init__(self, identifier, group):
        self.identifier = identifier
        self.group = group
        self.edges = []

    def add_edge(self, new_edge):
        """
        This methode checks if this node already contains
        the same edge.
        This make sure there are no duplicate edges
        """
        for edge in self.edges:
            if edge == new_edge:
                edge.weight += new_edge.weight
                return edge.node

        self.edges.append(new_edge)
        return new_edge.node

    def __eq__(self, other):
        if Node != type(other):
            return False

        if self.identifier != other.identifier:
            return False

        if self.group != other.group:
            return False

        if self.edges != other.edges:
            return False

        return True

    def __lt__(self, other):
        if Node != type(other):
            return False

        return self.group < other.group

    def __str__(self):
        return_string = f"Node Id:{self.identifier}, group:{self.group}"
        for edge in self.edges:
            return_string += f"\n       Edge: {edge}"

        return return_string


class Edge:
    """
    An edge represents the link between two properties that er used in the same sign
    """

    def __init__(self, node, weight):
        self.node = node
        self.weight = weight

    def __eq__(self, other):
        if Edge != type(other):
            return False

        # compare values of nodes instead of
        # nodes self to avoid possible infinite recursion
        if self.node.identifier != other.node.identifier:
            return False

        if self.node.group != other.node.group:
            return False

        return True

    def __lt__(self, other):
        if Edge != type(other):
            return False

        return (self.node.group, self.weight) < (other.node.group, other.weight)

    def __str__(self):
        return f"Weight:{self.weight}, \
               To: id:{self.node.identifier} group:{self.node.group}"
