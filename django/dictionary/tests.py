from django.test import TestCase
from dictionary.Graph import Graph, Node, Edge
import os

class EdgeTestCase(TestCase):
    def setUp(self):
        self.expected = Edge(Node(1, 0), 1)

    def test_edge_not_equal_type(self):
        actual = Node(1, 0)
        self.assertNotEqual(self.expected, actual)

    def test_edge_not_equal_node_id(self):
        actual = Edge(Node(2, 0), 1)
        self.assertNotEqual(self.expected, actual)

    def test_edge_not_equal_node_type(self):
        actual = Edge(Node(1, 1), 1)
        self.assertNotEqual(self.expected, actual)

    def test_edge_equal_values(self):
        actual = Edge(Node(1, 0), 1)
        self.assertEqual(self.expected, actual)

    def test_edge_less_then_other_type(self):
        actual = Node(1, 0)
        self.assertNotEqual(self.expected, actual)

    def test_edge_less_then_other_node_type(self):
        actual = Edge(Node(1, 1), 1)
        self.assertLess(self.expected,  actual)

    def test_edge_less_then_other_weight(self):
        actual = Edge(Node(1, 0), 2)
        self.assertLess(self.expected,  actual)


class NodeTestCase(TestCase):
    def setUp(self):
        self.expected = Node(1, 0)

    def test_node_add_new_edge(self):
        actual = Node(1, 0)
        actual.add_edge(Edge(Node(1, 0), 1))

        self.expected.edges.append(Edge(Node(1, 0), 1))

        self.assertEqual(len(self.expected.edges), len(actual.edges))

        self.expected.edges = []

    def test_node_add_exsisting_edge(self):
        actual = Node(1, 0)
        actual.edges.append(Edge(Node(1, 0), 1))
        actual.add_edge(Edge(Node(1, 0), 2))

        self.expected.edges.append(Edge(Node(1, 0), 3))

        self.assertEqual(len(self.expected.edges), len(actual.edges))
        self.assertEqual(self.expected.edges[0].weight, actual.edges[0].weight)

        self.expected.edges = []

    def test_node_equal_to_same_valued_node(self):
        actual = Node(1, 0)
        self.assertEqual(self.expected, actual)

    def test_node_not_equal_type(self):
        actual = Edge(1, 1)
        self.assertNotEqual(self.expected, actual)

    def test_node_not_equal_id(self):
        actual = Node(2, 0)
        self.assertNotEqual(self.expected, actual)

    def test_node_not_equal_edges(self):
        actual = Node(1, 0)
        actual.edges.append(Edge(Node(2,1), 1))

        self.expected.edges.append(Edge(Node(3, 1), 1))

        self.assertNotEqual(self.expected, actual) 

        self.expected.edges = []

    def test_node_equal_edges(self):
        actual = Node(1, 0)
        actual.edges.append(Edge(Node(2,1), 1))

        self.expected.edges.append(Edge(Node(2, 1), 1))

        self.assertEqual(self.expected, actual)

        self.expected.edges = []

    def test_node_unequal_amount_of_edges(self):
        actual = Node(1, 0)
        actual_edge = Edge(actual, 1)

        extra_edge = Edge(Node(2, 2), 1)

        actual.add_edge(actual_edge)
        self.expected.add_edge(actual_edge)
        self.expected.add_edge(extra_edge)

        self.assertNotEqual(self.expected, actual)

    def test_node_less_then_other_type(self):
        actual = Edge(Node(1, 0), 1)
        self.assertNotEqual(self.expected, actual)

    def test_node_less_then_other_node_type(self):
        actual = Node(1, 1)
        self.assertLess(self.expected,  actual)


class GraphTestCase(TestCase):
    def setUp(self):
        file = open('test_graph.txt', 'w')
        file.write('')
        file.close()
        self.expected = Graph()

    def tearDown(self):
        os.remove('test_graph.txt')

    # def test_graph_setup(self):
    #     graph = Graph('test_graph.txt')
    #     test = []
    #     self.assertEquel(graph, test)
