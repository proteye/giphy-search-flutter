import 'package:giphy_search/src/screens/main.screen.dart';
import 'package:giphy_search/src/screens/favorites.screen.dart';

class Routing {
  static routes() {
    return {
      '/': (context) => new MainScreen(),
      '/favorites': (context) => new FavoritesScreen(),
    };
  }
}
