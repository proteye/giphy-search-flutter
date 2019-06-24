import 'package:flutter/material.dart';

import 'package:giphy_search/src/widgets/gifs_grid.widget.dart';
import 'package:giphy_search/src/services/giphy.service.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _giphyService = GiphyService();

  _onFavorite(int index) {
    setState(() {
      _giphyService.removeFromFavorites(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: GifsGrid(
        items: _giphyService.favorites,
        onFavorite: _onFavorite,
      ),
    );
  }
}
