import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sign_app/app_config.dart';
import 'package:sign_app/controller/sign_list_controller.dart';
import 'package:sign_app/view/video_page.dart';

class SearchSignList extends StatefulWidget {
  const SearchSignList(
      {super.key, required this.search, required this.signIds});

  final String search;
  final List<int> signIds;

  @override
  State createState() => _SearchSignListState();
}

class _SearchSignListState extends State<SearchSignList> {
  late SignListController _con;

  @override
  void initState() {
    super.initState();
    _con = SignListController();
    _con.setCallback = callback;
    _con.setSearchTerm = widget.search;
    _con.setSignIds = widget.signIds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.searchFor+widget.search),
      ),
      body: _showBody(),
    );
  }

  Widget _showBody() {
    if (_con.signList.isEmpty) {
      _con.fetchSigns();
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
        itemCount: _con.signList.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => VideoPage(sign: _con.getSign(index)))),
            child: Card(
              child: ListTile(
                  leading: SizedBox(
                    width: 100,
                    height: 56,
                    child: Image.network(
                      Uri.https(signBankBaseMediaUrl, _con.getSignImageUrl(index)).toString(),
                    ),
                  ),
                  title: Text(_con.getSignName(index))),
            ),
          );
        });
  }

  ///Create function for the controller that refreshes the ui when the data is loaded
  void callback() => setState(() {});
}
