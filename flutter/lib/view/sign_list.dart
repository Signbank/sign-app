import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sign_app/url_config.dart';
import 'package:sign_app/controller/sign_list_controller.dart';
import 'package:sign_app/view/video_page.dart';

class SearchSignListView extends StatefulWidget {
  const SearchSignListView(
      {super.key, String searchTerm = '', List<int> signIds = const []}) : _signIds = signIds, _searchTerm = searchTerm;

  final String _searchTerm;
  final List<int> _signIds;

  @override
  State createState() => _SearchSignListViewState();
}

class _SearchSignListViewState extends State<SearchSignListView> {
  late SignListController _con;

  @override
  void initState() {
    super.initState();
    _con = SignListController();
    _con.setCallback = callback;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.searchFor + widget._searchTerm),
      ),
      body: _showBody(),
    );
  }

  Widget _showBody() {
    if (_con.signList.isEmpty) {
      _con.fetchSigns(searchTerm: widget._searchTerm, singIds: widget._signIds);
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
                      signBankBaseMediaUrl + _con.getSignImageUrl(index),
                    ),
                  ),
                  title: Text(_con.getSignName(index))),
            ),
          );
        });
  }

  void callback() => setState(() {});
}
