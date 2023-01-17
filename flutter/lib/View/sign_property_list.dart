import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sign_app/Models/property.dart';
import 'package:sign_app/Models/property_index.dart';

class SearchPropertiesList extends StatefulWidget {
  const SearchPropertiesList({super.key});

  @override
  State<SearchPropertiesList> createState() => _SearchPropertiesListState();
}

class _SearchPropertiesListState extends State<SearchPropertiesList> {
  late Future<List<Property>> futureSigns;
  final List<PropertyIndex> _chosenProperties = List.empty(growable: true);
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final List<Widget> _property_list = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    futureSigns = fetchProperties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property group'),
      ),
      body: FutureBuilder<List<Property>>(
        future: futureSigns,
        builder: (context, snapshot) {
          Widget child;
          if (snapshot.hasData) {
            child = AnimatedList(
              key: _listKey,
              itemBuilder: (BuildContext context, int index,
                  Animation<double> animation) {
                Property? property = snapshot.data?[index];
                if (property == null) {
                  return const Text('Could not load sign');
                }
                return SlideTransition(
                    position: CurvedAnimation(
                      curve: Curves.easeOut,
                      parent: animation,
                    ).drive((Tween<Offset>(
                      begin: Offset(1, 0),
                      end: Offset(0, 0),
                    ))),
                    child: InkWell(
                      onTap: () {
                        _chosenProperties.add(
                            PropertyIndex(group: property.group, index: index));

                        setState(() {
                          futureSigns = fetchProperties();
                        });
                      },
                      child: _property_list[index],
                    ));
              },
            );
            // child = ListView.builder(
            //     key: const ValueKey(1),
            //     itemCount: snapshot.data?.length,
            //     itemBuilder: (BuildContext context, int index) {
            //       Property? property = snapshot.data?[index];
            //       if (property == null) {
            //         return const Text('Could not load sign');
            //       }
            //       return InkWell(
            //         onTap: () {
            //           _chosenProperties.add(
            //               PropertyIndex(group: property.group, index: index));
            //
            //           setState(() {
            //             futureSigns = fetchProperties();
            //           });
            //         },
            //         child: Card(
            //           child: ListTile(title: Text(property.identifier)),
            //         ),
            //       );
            //     });
          } else if (snapshot.hasError) {
            child = Text('${snapshot.error}');
          } else {
            child = const Center(
                child: CircularProgressIndicator(
              key: ValueKey(2),
            ));
          }

          return AnimatedSwitcher(
            duration: const Duration(seconds: 3),
            child: child,
          );
        },
      ),
    );
  }

  Future<List<Property>> fetchProperties() async {
    var url = Uri.parse('http://10.0.2.2:8000/search');
    var body = json.encode(_chosenProperties);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 200) {
      List<Property> l = json
          .decode(response.body)
          .map((data) => Property.fromJson(data))
          .toList()
          .cast<Property>();

      print(l);

      for (var i = 0; i < l.length; i++) {
        _property_list.add(Card(child: Text(l[i].identifier),));
        _listKey.currentState?.insertItem(i);
      }

      return l;
    } else {
      throw Exception(
          'Failed to load Properties. Error code: ${response.statusCode}');
    }
  }
}
