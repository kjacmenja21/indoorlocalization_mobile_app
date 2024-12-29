import 'dart:ui';

class MathHelper {
  static int lerpInt(int a, int b, double t) {
    return (a * (1.0 - t) + b * t).round();
  }

  static double lerpDouble(double a, double b, double t) {
    return a * (1.0 - t) + b * t;
  }

  static Color lerpColor(Color c1, Color c2, double t) {
    return Color.from(
      alpha: lerpDouble(c1.a, c2.a, t),
      red: lerpDouble(c1.r, c2.r, t),
      green: lerpDouble(c1.g, c2.g, t),
      blue: lerpDouble(c1.b, c2.b, t),
    );
  }
}
