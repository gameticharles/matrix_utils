part of matrix_utils;

/// A class representing a complex number with real and imaginary parts.
///
/// Complex numbers can be used in various mathematical operations,
/// such as addition, subtraction, multiplication, and division.
///
/// Example:
/// ```
/// var z1 = Complex(3, 2); // 3 + 2i
/// var z2 = Complex(1, -1); // 1 - i
///
/// // Conjugate
/// var z1_conj = z1.conjugate(); // 3 - 2i
///
/// // String representation
/// print(z1); // 3 + 2i
/// print(z2); // 1 - i
/// print(z1_conj); // 3 - 2i
/// ```
class Complex {
  /// The real part of the complex number.
  final num real;

  /// The imaginary part of the complex number.
  final num imaginary;

  /// Constructs a complex number with the given real and imaginary parts.
  Complex(this.real, this.imaginary);

  /// Returns the complex conjugate of the current complex number.
  ///
  /// The complex conjugate is the complex number with the same real part
  /// and the negation of its imaginary part.
  Complex conjugate() {
    return Complex(real, -imaginary);
  }

  /// Returns the string representation of the complex number.
  ///
  /// The string representation is in the form "a + bi" or "a - bi",
  /// where a is the real part and b is the imaginary part.
  @override
  String toString() {
    if (imaginary >= 0) {
      return '$real + ${imaginary}i';
    } else {
      return '$real - ${-imaginary}i';
    }
  }
}
