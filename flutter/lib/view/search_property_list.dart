import 'package:flutter/material.dart';
import 'package:sign_app/controller/property_list_controller.dart';
import 'package:sign_app/models/property.dart';
import 'package:sign_app/models/property_index.dart';

class SearchPropertyList extends StatefulWidget {
  const SearchPropertyList({super.key});

  @override
  State<SearchPropertyList> createState() => _SearchPropertyListState();
}

class _SearchPropertyListState extends State<SearchPropertyList>
    with TickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  //Keep a copy of the list to display the properties.
  //Removing and adding items to this list allows for the animation
  final List<Property> _displayProperties = List.empty(growable: true);

  late String title = '';
  late PropertyListController _con;

  @override
  void initState() {
    super.initState();

    _con = PropertyListController();
    _con.setCallback = callback;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Property group $title'),
      ),
      body: _showBody(),
    );
  }


  void _refreshData(List<Property> properties) {
    _removeItems().whenComplete(() {
      for (var i = 0; i < properties.length; i++) {
        _listKey.currentState?.insertItem(i);
        _displayProperties.add(properties[i]);
      }
    });
  }

  Future<void> _removeItems() async {
    if (_displayProperties.isEmpty) {
      return;
    }

    for (var i = _displayProperties.length - 1; i >= 0; i--) {
      var lastProperty = _displayProperties.removeLast();
      _listKey.currentState?.removeItem(
          0, (_, animation) => _listItem(context, i, animation, lastProperty),
          duration: const Duration(milliseconds: 500));
    }

    return Future.delayed(const Duration(milliseconds: 500));
  }

  Widget _showBody() {
    if (_con.getPropertyList.isEmpty) {
      _con.fetchProperties();
      // return const Center(child: CircularProgressIndicator());
    }

    return AnimatedList(
      key: _listKey,
      itemBuilder:
          (BuildContext context, int index, Animation<double> animation) {
        return _listItem(context, index, animation, _con.getProperty(index));
      },
    );
  }

  Widget _listItem(BuildContext context, int index, animation, Property item) {
    return FadeTransition(
      opacity: animation,
      child: InkWell(
        onTap: () {
          _con.addChosenProperty(PropertyIndex(group: item.group, index: item.index));
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
  ///Create function for the controller that refreshes the ui when the data is loaded
  void callback() => _refreshData(_con.getPropertyList);
}
