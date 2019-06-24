import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'package:giphy_search/src/models/giphy.model.dart';
import 'package:giphy_search/src/config.dart';

const BASE_URL = 'https://api.giphy.com/v1';

class GiphyService {
  static final GiphyService _giphyService = new GiphyService._internal();
  List<GiphyModel> items = [];
  List<GiphyModel> favorites = [];

  factory GiphyService() {
    return _giphyService;
  }

  GiphyService._internal();

  Future<List<GiphyModel>> search(
      {String q = '',
      int limit = 20,
      int offset = 0,
      String lang = 'en'}) async {
    var res = await http.get(
        '$BASE_URL/gifs/search?api_key=${Config.GIPHY_API_KEY}&q=$q&limit=$limit&offset=$offset&lang=$lang');

    if (res.statusCode != 200) {
      return items;
    }

    var jsonResponse = convert.jsonDecode(res.body);
    items = jsonResponse['data'].isNotEmpty
        ? List<GiphyModel>.from(jsonResponse['data'].map((item) {
            item['url'] = item['images']['fixed_width']['url'];
            item['isFavorite'] = false;
            var favorite = favorites.firstWhere((fav) => fav.id == item['id'],
                orElse: () => null);
            if (favorite != null) {
              item['isFavorite'] = true;
            }
            return GiphyModel.fromMap(item);
          }).toList())
        : [];

    return items;
  }

  List<GiphyModel> toggleAsFavorite(int index) {
    if (index == null) {
      return favorites;
    }

    GiphyModel giphy;
    try {
      giphy = items[index];
    } catch (e) {}

    if (giphy == null) {
      return favorites;
    }

    giphy.isFavorite = !giphy.isFavorite;

    if (giphy.isFavorite == true) {
      favorites.add(giphy);
    } else {
      favorites = favorites.where((item) => item.id != giphy.id).toList();
    }

    return favorites;
  }

  List<GiphyModel> removeFromFavorites(int index) {
    if (index == null) {
      return favorites;
    }

    GiphyModel giphy;
    try {
      giphy = favorites[index];
    } catch (e) {}

    if (giphy == null) {
      return favorites;
    }

    var itemIndex = items.indexWhere((item) => item.id == giphy.id);
    if (itemIndex != -1) {
      items[itemIndex].isFavorite = false;
    }

    favorites.removeAt(index);

    return favorites;
  }
}
