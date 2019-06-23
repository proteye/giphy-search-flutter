import 'dart:convert';

class GiphyModel {
  String id;
  String title;
  String slug;
  String url;
  bool isFavorite;

  GiphyModel();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'slug': slug,
      'url': url,
      'isFavorite': isFavorite,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  GiphyModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    slug = map['slug'];
    url = map['url'];
    isFavorite = map['isFavorite'] ?? false;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'url': url,
      'isFavorite': isFavorite,
    };
  }

  @override
  String toString() {
    return json.encode(this);
  }
}
