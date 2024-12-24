class MathHelper {
  static double lerpDouble(double a, double b, double t) {
    return a * (1.0 - t) + b * t;
  }
}
