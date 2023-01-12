import os
from dictionary.graph import Graph, Node, Edge
from django.test import TestCase


class EdgeTestCase(TestCase):
    """Test class for the Edge class in the graph"""

    def setUp(self):
        """Create a edge that all the test can use to compare"""
        self.expected = Edge(Node(1, 0), 1)

    def test_edge_not_equal_type(self):
        """Test if edge==other_type returns false, so only an edge can be compared to an edge"""
        actual = Node(1, 0)
        self.assertNotEqual(self.expected, actual)

    def test_edge_not_equal_node_id(self):
        """Test if comparing edges with a node that has another id returns false"""
        actual = Edge(Node(2, 0), 1)
        self.assertNotEqual(self.expected, actual)

    def test_edge_not_equal_node_type(self):
        """Test if comparing edges with a node that has another type returns false"""
        actual = Edge(Node(1, 1), 1)
        self.assertNotEqual(self.expected, actual)

    def test_edge_equal_values(self):
        """Test if comparing the same edges returns true"""
        actual = Edge(Node(1, 0), 1)
        self.assertEqual(self.expected, actual)

    def test_edge_less_then_other_type(self):
        """Test if edge<other_type returns false"""
        actual = Node(1, 0)
        self.assertNotEqual(self.expected, actual)

    def test_edge_less_then_other_node_type(self):
        """
        Test if an edge is less than other edge with another node type
        Edges are sorted by node type and edge weight
        """
        actual = Edge(Node(1, 1), 1)
        self.assertLess(self.expected,  actual)

    def test_edge_less_then_other_weight(self):
        """Test if edge is less than other edge with a higher weight"""
        actual = Edge(Node(1, 0), 2)
        self.assertLess(self.expected,  actual)


class NodeTestCase(TestCase):
    """Test class for the node class in the graph"""

    def setUp(self):
        """Create a node that all the test can use to compare"""
        self.expected = Node(1, 0)

    def tearDown(self):
        """Remove all edges that are added after a test"""
        self.expected.edges = []

    def test_node_add_new_edge(self):
        """Test if add edge methode inserts a new node"""
        actual = Node(1, 0)
        actual.add_edge(Edge(Node(1, 0), 1))

        self.expected.edges.append(Edge(Node(1, 0), 1))

        self.assertEqual(len(self.expected.edges), len(actual.edges))

    def test_node_add_exsisting_edge(self):
        """Test if add edge methode return a the node if it already exists"""
        actual = Node(1, 0)
        actual.edges.append(Edge(Node(1, 0), 1))
        actual.add_edge(Edge(Node(1, 0), 2))

        self.expected.edges.append(Edge(Node(1, 0), 3))

        self.assertEqual(len(self.expected.edges), len(actual.edges))
        self.assertEqual(self.expected.edges[0].weight, actual.edges[0].weight)

    def test_node_equal_to_same_valued_node(self):
        """Check if nodes with the same id and type are equal to each other"""
        actual = Node(1, 0)
        self.assertEqual(self.expected, actual)

    def test_node_not_equal_type(self):
        """Check if node with a different type are not equal to each other"""
        actual = Edge(1, 1)
        self.assertNotEqual(self.expected, actual)

    def test_node_not_equal_id(self):
        """Check if node with a different id are not equal to each other"""
        actual = Node(2, 0)
        self.assertNotEqual(self.expected, actual)

    def test_node_not_equal_edges(self):
        """Check if nodes with different edges are not equal to each other"""
        actual = Node(1, 0)
        actual.edges.append(Edge(Node(2, 1), 1))

        self.expected.edges.append(Edge(Node(3, 1), 1))

        self.assertNotEqual(self.expected, actual)

    def test_node_equal_edges(self):
        """Check if nodes with the same edge are equal"""
        actual = Node(1, 0)
        actual.edges.append(Edge(Node(2, 1), 1))

        self.expected.edges.append(Edge(Node(2, 1), 1))

        self.assertEqual(self.expected, actual)

    def test_node_unequal_amount_of_edges(self):
        """Check if nodes with different amount of edges are not equal"""
        actual = Node(1, 0)
        actual_edge = Edge(actual, 1)

        extra_edge = Edge(Node(2, 2), 1)

        actual.add_edge(actual_edge)
        self.expected.add_edge(actual_edge)
        self.expected.add_edge(extra_edge)

        self.assertNotEqual(self.expected, actual)

    def test_node_less_then_other_type(self):
        """Check if node<other_type is false"""
        actual = Edge(Node(1, 0), 1)
        self.assertNotEqual(self.expected, actual)

    def test_node_less_then_other_node_type(self):
        """Check if node is less then node with another type"""
        actual = Node(1, 1)
        self.assertLess(self.expected,  actual)


class GraphTestCase(TestCase):
    """Test class for the graph"""

    def setUp(self):
        """Create a file and a graph that can be used to compare graphs"""

        with open('test_graph.txt', 'w', encoding='utf-8') as file:
            file.write('{"1":[5, 3, 49, 15], "2":[4, 3, 55, 15], "3":[3, 3, 51, 5], "4":[2, 3, 16, 6], "5":[1, 8, 8, 15]}')
            file.close()

        self.expected = self.set_up_test_graph()

    def tearDown(self):
        """Remove graph test file when testing is done"""
        os.remove('test_graph.txt')

    def test_graph_create_from_file(self):
        """Check if the graph created from a file is as expected"""
        actual = Graph()
        actual.create_graph_from_file('test_graph.txt')

        self.assertEqual(self.expected, actual)

    def test_graph_add_node(self):
        """Test add node methode, it checks if the node already exists in and adds it to the correct list"""
        graph = Graph()
        actual = graph.add_node(Node(1, 0))
        expected = Node(1, 0)

        self.assertEqual(expected, actual)
        self.assertEqual(expected, graph.location_nodes[0])

    def test_graph_pick_first_set(self):
        """Test if the node set picked by the methode is equal to the movement nodes"""
        actual = self.expected.pick_first_set()
        expected = self.expected.movement_nodes

        self.assertEqual(expected, actual)

    def test_graph_pick_location_for_second_set(self):
        """Check if all the nodes that are from the best set of edges of the first location node are returned"""
        picked_node = self.expected.location_nodes[0]
        actual = self.expected.pick_second_set(picked_node)
        expected = sorted(self.expected.movement_nodes[0:-1])

        self.assertEqual(expected, actual)

    def test_graph_pick_movement_for_second_set(self):
        """Same test as before but with another chosen node"""
        picked_node = self.expected.movement_nodes[0]
        actual = self.expected.pick_second_set(picked_node)
        expected = [self.expected.location_nodes[0]]

        self.assertEqual(expected, actual)

    def test_graph_pick_handshape_for_second_set(self):
        """Same test as before but with another chosen node"""
        picked_node = self.expected.handshape_nodes[0]
        actual = self.expected.pick_second_set(picked_node)
        expected = [self.expected.movement_nodes[0],
                    self.expected.movement_nodes[1],
                    self.expected.movement_nodes[4]]

        self.assertEqual(expected, actual)

    def test_graph_pick_third_set(self):
        """Check the best when two node are chosen"""
        first = self.expected.handshape_nodes[0]
        second = self.expected.location_nodes[0]
        actual = self.expected.pick_third_set(first, second)
        expected = self.expected.movement_nodes[0:2]

        self.assertEqual(expected, actual)

    def test_graph_calculated_set_value(self):
        """Check if the set value is the same as expected"""
        actual = self.expected.calculated_set_spread(self.expected.handshape_nodes)
        expected = 18.856180831641268

        self.assertEqual(expected, actual)

    def test_graph_not_equal_to_other_type(self):
        """Check if graph==other_type is false"""
        actual = Node(1, 0)

        self.assertNotEqual(self.expected, actual)

    def test_graph_not_equal_other_location_nodes(self):
        """Check if comparing two graphs is false when the locaiton nodes are not the same"""
        actual = Graph()
        actual.add_node(Node(1, 0))

        self.assertNotEqual(self.expected, actual)

    def test_graph_not_equal_other_movement_nodes(self):
        """Same as previous test but with movement node"""
        actual = Graph()
        actual.add_node(Node(1, 1))

        self.assertNotEqual(self.expected, actual)

    def test_graph_not_equal_other_handshape_nodes(self):
        """Same as previous test but with handshape node"""
        actual = Graph()
        actual.add_node(Node(1, 2))

        self.assertNotEqual(self.expected, actual)

    def set_up_test_graph(self):
        """Create a graph that can be compared to generated graphs"""
        graph = Graph()

        nodes = self.set_up_test_nodes()

        for node in nodes:
            graph.add_node(node)

        return graph

    def set_up_test_nodes(self):
        """Set up a list of nodes with coresponing edges for the test graph"""

        location_3 = Node(3, 0)
        location_8 = Node(8, 0)

        movement_49 = Node(49, 1)
        movement_55 = Node(55, 1)
        movement_51 = Node(51, 1)
        movement_16 = Node(16, 1)
        movement_8 = Node(8, 1)

        handshape_15 = Node(15, 2)
        handshape_5 = Node(5, 2)
        handshape_6 = Node(6, 2)

        location_3.add_edge(Edge(movement_49, 5))
        location_3.add_edge(Edge(handshape_15, 5))
        location_3.add_edge(Edge(movement_55, 4))
        location_3.add_edge(Edge(handshape_15, 4))
        location_3.add_edge(Edge(movement_51, 3))
        location_3.add_edge(Edge(handshape_5, 3))
        location_3.add_edge(Edge(movement_16, 2))
        location_3.add_edge(Edge(handshape_6, 2))

        location_8.add_edge(Edge(movement_8, 1))
        location_8.add_edge(Edge(handshape_15, 1))

        movement_49.add_edge(Edge(location_3, 5))
        movement_49.add_edge(Edge(handshape_15, 5))

        movement_55.add_edge(Edge(location_3, 4))
        movement_55.add_edge(Edge(handshape_15, 4))

        movement_51.add_edge(Edge(location_3, 3))
        movement_51.add_edge(Edge(handshape_5, 3))

        movement_16.add_edge(Edge(location_3, 2))
        movement_16.add_edge(Edge(handshape_6, 2))

        movement_8.add_edge(Edge(location_8, 1))
        movement_8.add_edge(Edge(handshape_15, 1))

        handshape_15.add_edge(Edge(location_3, 5))
        handshape_15.add_edge(Edge(movement_49, 5))
        handshape_15.add_edge(Edge(location_3, 4))
        handshape_15.add_edge(Edge(movement_55, 4))
        handshape_15.add_edge(Edge(location_8, 1))
        handshape_15.add_edge(Edge(movement_8, 1))

        handshape_5.add_edge(Edge(location_3, 3))
        handshape_5.add_edge(Edge(movement_51, 3))

        handshape_6.add_edge(Edge(location_3, 2))
        handshape_6.add_edge(Edge(movement_16, 2))

        return [location_3, location_8,
                movement_49, movement_55, movement_51, movement_16, movement_8,
                handshape_15, handshape_5, handshape_6]
