import 'dart:ui';

class MathHelper {
  static int lerpInt(int a, int b, double t) {
    return (a * (1.0 - t) + b * t).round();
  }

  static double lerpDouble(double a, double b, double t) {
    return a * (1.0 - t) + b * t;
  }

  static Color lerpColor(Color a, Color b, double t) {
    return Color.fromARGB(
      lerpInt(a.alpha, b.alpha, t),
      lerpInt(a.red, b.red, t),
      lerpInt(a.green, b.green, t),
      lerpInt(a.blue, b.blue, t),
    );
  }
}
