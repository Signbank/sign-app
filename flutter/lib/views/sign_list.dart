import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sign_app/url_config.dart';
import 'package:sign_app/controllers/sign_list_controller.dart';
import 'package:sign_app/views/video_page.dart';

class SearchSignListView extends StatefulWidget {
  const SearchSignListView(
      {super.key, String searchTerm = '', List<int> signIds = const []}) : _signIds = signIds, _searchTerm = searchTerm;

  final String _searchTerm;
  final List<int> _signIds;

  @override
  State createState() => _SearchSignListViewState();
}

class _SearchSignListViewState extends State<SearchSignListView> {
  late SignListController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SignListController(callback);
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
    if (_controller.signList.isEmpty) {
      _controller.fetchSigns(searchTerm: widget._searchTerm, singIds: widget._signIds);
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
        itemCount: _controller.signList.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => VideoPage(sign: _controller.getSign(index)))),
            child: Card(
              child: ListTile(
                  leading: SizedBox(
                    width: 100,
                    height: 56,
                    child: Image.network(
                      signBankBaseMediaUrl + _controller.getSignImageUrl(index),
                    ),
                  ),
                  title: Text(_controller.getSignName(index))),
            ),
          );
        });
  }

  void callback() => setState(() {});
}
