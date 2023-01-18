import os
from unittest.mock import patch
from pathlib import Path
from rest_framework.test import APIRequestFactory, APITestCase
from rest_framework import status
from dictionary.serializers import NodeSerializer
from django.test import TestCase
from django.urls import reverse
from django.conf import settings
import dictionary.views as view
from dictionary.graph import Graph, Node, Edge


class SignPropertiesTestCase(APITestCase):
    """ Test case for the view search with sign properties"""

    def setUp(self):
        """
        Set up for test
        A list of node is created that the front end returns and a property set to mock the graph funciton
        """
        self.factory = APIRequestFactory()
        self.node_list = [Node('1', 1), Node('2', 2), Node('3', 3), Node('4', 4), Node('5', 5), Node('6', 6), Node('7', 7), Node('8', 8)]

        # this is the mocked return value
        self.property_set = self.node_list
        self.property_set_few_items = self.node_list[0:2]
        self.sign_id_list = [1, 2, 3]

    @patch('dictionary.graph')
    def test_search_with_sign_properties_succes(self, mock_graph):
        """ Test succes scenarion of view search properties"""
        # Create an instance of the class and set the return value of the method
        graph_instance = mock_graph()
        graph_instance.pick_property_set.return_value = self.property_set
        graph_instance.get_sign_ids.return_value = self.sign_id_list

        # Replace the class with the mock object
        view.graph = graph_instance

        # Create a request and force it to be a post request
        request = self.factory.post(reverse('search properties'))
        request.data = NodeSerializer(self.node_list, many=True).data

        # Call the view function
        response = view.search_with_sign_properties(request)

        # Assert that the response has a status code of 200
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # Assert that the returned data is the same as the expected property set
        actual = response.data
        expected = NodeSerializer(self.property_set, many=True).data

        self.assertEqual(actual, expected)

    @patch('dictionary.graph')
    def test_search_with_sign_properties_return_sign_ids(self, mock_graph):
        """ Test if the signs are returned when there are few properties left"""
        # Create an instance of the class and set the return value of the method
        graph_instance = mock_graph()
        graph_instance.pick_property_set.return_value = self.property_set_few_items
        graph_instance.get_sign_ids.return_value = self.sign_id_list

        # Replace the class with the mock object
        view.graph = graph_instance

        # Create a request and force it to be a post request
        request = self.factory.post(reverse('search properties'))
        request.data = NodeSerializer(self.node_list, many=True).data

        # Call the view function
        response = view.search_with_sign_properties(request)

        # Assert that the response has a status code of 200
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # Assert that the returned data is the same as the expected sign id list
        actual = response.data
        expected = self.sign_id_list

        self.assertEqual(actual, expected)


class NodeSerializerTestCase(TestCase):
    """
    Test case for the NodeSerializer class
    """

    def setUp(self):
        """
        Set up test data
        Create a list of valid an invalid data to test
        """
        self.expected = [
            {'index': 1, 'group': 1},
            {'index': 2, 'group': 2},
            {'index': 3, 'group': 3},
        ]

    def test_desirialize_list(self):
        """
        Test the desirialize_list method with valid data
        """
        serializer = NodeSerializer(data=self.expected)
        actual = serializer.initial_data

        self.assertEqual(len(actual), len(self.expected))
        for i, node in enumerate(actual):
            self.assertEqual(node['index'], self.expected[i]['index'])
            self.assertEqual(node['group'], self.expected[i]['group'])


class EdgeTestCase(TestCase):
    """Test class for the Edge class in the graph"""

    def setUp(self):
        """Create a edge that all the test can use to compare"""
        self.expected = Edge(Node(1, 0), 1)

    def test_edge_not_equal_group(self):
        """Test if edge==other_group returns false, so only an edge can be compared to an edge"""
        actual = Node(1, 0)
        self.assertNotEqual(self.expected, actual)

    def test_edge_not_equal_node_id(self):
        """Test if comparing edges with a node that has another id returns false"""
        actual = Edge(Node(2, 0), 1)
        self.assertNotEqual(self.expected, actual)

    def test_edge_not_equal_node_group(self):
        """Test if comparing edges with a node that has another group returns false"""
        actual = Edge(Node(1, 1), 1)
        self.assertNotEqual(self.expected, actual)

    def test_edge_equal_values(self):
        """Test if comparing the same edges returns true"""
        actual = Edge(Node(1, 0), 1)
        self.assertEqual(self.expected, actual)

    def test_edge_less_then_other_group(self):
        """Test if edge<other_group returns false"""
        actual = Node(1, 0)
        self.assertNotEqual(self.expected, actual)

    def test_edge_less_then_other_node_group(self):
        """
        Test if an edge is less than other edge with another node group
        Edges are sorted by node group and edge weight
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

        self.expected.edges[0].append(Edge(Node(1, 0), 1))

        self.assertEqual(len(self.expected.edges), len(actual.edges))

    def test_node_add_exsisting_edge(self):
        """Test if add edge methode return a the node if it already exists"""
        actual = Node(1, 0)
        actual.edges[0].append(Edge(Node(1, 0), 1))
        actual.add_edge(Edge(Node(1, 0), 2))

        self.expected.edges[0].append(Edge(Node(1, 0), 3))

        self.assertEqual(len(self.expected.edges[0]), len(actual.edges[0]))
        self.assertEqual(self.expected.edges[0][0].weight, actual.edges[0][0].weight)

    def test_node_equal_to_same_valued_node(self):
        """Check if nodes with the same id and group are equal to each other"""
        actual = Node(1, 0)
        self.assertEqual(self.expected, actual)

    def test_node_not_equal_group(self):
        """Check if node with a different group are not equal to each other"""
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

        extra_edge = Edge(Node(2, 0), 1)

        actual.add_edge(actual_edge)
        actual.add_edge(extra_edge)

        self.expected.add_edge(actual_edge)

        self.assertNotEqual(self.expected, actual)

    def test_node_less_then_other_group(self):
        """Check if node<other_group is false"""
        actual = Edge(Node(1, 0), 1)
        self.assertNotEqual(self.expected, actual)

    def test_node_less_then_other_node_group(self):
        """Check if node is less then node with another group"""
        actual = Node(1, 1)
        self.assertLess(self.expected,  actual)


class GraphTestCase(TestCase):
    """Test class for the graph"""

    def setUp(self):
        """Create a file and a graph that can be used to compare graphs"""

        with open('test_graph.txt', 'w', encoding='utf-8') as file:
            file.write('[[1, 1, "A", "Omlaag", "<2"], [2, 1, "A", "Naar voren", "T"], [3, 1, "P", "Omlaag", "T"], [4, 1, "P", "Omlaag", "<"]]')
            file.close()

        self.expected = self.set_up_test_graph()

    def tearDown(self):
        """Remove graph test file when testing is done"""
        os.remove('test_graph.txt')

    def test_graph_create_from_file(self):
        """Check if the graph created from a file is as expected"""
        actual = Graph()
        file_path = Path(settings.BASE_DIR) / 'test_graph.txt'
        actual.create_graph_from_file(file_path)

        actual.print_graph()
        self.assertEqual(self.expected, actual)

    def test_graph_add_node(self):
        """Test add node methode, it checks if the node already exists in and adds it to the correct list"""
        graph = Graph()
        graph.nodes = [[], [], []]
        actual = graph.add_node(Node(1, 0, len(graph.nodes)))
        expected = Node(1, 0, len(graph.nodes))

        self.assertEqual(expected, actual)
        self.assertEqual(expected, graph.nodes[0][0])

    def test_graph_pick_first_set(self):
        """Test if the node set picked by the methode is equal to the movement nodes"""
        actual = self.expected.pick_first_set()
        expected = self.expected.nodes[1]

        self.assertEqual(expected, actual)

    def test_graph_pick_location_for_second_set(self):
        """
        Check if all the nodes that are from the best set of edges of the first location node are returned
        Should return the first four movement nodes
        """
        picked_node = self.expected.nodes[0][0]
        actual = self.expected.pick_second_set(picked_node)
        expected = sorted(self.expected.nodes[1][0:-1])

        self.assertEqual(expected, actual)

    def test_graph_pick_movement_for_second_set(self):
        """
        Same test as before but picked a movement node
        Should return the first handshape node
        """
        picked_node = self.expected.nodes[1][0]
        actual = self.expected.pick_second_set(picked_node)
        expected = [self.expected.nodes[2][0]]

        self.assertEqual(expected, actual)

    def test_graph_pick_handshape_for_second_set(self):
        """
        Same test as before but picked a handshape node
        Should return the three movement nodes
        """
        picked_node = self.expected.nodes[2][0]
        actual = self.expected.pick_second_set(picked_node)
        expected = [self.expected.nodes[1][0],
                    self.expected.nodes[1][1],
                    self.expected.nodes[1][4]]

        self.assertEqual(expected, actual)

    def test_graph_pick_third_set(self):
        """Check the best set when two node are chosen"""
        first = self.expected.nodes[2][0]
        second = self.expected.nodes[0][0]
        actual = self.expected.pick_third_set(first, second)
        expected = self.expected.nodes[1][0:2]

        self.assertEqual(expected, actual)

    def test_graph_calculated_set_value(self):
        """Check if the set value is the same as expected"""
        actual = round(self.expected.calculated_set_spread(self.expected.nodes[2]), 2)
        expected = 18.86

        self.assertEqual(expected, actual)

    def test_graph_not_equal_to_other_group(self):
        """Check if graph==other_group is false"""
        actual = Node(1, 0)

        self.assertNotEqual(self.expected, actual)

    def test_graph_not_equal_other_location_nodes(self):
        """Check if comparing two graphs is false when the locaiton nodes are not the same"""
        actual = Graph()
        actual.nodes = [[], [], []]
        actual.add_node(Node(1, 0))

        self.assertNotEqual(self.expected, actual)

    def test_graph_not_equal_other_movement_nodes(self):
        """Same as previous test but with movement node"""
        actual = Graph()
        actual.nodes = [[], [], []]
        actual.add_node(Node(1, 1))

        self.assertNotEqual(self.expected, actual)

    def test_graph_not_equal_other_handshape_nodes(self):
        """Same as previous test but with handshape node"""
        actual = Graph()
        actual.nodes = [[], [], []]
        actual.add_node(Node(1, 2))

        self.assertNotEqual(self.expected, actual)

    def set_up_test_graph(self):
        """Create a graph that can be compared to generated graphs"""
        graph = Graph()

        graph.nodes = self.set_up_test_nodes()

        return graph

    def set_up_test_nodes(self):
        """Set up a list of nodes with coresponing edges for the test graph"""
        nr_of_sets = 3

        location_3 = Node(3, 0, nr_of_sets)
        location_8 = Node(8, 0, nr_of_sets)

        movement_49 = Node(49, 1, nr_of_sets)
        movement_55 = Node(55, 1, nr_of_sets)
        movement_51 = Node(51, 1, nr_of_sets)
        movement_16 = Node(16, 1, nr_of_sets)
        movement_8 = Node(8, 1, nr_of_sets)

        handshape_15 = Node(15, 2, nr_of_sets)
        handshape_5 = Node(5, 2, nr_of_sets)
        handshape_6 = Node(6, 2, nr_of_sets)

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

        return [[location_3, location_8],
                [movement_49, movement_55, movement_51, movement_16, movement_8],
                [handshape_15, handshape_5, handshape_6]]
