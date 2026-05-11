import 'package:get_storage/get_storage.dart';

class StorageService {
  static final _box = GetStorage();
  static const _tokenKey       = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _themeModeKey   = 'theme_mode';

  // Access Token
  static Future<void> saveToken(String accessToken) async {
    await _box.write(_tokenKey, accessToken);
  }

  static String? get accessToken => _box.read(_tokenKey);
  static bool get hasToken => accessToken != null && accessToken!.isNotEmpty;

  // Refresh Token
  static Future<void> saveRefreshToken(String refreshToken) async {
    await _box.write(_refreshTokenKey, refreshToken);
  }

  static String? get refreshToken => _box.read(_refreshTokenKey);

  // Theme
  static Future<void> saveThemeMode(String mode) async {
    await _box.write(_themeModeKey, mode);
  }

  static String? get themeMode => _box.read(_themeModeKey);

  // Clear
  static Future<void> clearToken() async {
    await _box.remove(_tokenKey);
    await _box.remove(_refreshTokenKey);
  }

  static Future<void> logout() async {
    await _box.erase();
  }
}