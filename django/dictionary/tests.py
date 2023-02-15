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
        with open('test_tree.txt', 'w', encoding='utf-8') as file:
            file.write('{"1":[5, 3, 49, 15], "2":[4, 3, 55, 15], "3":[3, 3, 51, 5], "4":[2, 3, 16, 6], "5":[1, 8, 8, 15],"6":[5, 4, 49, 15]}')
            file.close()
        self.expected = set_up_test_tree()

    def tearDown(self):
        os.remove('test_tree.txt')

    def test_tree_create_from_file(self):
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
    tree = Tree()

    m_49 = Node(49, ['1', '6'])
    m_55 = Node(55, ['2'])
    m_51 = Node(51, ['3'])
    m_16 = Node(16, ['4'])
    m_8 = Node(8, ['5'])

    h_15 = Node(15, ['1', '6'])
    h_15_2 = Node(15, ['2'])
    h_15_3 = Node(15, ['5'])
    h_5 = Node(5, ['3'])
    h_6 = Node(6, ['4'])

    l_3 = Node(3, ['1'])
    l_3 = Node(3, ['2'])
    l_3 = Node(3, ['3'])
    l_3 = Node(3, ['3'])
    l_4 = Node(4, ['6'])
    l_8 = Node(8, ['5'])

    m_49.edges = [h_15]
    m_55.edges = [h_15_2]
    m_51.edges = [h_5]
    m_16.edges = [h_6]
    m_8.edges = [h_15_3]

    h_15.edges = [l_3, l_4]
    h_15_2.edges = [l_3]
    h_15_3.edges = [l_8]
    h_5.edges = [l_3]
    h_6.edges = [l_3]

    tree.nodes = [m_49, m_55, m_51, m_16, m_8]
    return tree
