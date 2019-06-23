import 'package:flutter/material.dart';

import 'package:giphy_search/src/widgets/search_bar.widget.dart';
import 'package:giphy_search/src/models/giphy.model.dart';
import 'package:giphy_search/src/services/giphy.service.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _giphyService = GiphyService();
  int _favoritesCount = 0;
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
      _favoritesCount = (_giphyService.toggleAsFavorite(index)).length;
    });
  }

  _searchBarUnfocus() {
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
        title: SearchBar(onChanged: _onSearch, focusNode: _searchBarFocusNode),
        actions: <Widget>[
          FlatButton(
            child: Text(
              _favoritesCount.toString(),
              style: TextStyle(color: Colors.yellow, fontSize: 16.0),
            ),
            onPressed: _pushFavorites,
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          GridView.builder(
            itemCount: _giphyService.list.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              GiphyModel item = _giphyService.list[index];
              return GestureDetector(
                child: Card(
                  elevation: 1.0,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: Image.network(item.url),
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: item.isFavorite
                              ? Icon(Icons.favorite, color: Colors.red)
                              : Icon(Icons.favorite_border, color: Colors.red),
                          onPressed: () => _onFavorite(index),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: _searchBarUnfocus,
              );
            },
          ),
          Center(child: _loading ? CircularProgressIndicator() : null),
        ],
      ),
    );
  }
}
