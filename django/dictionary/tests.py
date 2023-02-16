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
from dictionary.tree import Tree, Node


class SignPropertiesTestCase(APITestCase):
    """ Test case for the view search with sign properties"""

    def setUp(self):
        """
        Set up for test
        A list of node is created that the front end returns and a property set to mock the tree funciton
        """
        self.factory = APIRequestFactory()
        self.node_list = [
                Node('1', [1]),
                Node('2', [2]),
                Node('3', [3]),
                Node('4', [4]),
                Node('5', [5]),
                Node('6', [6]),
                Node('7', [7]),
                Node('8', [8])]

        # this is the mocked return value
        self.property_set = self.node_list

    @patch('dictionary.tree')
    def test_search_with_sign_properties_succes(self, mock_tree):
        """ Test succes scenario of view search properties"""
        # Create an instance of the class and set the return value of the method
        tree_instance = mock_tree()
        tree_instance.get_next_node_list_for_user.return_value = self.property_set

        # Replace the class with the mock object
        view.tree = tree_instance

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


class TreeTestCase(TestCase):
    """ Test case for the tree data structure"""

    def setUp(self):
        """Create a test file to est up the tree with and create a tree to compare it to"""
        with open('test_tree.txt', 'w', encoding='utf-8') as file:
            file.write('{"1":[5, 3, 49, 15], "2":[4, 3, 55, 15], "3":[3, 3, 51, 5], "4":[2, 3, 16, 6], "5":[1, 8, 8, 15],"6":[5, 4, 49, 15]}')
            file.close()
        self.expected = set_up_test_tree()

    def tearDown(self):
        """Remove the test file"""
        os.remove('test_tree.txt')

    def test_tree_create_from_file(self):
        """
        Test if the tree creation from a file works
        """
        actual = Tree()
        file_path = Path(settings.BASE_DIR) / 'test_tree.txt'
        actual.create_from_file(file_path)

        self.assertEqual(actual, self.expected)


class NodeTestCase(TestCase):
    """Test class for the node class in the tree"""

    def setUp(self):
        """Create a node that all the test can use to compare"""
        self.expected = Node(1)

    def tearDown(self):
        """Remove all edges that are added after a test"""
        self.expected.edges = []

    def test_node_add_new_edge(self):
        """Test if add edge methode inserts a new node"""
        actual = Node(1)
        actual.add_edge(Node(1))

        self.expected.edges.append(Node(1))

        self.assertEqual(len(self.expected.edges), len(actual.edges))

    def test_node_add_exsisting_edge(self):
        """Test if add edge methode return a node if it already exists"""
        actual = Node(1)
        actual.edges.append(Node(1))
        actual.add_edge(Node(1))

        self.expected.edges.append(Node(1))

        self.assertEqual(len(self.expected.edges), len(actual.edges))

    def test_node_equal_to_same_valued_node(self):
        """Check if nodes with the same id and group are equal to each other"""
        actual = Node(1)
        self.assertEqual(self.expected, actual)

    def test_node_not_equal_id(self):
        """Check if node with a different id are not equal to each other"""
        actual = Node(2)
        self.assertNotEqual(self.expected, actual)

    def test_node_not_equal_edges(self):
        """Check if nodes with different edges are not equal to each other"""
        actual = Node(1)
        actual.edges.append(Node(2))

        self.expected.edges.append(Node(3))

        self.assertNotEqual(self.expected, actual)

    def test_node_equal_edges(self):
        """Check if nodes with the same edge are equal"""
        actual = Node(1, 0)
        actual.edges.append(Node(2))

        self.expected.edges.append(Node(2))

        self.assertEqual(self.expected, actual)

    def test_node_unequal_amount_of_edges(self):
        """Check if nodes with different amount of edges are not equal"""
        actual = Node(1)
        actual_edge = actual

        extra_edge = Node(2)

        actual.add_edge(actual_edge)
        actual.add_edge(extra_edge)

        self.expected.add_edge(actual_edge)

        self.assertNotEqual(self.expected, actual)


def set_up_test_tree():
    """
    Setup all nodes for the test tree
    """
    tree = Tree()

    # create edges
    edges = [
        (49, 15, 3), (49, 15, 4), (55, 3, 15), (51, 3, 5), (16, 3, 6), (8, 8, 15)
    ]

    parent_node = Node('p')

    # add edges to nodes
    for first_identifier, second_identifier, third_identifier in edges:
        first_node = Node(first_identifier)
        second_node = Node(second_identifier)
        third_node = Node(third_identifier)

        for edge in parent_node.edges:
            if edge.identifier == first_identifier:
                first_node = edge

        for edge in first_node.edges:
            if edge.identifier == second_identifier:
                second_node = edge

        parent_node.add_edge(first_node)

        first_node.add_edge(second_node)

        second_node.add_edge(third_node)

    tree.nodes = parent_node.edges
    return tree
