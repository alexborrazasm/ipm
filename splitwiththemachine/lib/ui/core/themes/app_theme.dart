import 'package:flutter/material.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.addCredit,
  });

  final Color? addCredit;

  @override
  CustomColors copyWith({Color? addCredit, Color? iconColor}) {
    return CustomColors(
      addCredit: addCredit ?? this.addCredit,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      addCredit: Color.lerp(addCredit, other.addCredit, t),
    );
  }
}

class AppTheme {
  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
    ),
    useMaterial3: true,
    extensions: <ThemeExtension<dynamic>>[
      CustomColors(
        addCredit: Colors.green,
      ),
    ],
  );

  static final dark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
      error: Color(0xff8f0e27),
    ),
    useMaterial3: true,
    extensions: <ThemeExtension<dynamic>>[
    CustomColors(
      addCredit: Color(0xff4a7d40),
    ),
    ],
  );
}