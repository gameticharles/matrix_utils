part of maths;

/// Represents a spherical triangle, defined by its three angles (A, B, C)
/// and the lengths of the three sides opposite those angles (a, b, c).
///
/// All values are in radians.
///
/// The class provides automatic calculation of missing values if enough
/// information is provided (at least one angle-side pair). If not enough
/// information is provided, it throws an [ArgumentError].
///
/// If you change one of the values after object creation, all dependent
/// values are automatically recalculated.
///
/// Example usage:
///
/// ```dart
/// // Define a spherical triangle with one angle-side pair
/// var triangle = SphericalTriangle.fromSideAndAngle(math.pi / 3, math.pi / 2);
///
/// // Angles
/// print(triangle.angleA);
/// print(triangle.angleB);
/// print(triangle.angleC);
/// // Sides
/// print(triangle.sideA);
/// print(triangle.sideB);
/// print(triangle.sideC);
/// ```
class SphericalTriangle {
  final double _angleA;
  final double _angleB;
  final double _angleC;
  final double _sideA;
  final double _sideB;
  final double _sideC;

  /// Creates a new SphericalTriangle. Any provided parameters are used
  /// to calculate any missing values.
  SphericalTriangle._(this._angleA, this._angleB, this._angleC, this._sideA,
      this._sideB, this._sideC);

  factory SphericalTriangle.fromTwoSidesAndAngle(
      double angleA, double sideA, double sideB) {
    var angleB = math.asin(math.sin(angleA) * sideB / sideA);
    var angleC = math.pi - angleA - angleB;
    var sideC = math.acos(
        (math.cos(sideA) - math.cos(sideB) * math.cos(angleC)) /
            (math.sin(sideB) * math.sin(angleC)));
    //_validateTriangle();
    return SphericalTriangle._(angleA, angleB, angleC, sideA, sideB, sideC);
  }

  factory SphericalTriangle.fromTwoAnglesAndSide(
      double angleA, double angleB, double sideA) {
    var angleC = math.pi - angleA - angleB;
    var sideB =
        math.asin(math.sin(sideA) * math.sin(angleB) / math.sin(angleA));
    var sideC = math.acos(math.cos(sideA) -
        math.cos(sideB) *
            math.cos(angleC) /
            (math.sin(sideB) * math.sin(angleC)));
    //_validateTriangle();
    return SphericalTriangle._(angleA, angleB, angleC, sideA, sideB, sideC);
  }

  factory SphericalTriangle.fromAllSides(
      double sideA, double sideB, double sideC) {
    var angleA = math.acos(
        (math.cos(sideC) - math.cos(sideA) * math.cos(sideB)) /
            (math.sin(sideA) * math.sin(sideB)));
    var angleB = math.acos(
        (math.cos(sideA) - math.cos(sideB) * math.cos(sideC)) /
            (math.sin(sideB) * math.sin(sideC)));
    var angleC = math.acos(
        (math.cos(sideB) - math.cos(sideC) * math.cos(sideA)) /
            (math.sin(sideC) * math.sin(sideA)));
    //_validateTriangle();
    return SphericalTriangle._(angleA, angleB, angleC, sideA, sideB, sideC);
  }

  factory SphericalTriangle.fromAllAngles(
      double angleA, double angleB, double angleC) {
    var sideA = math.acos(
        (math.cos(angleC) - math.cos(angleA) * math.cos(angleB)) /
            (math.sin(angleA) * math.sin(angleB)));
    var sideB = math.acos(
        (math.cos(angleA) - math.cos(angleB) * math.cos(angleC)) /
            (math.sin(angleB) * math.sin(angleC)));
    var sideC = math.acos(
        (math.cos(angleB) - math.cos(angleC) * math.cos(angleA)) /
            (math.sin(angleC) * math.sin(angleA)));
    //_validateTriangle();
    return SphericalTriangle._(angleA, angleB, angleC, sideA, sideB, sideC);
  }

  static double calculateOtherSide(double angle1, double angle2, double side) {
    return side * math.sin(angle2) / math.sin(angle1);
  }

  factory SphericalTriangle.fromSideAndAngle(double angleA, double sideA) {
    // First, calculate the other two angles
    var angleB = math.asin(math.sin(sideA) * math.sin(angleA));
    var angleC = math.pi - angleA - angleB;

    // Then, calculate the other two sides
    var sideB = calculateOtherSide(sideA, angleA, angleB);
    var sideC = calculateOtherSide(sideA, angleA, angleC);

    return SphericalTriangle._(angleA, angleB, angleC, sideA, sideB, sideC);
  }

  /// Checks if the values form a valid spherical triangle.
  void _validateTriangle() {
    var sumOfAngles = _angleA + _angleB + _sideC;
    var sumOfSides = _sideA + _sideB + _sideC;

    if ((sumOfAngles - math.pi).abs() > 1e-6) {
      throw ArgumentError(
          'Sum of angles should be approximately equal to pi but was: $sumOfAngles');
    }

    if (sumOfSides >= 2 * math.pi) {
      throw ArgumentError(
          'Sum of sides should be less than 2*pi but was: $sumOfSides');
    }
  }

  /// Computes the area of the spherical triangle
  /// using the formula A = E - pi, where E is the
  /// sum of the interior angles of the triangle.
  double get area {
    return _angleA + _angleB + _angleC - pi;
  }

  /// Computes the perimeter of the spherical triangle,
  /// which is the sum of the lengths of its sides.
  double get perimeter {
    return _sideA + _sideB + _sideC;
  }

  /// as a percentage of the surface area of a unit sphere.
  double get areaPercentage {
    return (area / (4 * math.pi)) * 100;
  }

  /// Computes the perimeter of the spherical triangle,
  /// as a percentage of the circumference of a unit sphere.
  double get perimeterPercentage {
    return (perimeter / (2 * math.pi)) * 100;
  }

  /// Returns the angle A.
  num get angleA => _angleA;

  /// Returns the angle B.
  num get angleB => _angleB;

  /// Returns the angle C.
  num get angleC => _angleC;

  /// Returns the side a.
  num get sideA => _sideA;

  /// Returns the side b.
  num get sideB => _sideB;

  /// Returns the side c.
  num get sideC => _sideC;
}
