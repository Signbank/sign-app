import sqlite3
from sqlite3 import Error

def get_all_glosses(conn):
    cur = conn.cursor()

    cur.execute("SELECT G.id, G.locprim, G.movDir, G.domhndsh FROM dictionary_gloss G INNER JOIN dictionary_lemmaidgloss L ON G.lemma_id = L.id WHERE L.dataset_id = 5 AND G.locprim IS NOT NULL AND G.locprim IS NOT 0 AND G.movDir IS NOT NULL AND G.movDir IS NOT 0 AND G.domhndsh IS NOT NULL AND G.domhndsh IS NOT 0")

    return cur.fetchall()

class Graph:
    def __init__(self):
        self.nodes = []

    def add_node(self, new_node):
        for node in self.nodes:
            if node == new_node:
                return node

        self.nodes.append(new_node)
        return new_node

    def search(self, first_input, second_input):
       for node in self.nodes:
           if node == first_input:

               if None != second_input:
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
            return True;

        return False;

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
        return f"Weight:{self.weight}, To: id:{self.node.id} type:{self.node.type}"

    def __lt__(self, other):
        return (self.node.type, self.weight) < (other.node.type, other.weight)

if __name__ == '__main__':
    LOCATION = 1
    MOVEMENT = 2
    HANDSHAPE = 3

    glosses = []

    db_file =r"./Data/signbank.db"
    conn = None

    graph = Graph()

    try:
        conn = sqlite3.connect(db_file)
        glosses = get_all_glosses(conn)
       
        for gloss in glosses:
            # location_node  = graph.add_node(Node(gloss[LOCATION], LOCATION))
            # movement_node  = graph.add_node(Node(gloss[MOVEMENT], MOVEMENT))
            handshape_node = graph.add_node(Node(gloss[HANDSHAPE], HANDSHAPE))

            edge_weight = 1

            movement_node = Node(gloss[MOVEMENT], MOVEMENT)
            location_node = Node(gloss[LOCATION], LOCATION)

            movement_node = handshape_node.add_edge(Edge(movement_node,edge_weight))
            location_node = handshape_node.add_edge(Edge(location_node,edge_weight))

            movement_node.add_edge(Edge(location_node, edge_weight))
            location_node.add_edge(Edge(movement_node, edge_weight))

    except Error as e:
        print(e)
    finally:
        if conn:
            conn.close()

        edges = graph.search(Node('6',3), None)
        # edges = graph.search(Node('48',3), None)
        # edges = graph.search(Node('48',3), Node('89',2))
        # edges = graph.search(Node('48',3), Node('3',1))
        if edges != None:
            for edge in edges:
                print(edge)
        else:
            print("No options available")
