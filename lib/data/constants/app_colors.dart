import 'package:flutter/services.dart';

class AppColors {
  // MAIN COLOR
  static const  Color primary = const Color(0xFF4caf50);
  static Color secondary = const Color(0xff357a38);
  static Color accent = const Color(0xFFFCB80F);

  // Others Color
  static const Color scaffoldBackground = Color(0xFFFFFFFF);

  //FIX COLOR
  static Color black = const Color(0xFF000000);
  static Color white = const Color(0xFFFFFFFF);

  /// used for page with box background
  static const Color scaffoldWithBoxBackground = Color(0xFFF7F7F7);
  static const Color cardColor = Color(0xFFF2F2F2);
  static const Color coloredBackground = Color(0xFFE4F8EA);
  static const Color placeholder = Color(0xFF8B8B97);
  static const Color textInputBackground = Color(0xFFF7F7F7);
  static const Color separator = Color(0xFFFAFAFA);
  static const Color gray = Color(0xFFE1E1E1);

  static SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: primary,
    // systemNavigationBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.light,
  );
}
