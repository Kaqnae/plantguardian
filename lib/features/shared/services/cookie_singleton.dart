class CookieSingleton {
  static final CookieSingleton _instance = CookieSingleton._internal();

  factory CookieSingleton() => _instance;

  CookieSingleton._internal();

  String? jwtCookie;
}
