import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sign_app/video_page.dart';

import 'ObjectClass/sign.dart';

class SearchSignList extends StatefulWidget {
  const SearchSignList({super.key, required this.search});

  final String search;

  @override
  State<SearchSignList> createState() => _SearchSignListState();
}

class _SearchSignListState extends State<SearchSignList> {
  late Future<List<Sign>> futureSigns;

  @override
  void initState() {
    super.initState();
    futureSigns = fetchSigns();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search for ${widget.search}'),
      ),
      body: FutureBuilder<List<Sign>>(
        future: futureSigns,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  Sign? sign = snapshot.data?[index];
                  if(sign == null){
                    return const Text('Could not load sign');
                  }
                  return InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoPage(sign: sign))),
                    child: Card(
                      child: ListTile(
                          leading: SizedBox(
                            width: 100,
                            height: 56,
                            child: Image.network('https://signbank.cls.ru.nl/dictionary/protected_media/${sign.imageUrl}'),
                          ),
                          title: Text(sign.name)),
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<List<Sign>> fetchSigns() async {
    var url = 'http://10.0.2.2:8080/dictionary/gloss/api/?search=${widget.search}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json
          .decode(response.body)
          .map((data) => Sign.fromJson(data))
          .toList()
          .cast<Sign>();
    } else {
      throw Exception(
          'Failed to load Signs. Error code: ${response.statusCode}');
    }
  }
}
