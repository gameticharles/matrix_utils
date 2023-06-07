part of matrix_utils;

/// Extension providing hyperbolic functions and their inverses for the `num` class.
extension HyperbolicFunctions on num {
  /// Returns the hyperbolic sine (sinh) of the number.
  double sinh() => (math.exp(this) - math.exp(-this)) / 2;

  /// Returns the hyperbolic cosine (cosh) of the number.
  double cosh() => (math.exp(this) + math.exp(-this)) / 2;

  /// Returns the hyperbolic tangent (tanh) of the number.
  double tanh() => sinh() / cosh();

  /// Returns the inverse hyperbolic sine (asinh) of the number.
  double asinh() => math.log(this + math.sqrt(this * this + 1));

  /// Returns the inverse hyperbolic cosine (acosh) of the number.
  ///
  /// Throws an [ArgumentError] if the input is less than 1.
  double acosh() {
    if (this < 1) {
      throw ArgumentError('Invalid input for acosh: input must be >= 1');
    }
    return math.log(this + math.sqrt(this * this - 1));
  }

  /// Returns the inverse hyperbolic tangent (atanh) of the number.
  ///
  /// Throws an [ArgumentError] if the input is less than or equal to -1 or greater than or equal to 1.
  double atanh() {
    if (this <= -1 || this >= 1) {
      throw ArgumentError('Invalid input for atanh: input must be in (-1, 1)');
    }
    return 0.5 * math.log((1 + this) / (1 - this));
  }
}
