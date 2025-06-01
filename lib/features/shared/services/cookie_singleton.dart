import 'package:plantguardian/features/shared/models/jwt_model.dart';

/// Singleton class for storing and accessing the JWT cookie and payload across the app.
class CookieSingleton {
  // The single instance of CookieSingleton.
  static final CookieSingleton _instance = CookieSingleton._internal();

  /// Factory constructor to return the same instance every time.
  factory CookieSingleton() => _instance;

  /// Private constructor for internal use.
  CookieSingleton._internal();

  /// The JWT cookie string used for authentication.
  String? jwtCookie;

  /// The decoded JWT payload containing user information.
  JWTPayload? jwtPayload;
}
