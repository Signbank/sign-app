import json
import numpy as np


class Graph:
    LOCATION = 0
    MOVEMENT = 1
    HANDSHAPE = 2

    def __init__(self):

        self.nodes = []
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

        self.nodes = sorted(self.nodes)

    def add_node(self, new_node):
        for node in self.nodes:
            if node == new_node:
                return node

        self.nodes.append(new_node)
        return new_node

    def pick_best_set(self):
        location = []
        movement = []
        handshapes = []

        for node in self.nodes:
            match node.type:
                case self.LOCATION:
                    location += [x.weight for x in node.edges]

                case self.MOVEMENT:
                    movement += [x.weight for x in node.edges]

                case self.HANDSHAPE:
                    handshapes += [x.weight for x in node.edges]

        location_spread = np.std(location) * np.ptp(location)
        movement_spread = np.std(movement) * np.ptp(movement)
        handshapes_spread = np.std(handshapes) * np.ptp(handshapes)

        print(location_spread)
        print(movement_spread)
        print(handshapes_spread)

    def __eq__(self, other):
        if Graph != type(other):
            return False

        if self.nodes != other.nodes:
            return False

        return True

    def __str__(self):
        return_string = ""
        for node in self.nodes:
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

        # compare values of nodes instead of nodes self to avoid possible infinite recursion
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



if __name__ == '__main__':

    graph = Graph()
    graph.create_graph_from_file('../data_scripts/Data/sign_property_data.txt')

    print(graph)
    # graph.pick_best_set()
