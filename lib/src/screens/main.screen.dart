import 'package:flutter/material.dart';

import 'package:giphy_search/src/widgets/search_bar.widget.dart';
import 'package:giphy_search/src/widgets/gifs_grid.widget.dart';
import 'package:giphy_search/src/services/giphy.service.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const GIFS_LIMIT = 8;
  final _giphyService = GiphyService();
  bool _loading = false;
  String _searchText = '';
  ScrollController _scrollController = ScrollController();
  FocusNode _searchBarFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchBarFocusNode.dispose();
    super.dispose();
  }

  _pushFavorites() {
    Navigator.pushNamed(context, '/favorites');
  }

  _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        _giphyService.items.length < _giphyService.totalCount[_searchText]) {
      _fetchGifs(offset: _giphyService.items.length);
    }
  }

  _fetchGifs({String q, int limit = GIFS_LIMIT, int offset}) {
    if (_loading) {
      return;
    }

    setState(() {
      _loading = true;
    });

    q = q != null ? q : _searchText;

    _giphyService.search(q: q, limit: limit, offset: offset).then((data) {
      setState(() {
        if (offset == 0 && _scrollController.hasClients) {
          _scrollController.jumpTo(0.0);
        }
        _loading = false;
      });
    }).catchError((e) {
      setState(() {
        _loading = false;
      });
    });
  }

  _onSearch(String text) {
    _searchText = text;
    _loading = false;
    _fetchGifs(q: text, offset: 0);
  }

  _onFavorite(int index) {
    setState(() {
      _giphyService.toggleAsFavorite(index);
    });
  }

  _onGridTap() {
    if (_searchBarFocusNode.hasFocus) {
      _searchBarFocusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchBar(
          onChanged: _onSearch,
          focusNode: _searchBarFocusNode,
          timeoutMs: 1500,
        ),
        actions: <Widget>[
          FavoritesCountButton(
            count: _giphyService.favorites.length,
            onFavorites: _pushFavorites,
          ),
        ],
      ),
      body: GifsGrid(
        items: _giphyService.items,
        loading: _loading,
        onFavorite: _onFavorite,
        onGridTap: _onGridTap,
        scrollController: _scrollController,
      ),
    );
  }
}

class FavoritesCountButton extends StatelessWidget {
  final int count;
  final Function onFavorites;

  const FavoritesCountButton({
    Key key,
    this.count = 0,
    this.onFavorites,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.white70,
      child: Text(
        count.toString(),
        style: TextStyle(color: Colors.blue, fontSize: 18.0),
      ),
      onPressed: onFavorites,
    );
  }
}
