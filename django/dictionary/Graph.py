import json
import numpy as np


class Graph:
    LOCATION = 0
    MOVEMENT = 1
    HANDSHAPE = 2

    def __init__(self):

        self.location_nodes = []
        self.movement_nodes = []
        self.handshape_nodes = []

    def create_graph_from_file(self, file_string):

        file = open(file_string, 'r')
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
        match new_node.type:
            case self.LOCATION:
                return self.add_to_list(new_node, self.location_nodes)
            case self.MOVEMENT:
                return self.add_to_list(new_node, self.movement_nodes)
            case self.HANDSHAPE:
                return self.add_to_list(new_node, self.handshape_nodes)

        return new_node

    def add_to_list(self, new_node, node_list):
        for node in node_list:
            if node.id == new_node.id:
                return node

        node_list.append(new_node)
        return new_node

    def pick_best_set(self):
        location_spread = self.calculated_set_value(self.location_nodes)
        movement_spread = self.calculated_set_value(self.movement_nodes)
        handshapes_spread = self.calculated_set_value(self.handshape_nodes)

        if location_spread < movement_spread and \
                location_spread < handshapes_spread:
            return self.location_nodes
        elif movement_spread < location_spread and \
                movement_spread < handshapes_spread:
            return self.movement_nodes

        return self.handshape_nodes

    def pick_second_set(self, picked_node):
        set_of_weights = []

        picked_node.edges.sort(reverse=True)

        first_type = picked_node.edges[0].node.type
        second_type = picked_node.edges[-1].node.type

        current_type = first_type

        temp_list = []
        for edge in picked_node.edges:
            if edge.node.type != current_type:
                current_type = edge.node.type
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
                    if x.node.type == first_type]

        return [x.node for x in picked_node.edges
                if x.node.type == second_type]

    def pick_third_set(self, first_node, second_node):
        return [x.node for x in second_node.edges if x in first_node.edges]

    def calculated_set_value(self, node_list):
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
    def __init__(self, id, type):
        self.id = id
        self.type = type
        self.edges = []

    def add_edge(self, new_edge):
        for edge in self.edges:
            if edge == new_edge:
                edge.weight += new_edge.weight
                return edge.node

        self.edges.append(new_edge)
        return new_edge.node

    def __eq__(self, other):
        if Node != type(other):
            return False

        if self.id != other.id:
            return False

        if self.type != other.type:
            return False

        if self.edges != other.edges:
            return False

        return True

    def __lt__(self, other):
        if Node != type(other):
            return False

        return self.type < other.type

    def __str__(self):
        return_string = f"Node Id:{self.id}, Type:{self.type}"
        for edge in self.edges:
            return_string += f"\n       Edge: {edge}"

        return return_string


class Edge:
    def __init__(self, node, weight):
        self.node = node
        self.weight = weight

    def __eq__(self, other):
        if Edge != type(other):
            return False

        # compare values of nodes instead of
        # nodes self to avoid possible infinite recursion
        if self.node.id != other.node.id:
            return False

        if self.node.type != other.node.type:
            return False

        return True

    def __lt__(self, other):
        if Edge != type(other):
            return False

        return (self.node.type, self.weight) < (other.node.type, other.weight)

    def __str__(self):
        return f"Weight:{self.weight}, \
               To: id:{self.node.id} type:{self.node.type}"
