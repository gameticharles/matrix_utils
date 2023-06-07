library maths;

import 'dart:math' as math;

part 'basic.dart';
part 'statistics.dart';
part 'angle.dart';
part 'constants.dart';
part 'trigonometry.dart';
part 'spherical_triangle.dart';
part 'triangle.dart';

/// A generator of random bool, int, or double values.
///
/// The default implementation supplies a stream of pseudo-random bits that
/// are not suitable for cryptographic purposes.
///
/// Use the [Random.secure] constructor for cryptographic purposes.
///
/// Example 1:
/// To create a non-negative random integer uniformly distributed in the
/// range from 0, inclusive, to max, exclusive, use [nextInt(int max)].
///
/// ```dart
/// var intValue = Random().nextInt(10); // Value is >= 0 and < 10.
/// intValue = Random().nextInt(100) + 50; // Value is >= 50 and < 150.
/// ```
///
/// Example 2:
/// To create a non-negative random floating point value uniformly distributed
/// in the range from 0.0, inclusive, to 1.0, exclusive, use [nextDouble]
///
/// ```dart
/// var doubleValue = Random().nextDouble(); // Value is >= 0.0 and < 1.0.
/// doubleValue = Random().nextDouble() * 256; // Value is >= 0.0 and < 256.0.
/// ```
///
/// Example 3:
/// To create a random Boolean value, use [nextBool].
///
/// ```dart
/// var boolValue = Random().nextBool(); // true or false, with equal chance.
/// ```
class Random implements math.Random {
  final math.Random _random;

  Random([int? seed]) : _random = math.Random(seed);

  ///Creates a cryptographically secure random number generator.
  ///
  ///If the program cannot provide a cryptographically secure source of random numbers, it throws an [UnsupportedError].
  Random.secure() : _random = math.Random.secure();

  @override
  bool nextBool() => _random.nextBool();

  @override
  double nextDouble() => _random.nextDouble();

  @override
  int nextInt(int max) => _random.nextInt(max);
}

/// Returns the base-10 logarithm of a number.
///
/// Example:
/// ```dart
/// print(log10(100));  // Output: 2.0
/// ```
double log10(num x) => math.log(x) / math.ln10;

/// Returns the logarithm (base `b`) of `x`.
///
/// If `b` is null, then it returns the natural logarithm of a number.
///
/// Throws an [ArgumentError] if `x` or `b` is less than or equal to 0.
///
/// Example 1:
/// ```dart
/// print(log(100, 10)); // prints: 2.0
/// ```
///
/// Example 2:
/// ```dart
/// print(log(math.e));  // Output: 1.0
double log(num x, [double? b]) {
  if (x <= 0 || (b != null && b <= 0)) {
    throw ArgumentError('Invalid input for log: n and b must be > 0');
  }
  return b != null ? math.log(x) / math.log(b) : math.log(x);
}

/// Returns the logarithm of a number to a given base.
/// The logarithm to base b of x is equal to the value y such that b to the power of y is equal to x.
///
/// Example:
/// ```dart
/// print(logBase(10, 100));  // Output: 2.0
/// print(logBase(2, 8));  // Output: 3.0
/// print(logBase(2, 32));  // Output: 5.0
/// ```
double logBase(num base, num x) => math.log(x) / math.log(base);
