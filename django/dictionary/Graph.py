import json


class Graph:
    LOCATION = 0
    MOVEMENT = 1
    HANDSHAPE = 2

    def __init__(self, file_string):
        self.create_graph_from_file(file_string)
        self.nodes = []

    def create_graph_from_file(self, file_string):
        file = open(file_string, 'r')
        properties = json.load(file)

    def add_node(self, new_node):
        for node in self.nodes:
            if node == new_node:
                return node

        self.nodes.append(new_node)
        return new_node

    def search(self, first_input, second_input):
        for node in self.nodes:
            if node == first_input:

                if second_input is not None:
                    for edge in node.edges:
                        if edge.node == second_input:
                            return sorted(edge.node.edges, reverse=True)

                return sorted(node.edges, reverse=True)

    def __str__(self):
        return_string = ""
        for node in self.nodes:
            return_string = return_string + node.__str__() + "\n"

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

    def __eq__(self, node):
        if type(node) != Node:
            return False

        if self.id == node.id and self.type == node.type:
            return True

        return False

    def __str__(self):
        return_string = f"Node Id:{self.id}, Type:{self.type}"
        for edge in self.edges:
            return_string += f"\n       Edge: {edge}"

        return return_string


class Edge:
    def __init__(self, node, weight):
        self.node = node
        self.weight = weight

    def __eq__(self, edge):
        if type(edge) != Edge:
            return False

        if edge.node == self.node:
            return True

        return False

    def __str__(self):
        return f"Weight:{self.weight}, \
               To: id:{self.node.id} type:{self.node.type}"

    def __lt__(self, other):
        return (self.node.type, self.weight) < (other.node.type, other.weight)


if __name__ == '__main__':
    LOCATION = 1
    MOVEMENT = 2
    HANDSHAPE = 3

    glosses = []

    db_file = r"./Data/signbank.db"
    conn = None

    graph = Graph()

    for gloss in glosses:
        # location_node  = graph.add_node(Node(gloss[LOCATION], LOCATION))
        # movement_node  = graph.add_node(Node(gloss[MOVEMENT], MOVEMENT))
        handshape_node = graph.add_node(Node(gloss[HANDSHAPE], HANDSHAPE))

        edge_weight = 1

        movement_node = Node(gloss[MOVEMENT], MOVEMENT)
        location_node = Node(gloss[LOCATION], LOCATION)

        movement_node = handshape_node.add_edge(
                Edge(movement_node, edge_weight))
        location_node = handshape_node.add_edge(
                Edge(location_node, edge_weight))

        movement_node.add_edge(Edge(location_node, edge_weight))
        location_node.add_edge(Edge(movement_node, edge_weight))

    edges = graph.search(Node('6', 3), None)
    # edges = graph.search(Node('48',3), None)
    # edges = graph.search(Node('48',3), Node('89',2))
    # edges = graph.search(Node('48',3), Node('3',1))
    if edges is not None:
        for edge in edges:
            print(edge)
    else:
        print("No options available")
