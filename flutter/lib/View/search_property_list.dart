import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sign_app/Models/property_index.dart';
import 'package:http/http.dart' as http;
import 'package:sign_app/View/sign_list.dart';

import '../Models/property.dart';

class SearchPropertyList extends StatefulWidget {
  const SearchPropertyList({super.key});

  @override
  State<SearchPropertyList> createState() => _SearchPropertyListState();
}

class _SearchPropertyListState extends State<SearchPropertyList>
    with TickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final List<Property> _propertyList = List.empty(growable: true);
  final List<PropertyIndex> _chosenProperties = List.empty(growable: true);
  late String title;

  @override
  void initState() {
    super.initState();
    fetchProperties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property group'),
      ),
      body: AnimatedList(
        key: _listKey,
        itemBuilder:
            (BuildContext context, int index, Animation<double> animation) {
          return slideIt(context, index, animation, _propertyList[index]);
        },
      ),
    );
  }

  Future<void> fetchProperties() async {
    var url = Uri.parse('http://10.0.2.2:8000/search');
    var body = json.encode(_chosenProperties);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 200) {
      try {
        List<Property> data = json
            .decode(response.body)
            .map((data) => Property.fromJson(data))
            .toList()
            .cast<Property>();

        _refreshData(data);
      } on TypeError {

        List<int> listOfSignIds = jsonDecode(response.body).cast<int>();

        // Check if the current widget is still on screen
        if(mounted) {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    SearchSignList(search: '', signIds: listOfSignIds,)),
          );
        }
      }
    } else {
      throw Exception(
          'Failed to load Properties. Error code: ${response.statusCode}');
    }
  }

  void _refreshData(List<Property> properties) {
    _removeItems().whenComplete(() {
      for (var i = 0; i < properties.length; i++) {
        _listKey.currentState?.insertItem(i);
        _propertyList.add(properties[i]);
      }
    });
  }

  Future<void> _removeItems() async {
    if (_propertyList.isEmpty) {
      return;
    }

    for (var i = _propertyList.length - 1; i >= 0; i--) {
      var p = _propertyList.removeLast();
      _listKey.currentState?.removeItem(
          0, (_, animation) => slideIt(context, i, animation, p),
          duration: const Duration(milliseconds: 500));
    }

    return Future.delayed(const Duration(milliseconds: 500));
  }

  Widget slideIt(BuildContext context, int index, animation, Property item) {
    return SlideTransition(
      position: CurvedAnimation(
          parent: animation, curve: Curves.ease, reverseCurve: Curves.ease)
          .drive(Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      )),
      child: InkWell(
        onTap: () {
          _chosenProperties.add(PropertyIndex(group: item.group, index: item.index));
          fetchProperties();
        },
        child: SizedBox(
          // Actual widget to display
          height: 64,
          child: Card(
            child: Center(
              child: Text(item.identifier),
            ),
          ),
        ),
      ),
    );
  }
}
