import 'package:flutter/material.dart';

import 'package:giphy_search/src/models/giphy.model.dart';

class GifsGrid extends StatelessWidget {
  final List<GiphyModel> items;
  final bool loading;
  final Function onFavorite;
  final Function onGridTap;

  const GifsGrid(
      {Key key,
      this.items = const [],
      this.loading = false,
      this.onFavorite,
      this.onGridTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GridView.builder(
          itemCount: items.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            GiphyModel item = items[index];
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
                        onPressed: () =>
                            onFavorite != null ? onFavorite(index) : null,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: onGridTap,
            );
          },
        ),
        Center(child: loading ? CircularProgressIndicator() : null),
      ],
    );
  }
}
