import 'package:flutter/material.dart';

import 'package:giphy_search/src/widgets/search_bar.widget.dart';
import 'package:giphy_search/src/widgets/gifs_grid.widget.dart';
import 'package:giphy_search/src/services/giphy.service.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _giphyService = GiphyService();
  bool _loading = false;
  FocusNode _searchBarFocusNode;

  _pushFavorites() {
    Navigator.pushNamed(context, '/favorites');
  }

  _onSearch(String text) {
    setState(() {
      _loading = true;
    });
    _giphyService.search(q: text).then((data) {
      setState(() {
        _loading = false;
      });
    });
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
  void initState() {
    super.initState();
    _searchBarFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchBarFocusNode.dispose();
    super.dispose();
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
          Container(
            child: FlatButton(
              color: Colors.white70,
              child: Text(
                _giphyService.favorites.length.toString(),
                style: TextStyle(color: Colors.blue, fontSize: 18.0),
              ),
              onPressed: _pushFavorites,
            ),
          ),
        ],
      ),
      body: GifsGrid(
        items: _giphyService.items,
        loading: _loading,
        onFavorite: _onFavorite,
        onGridTap: _onGridTap,
      ),
    );
  }
}
