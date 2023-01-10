import os
from django.test import TestCase
from dictionary.Graph import Graph, Node, Edge

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

    def tearDown(self):
        self.expected.edges = []

    def test_node_add_new_edge(self):
        actual = Node(1, 0)
        actual.add_edge(Edge(Node(1, 0), 1))

        self.expected.edges.append(Edge(Node(1, 0), 1))

        self.assertEqual(len(self.expected.edges), len(actual.edges))

    def test_node_add_exsisting_edge(self):
        actual = Node(1, 0)
        actual.edges.append(Edge(Node(1, 0), 1))
        actual.add_edge(Edge(Node(1, 0), 2))

        self.expected.edges.append(Edge(Node(1, 0), 3))

        self.assertEqual(len(self.expected.edges), len(actual.edges))
        self.assertEqual(self.expected.edges[0].weight, actual.edges[0].weight)

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

    def test_node_equal_edges(self):
        actual = Node(1, 0)
        actual.edges.append(Edge(Node(2,1), 1))

        self.expected.edges.append(Edge(Node(2, 1), 1))

        self.assertEqual(self.expected, actual)

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
        file.write('{"1":[5, 3, 49, 15], "2":[4, 3, 55, 15], "3":[3, 3, 51, 5], "4":[2, 3, 16, 6], "5":[1, 8, 8, 15]}')
        file.close()

        graph = Graph()

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

        graph.add_node(location_3)
        graph.add_node(location_8)

        graph.add_node(movement_49)
        graph.add_node(movement_55)
        graph.add_node(movement_51)
        graph.add_node(movement_16)
        graph.add_node(movement_8)

        graph.add_node(handshape_15)
        graph.add_node(handshape_5)
        graph.add_node(handshape_6)

        self.expected = graph

    def tearDown(self):
        os.remove('test_graph.txt')

    def test_graph_create_from_file(self):
        actual = Graph()
        actual.create_graph_from_file('test_graph.txt')

        self.assertEqual(self.expected,actual)

    def test_graph_add_node(self):
        graph = Graph()
        actual = graph.add_node(Node(1,0))
        expected = Node(1,0)

        self.assertEqual(expected, actual)
        self.assertEqual(expected, graph.location_nodes[0])

    def test_graph_pick_best_set(self):
        actual = self.expected.pick_best_set()
        expected = self.expected.movement_nodes

        self.assertEqual(expected, actual)

    def test_graph_pick_location_for_second_set(self):
        picked_node = self.expected.location_nodes[0]
        actual = self.expected.pick_second_set(picked_node)
        expected = sorted(self.expected.movement_nodes[0:-1])

        self.assertEqual(expected, actual)

    def test_graph_pick_movement_for_second_set(self):
        picked_node = self.expected.movement_nodes[0]
        actual = self.expected.pick_second_set(picked_node)
        expected = [self.expected.location_nodes[0]]

        self.assertEqual(expected, actual)

    def test_graph_pick_handshape_for_second_set(self):
        picked_node = self.expected.handshape_nodes[0]
        actual = self.expected.pick_second_set(picked_node)
        expected = [self.expected.movement_nodes[0], 
                self.expected.movement_nodes[1], 
                self.expected.movement_nodes[4]]

        self.assertEqual(expected, actual)

    def test_graph_pick_third_set(self):
        first = self.expected.handshape_nodes[0]
        second = self.expected.location_nodes[0]
        actual = self.expected.pick_third_set(first, second)
        expected = self.expected.movement_nodes[0:2]

        self.assertEqual(expected, actual)

    def test_graph_calculated_set_value(self):
        actual = self.expected.calculated_set_value(self.expected.handshape_nodes)
        expected = 18.856180831641268

        self.assertEqual(expected, actual)

    def test_graph_not_equal_to_other_type(self):
        actual = Node(1, 0)

        self.assertNotEqual(self.expected, actual)

    def test_graph_not_equal_other_location_nodes(self):
        actual = Graph()
        actual.add_node(Node(1, 0))

        self.assertNotEqual(self.expected, actual)

    def test_graph_not_equal_other_movement_nodes(self):
        actual = Graph()
        actual.add_node(Node(1, 1))

        self.assertNotEqual(self.expected, actual)

    def test_graph_not_equal_other_handshape_nodes(self):
        actual = Graph()
        actual.add_node(Node(1, 2))

        self.assertNotEqual(self.expected, actual)
