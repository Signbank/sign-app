import 'package:mvc_application/view.dart';
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

class _SearchSignListState extends StateMVC<SearchSignList> {
  late SignListController _con;

  @override
  void initState() {
    super.initState();
    _con = SignListController.con;
    _con.searchTerm = widget.search;
    _con.singIds = widget.signIds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search for ${widget.search}'),
      ),
      body: test(),
    );
  }

  Widget test() {
    if (_con.signList.isEmpty) {
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
                        'https://signbank.cls.ru.nl/dictionary/protected_media/${_con.getSignImageUrl(index)}'),
                  ),
                  title: Text(_con.getSignName(index))),
            ),
          );
        });
  }
}
