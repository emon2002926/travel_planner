import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../util/storage_service.dart';


class ThemeController extends GetxController {
  var themeMode = ThemeMode.system.obs;

  final _platformBrightness = Brightness.light.obs;
  Brightness get platformBrightness => _platformBrightness.value;


  static const _themeModeMap = {
    'light': ThemeMode.light,
    'dark': ThemeMode.dark,
    'system': ThemeMode.system,
  };

  static const _themeModeReverseMap = {
    ThemeMode.light: 'light',
    ThemeMode.dark: 'dark',
    ThemeMode.system: 'system',
  };

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();

    _platformBrightness.value =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;

    SchedulerBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        _onPlatformBrightnessChanged;
  }

  @override
  void onClose() {
    SchedulerBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
    null;
    super.onClose();
  }

  void _onPlatformBrightnessChanged() {
    final brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    if (_platformBrightness.value != brightness) {
      _platformBrightness.value = brightness;
    }
  }

  void _loadThemeFromStorage() {
    final savedTheme = StorageService.themeMode;
    themeMode.value = _themeModeMap[savedTheme] ?? ThemeMode.system;
  }

  Future<void> setTheme(ThemeMode mode) async {
    if (themeMode.value == mode) return;
    themeMode.value = mode;
    await StorageService.saveThemeMode(_themeModeReverseMap[mode]!);
    Get.changeThemeMode(mode);
  }

  Future<void> toggleTheme() async {
    await setTheme(isActuallyDark ? ThemeMode.light : ThemeMode.dark);
  }

  Future<void> setLightTheme() => setTheme(ThemeMode.light);
  Future<void> setDarkTheme() => setTheme(ThemeMode.dark);
  Future<void> setSystemTheme() => setTheme(ThemeMode.system);

  bool get isDarkMode => themeMode.value == ThemeMode.dark;
  bool get isLightMode => themeMode.value == ThemeMode.light;
  bool get isSystemMode => themeMode.value == ThemeMode.system;

  bool get isActuallyDark {
    if (themeMode.value == ThemeMode.system) {
      return _platformBrightness.value == Brightness.dark;
    }
    return isDarkMode;
  }

  bool get isEffectivelyDark => isActuallyDark;
}