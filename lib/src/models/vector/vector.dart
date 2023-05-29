part of matrix_utils;

class Vector {
  /// Internal data of the vector.
  final List<num> _data;

  /// Constructs a [Vector] of given length with all elements initialized to 0.
  ///
  /// If [isDouble] is true, the elements are initialized with 0.0,
  /// otherwise they are initialized with 0.
  Vector(int length, {bool isDouble = true})
      : _data = List<num>.filled(length, isDouble ? 0.0 : 0);

  /// Constructs a [Vector] from a list of numerical values.
  Vector.fromList(List<num> data) : _data = data;

  /// Constructs a [Vector] from a list of random numerical values
  factory Vector.random(int length,
      {double min = 0,
      double max = 1,
      bool isDouble = true,
      math.Random? random,
      int? seed}) {
    if (seed != null) {
      random = math.Random(seed);
    }
    random ??= math.Random();
    List<num> data = List.generate(
      length,
      (_) => (isDouble
          ? random!.nextDouble() * (max - min) + min
          : random!.nextInt(max.toInt() - min.toInt()) + min.toInt()),
    );

    return Vector.fromList(data);
  }

  /// Creates a row Vector with equally spaced values between the start and end values (inclusive).
  ///
  /// [start]: Start value.
  /// [end]: End value.
  /// [number]: Number of equally spaced points. Default is 50.
  ///
  /// Example:
  /// ```dart
  /// var m = Vector.linespace(0, 10, 3);
  /// print(m);
  /// // Output:
  /// // Matrix: 1x3
  /// // [ 0 5 10 ]
  /// ```
  factory Vector.linspace(int start, int end, [int number = 50]) {
    if (start.runtimeType != end.runtimeType) {
      throw Exception('Start and end must be of the same type');
    }

    if (number <= 0) {
      throw Exception('Number must be a positive integer');
    }

    double step = (end - start) / (number - 1);
    List<num> data = [];
    for (int i = 0; i < number; i++) {
      data.add(start + i * step);
    }

    return Vector.fromList(data);
  }

  /// Creates a Vector with values in the specified range, incremented by the specified step size.
  ///
  /// [end]: End value (exclusive).
  /// [start]: Start value. Default is 1.
  /// [steps]: Step size. Default is 1.
  ///
  /// Example:
  /// ```dart
  /// var m = Vector.range(6,  start: 1, step: 2);
  /// print(m);
  /// // Output:
  /// // [1, 3, 5]
  /// ```
  factory Vector.range(int end, {int start = 1, int step = 1}) {
    if (start >= end) {
      throw Exception('Start must be less than end');
    }

    if (step <= 0) {
      throw Exception('Step must be a positive integer');
    }

    List<num> range = [];
    for (int i = start; i < end; i += step) {
      range.add(i);
    }

    return Vector.fromList(range);
  }

  /// Alias for Matrix.range.
  factory Vector.arrange(int end, {int start = 1, int step = 1}) {
    return Vector.range(end, start: start, step: step);
  }

  /// Fetches the value at the given index of the vector.
  num operator [](int index) => _data[index];

  /// Sets the value at the given index of the vector.
  void operator []=(int index, num value) {
    _data[index] = value;
  }

  /// Converts the vector to a list of numerical values.
  List<num> toList() => _data;

  /// Returns the length (number of elements) of the vector.
  int get length => _data.length;

  Vector operator +(Vector other) {
    if (length != other.length) {
      throw ArgumentError("Vectors must have the same length for addition.");
    }
    Vector result = Vector(length);
    for (int i = 0; i < length; i++) {
      result[i] = this[i] + other[i];
    }
    return result;
  }

  Vector operator -(Vector other) {
    if (length != other.length) {
      throw ArgumentError("Vectors must have the same length for subtraction.");
    }
    Vector result = Vector(length);
    for (int i = 0; i < length; i++) {
      result[i] = this[i] - other[i];
    }
    return result;
  }

  Vector operator *(double scalar) {
    Vector result = Vector(length);
    for (int i = 0; i < length; i++) {
      result[i] = this[i] * scalar;
    }
    return result;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Vector) return false;
    Vector vector = other;
    if (vector.length != length) return false;
    for (int i = 0; i < length; ++i) {
      if (this[i] != vector[i]) return false;
    }
    return true;
  }

  Vector operator /(double scalar) {
    Vector result = Vector(length);
    for (int i = 0; i < length; i++) {
      result[i] = this[i] / scalar;
    }
    return result;
  }

  /// Calculates the dot product of the vector with another vector.
  ///
  /// The two vectors must have the same length. If they don't, an
  /// ArgumentError is thrown.
  double dot(Vector other) {
    if (length != other.length) {
      throw ArgumentError("Vectors must have the same length for dot product.");
    }
    double result = 0;
    for (int i = 0; i < length; i++) {
      result += this[i] * other[i];
    }
    return result;
  }

  /// Calculates the cross product of the vector with another vector.
  ///
  /// Both vectors must be three-dimensional. If they are not, an
  /// ArgumentError is thrown.
  Vector cross(Vector other) {
    if (length != 3 || other.length != 3) {
      throw ArgumentError("Both vectors must be three-dimensional.");
    }
    return Vector.fromList([
      this[1] * other[2] - this[2] * other[1],
      this[2] * other[0] - this[0] * other[2],
      this[0] * other[1] - this[1] * other[0]
    ]);
  }

  /// Returns the magnitude (or norm) of the vector.
  ///
  /// This is equivalent to the Euclidean length of the vector.
  double get magnitude => norm();

  /// Returns the direction (or angle) of the vector, in radians.
  ///
  /// This is only valid for 2D vectors. For vectors of other dimensions, an
  /// AssertionError is thrown.
  double get direction {
    assert(length == 2, 'Direction can only be calculated for 2D vectors');
    return math.atan2(_data[1], _data[0]);
  }

  /// Returns the norm (or length) of this vector.
  ///
  /// The norm of a vector is the square root of the sum of the squares of its elements.
  /// It gives a measure of the magnitude (or length) of the vector.
  ///
  /// Example:
  /// ```dart
  /// var v = Vector.fromList([3, 4]);
  /// print(v.norm());
  /// ```
  ///
  /// Output:
  /// ```
  /// 5.0
  /// ```
  /// Explanation:
  /// The vector [3, 4] has a norm of 5 because sqrt(3*3 + 4*4) = sqrt(9 + 16) = sqrt(25) = 5.
  double norm() {
    double sum = 0;
    for (int i = 0; i < length; i++) {
      sum += this[i] * this[i];
    }
    return math.sqrt(sum);
  }

  /// Returns this vector normalized.
  ///
  /// Normalizing a vector scales it so that its norm becomes 1. The resulting vector
  /// points in the same direction as the original vector.
  /// This method throws an `ArgumentError` if this is a zero vector, as zero vectors cannot be normalized.
  ///
  /// Example:
  /// ```dart
  /// var v = Vector.fromList([3, 4]);
  /// print(v.normalize());
  /// ```
  ///
  /// Output:
  /// ```
  /// [0.6, 0.8]
  /// ```
  /// Explanation:
  /// The vector [3, 4] gets normalized to [0.6, 0.8] because 3/5 = 0.6 and 4/5 = 0.8,
  /// where 5 is the norm of the original vector.
  Vector normalize() {
    double normValue = norm();
    if (normValue == 0) {
      throw ArgumentError("Cannot normalize a zero vector.");
    }
    return this / normValue;
  }

  /// Returns `true` if this is a zero vector, i.e., all its elements are zero.
  ///
  /// Example:
  /// ```dart
  /// var v = Vector.fromList([0, 0, 0]);
  /// print(v.isZero());
  /// ```
  ///
  /// Output:
  /// ```
  /// true
  /// ```
  bool isZero() {
    for (var i = 0; i < length; i++) {
      if (this[i] != 0) {
        return false;
      }
    }
    return true;
  }

  /// Returns `true` if this is a unit vector, i.e., its norm is 1.
  ///
  /// Example:
  /// ```dart
  /// var v = Vector.fromList([0, 1]);
  /// print(v.isUnit());
  /// ```
  ///
  /// Output:
  /// ```
  /// true
  /// ```
  bool isUnit() {
    const double tolerance =
        1e-10; // Define a suitable tolerance as per your needs
    return (norm() - 1).abs() < tolerance;
  }

  /// Sets all elements of this vector to [value].
  ///
  /// Example:
  /// ```dart
  /// var v = Vector.fromList([1, 2, 3]);
  /// v.setAll(0);
  /// print(v);
  /// ```
  ///
  /// Output:
  /// ```
  /// [0, 0, 0]
  /// ```
  void setAll(num value) {
    for (var i = 0; i < length; i++) {
      this[i] = value;
    }
  }

  /// Returns the Euclidean distance between this vector and [other].
  ///
  /// The distance is given by the formula `sqrt(sum((this[i] - other[i])^2))` for all i.
  ///
  /// Throws an `ArgumentError` if the vectors have different lengths.
  ///
  /// Example:
  /// ```dart
  /// var v1 = Vector.fromList([1, 2, 3]);
  /// var v2 = Vector.fromList([4, 5, 6]);
  /// print(v1.distance(v2));
  /// ```
  ///
  /// Output:
  /// ```
  /// 5.196152422706632
  /// ```
  double distance(Vector other) {
    if (length != other.length) {
      throw ArgumentError(
          "Vectors must have the same length for distance calculation.");
    }
    double sum = 0;
    for (int i = 0; i < length; i++) {
      sum += math.pow(this[i] - other[i], 2);
    }
    return math.sqrt(sum);
  }

  /// Returns the projection of this vector onto [other].
  ///
  /// The projection is given by the formula `(this . other / other . other) * other`, where `.` denotes the dot product.
  ///
  /// Throws an `ArgumentError` if the vectors have different lengths.
  ///
  /// Example:
  /// ```dart
  /// var v1 = Vector.fromList([1, 2, 3]);
  /// var v2 = Vector.fromList([4, 5, 6]);
  /// print(v1.projection(v2));
  /// ```
  ///
  /// Output:
  /// ```
  /// [0.96, 1.2, 1.44]
  /// ```
  Vector projection(Vector other) {
    if (length != other.length) {
      throw ArgumentError("Vectors must have the same length for projection.");
    }
    double scalar = dot(other) / other.dot(other);
    return other * scalar;
  }

  /// Returns the angle (in radians) between this vector and [other].
  ///
  /// The angle is given by the formula `acos((this . other) / (||this|| * ||other||))`, where `.` denotes the dot product and `|| ||` the norm.
  ///
  /// Throws an `ArgumentError` if the vectors have different lengths.
  ///
  /// Example:
  /// ```dart
  /// var v1 = Vector.fromList([1, 0]);
  /// var v2 = Vector.fromList([0, 1]);
  /// print(v1.angle(v2));
  /// ```
  ///
  /// Output:
  /// ```
  /// 1.5707963267948966
  /// ```
  double angle(Vector other) {
    if (length != other.length) {
      throw ArgumentError(
          "Vectors must have the same length for angle calculation.");
    }
    return math.acos(dot(other) / (norm() * other.norm()));
  }

  /// Converts the Vector from Cartesian to Spherical coordinates.
  ///
  /// Returns a list of doubles [r, theta, phi] where:
  /// - r is the radius (distance from origin)
  /// - theta is the inclination (angle from the z-axis, in range [0, pi])
  /// - phi is the azimuth (angle from the x-axis in the xy-plane, in range [0, 2*pi])
  ///
  /// Example:
  /// ```dart
  /// Vector v = Vector.fromList([1, 1, 1]);
  /// print(v.toSpherical());
  /// // Output: [1.7320508075688772, 0.9553166181245093, 0.7853981633974483]
  /// ```
  List<double> toSpherical() {
    if (length != 3) {
      throw Exception(
          "Vector must be 3D for conversion to Spherical coordinates");
    }
    double x = _data[0].toDouble();
    double y = _data[1].toDouble();
    double z = _data[2].toDouble();
    double r = math.sqrt(x * x + y * y + z * z);
    double theta = math.acos(z / r);
    double phi = math.atan2(y, x);
    return [r, theta, phi];
  }

  /// Converts the Vector from Cartesian to Cylindrical coordinates.
  ///
  /// Returns a list of doubles [rho, phi, z] where:
  /// - rho is the radial distance from the z-axis
  /// - phi is the azimuth (angle from the x-axis in the xy-plane, in range [0, 2*pi])
  /// - z is the height along the z-axis
  ///
  /// Example:
  /// ```dart
  /// Vector v = Vector.fromList([1, 1, 1]);
  /// print(v.toCylindrical());
  /// // Output: [1.4142135623730951, 0.7853981633974483, 1]
  /// ```
  List<double> toCylindrical() {
    if (length != 3) {
      throw Exception(
          "Vector must be 3D for conversion to Cylindrical coordinates");
    }
    double x = _data[0].toDouble();
    double y = _data[1].toDouble();
    double z = _data[2].toDouble();
    double rho = math.sqrt(x * x + y * y);
    double phi = math.atan2(y, x);
    return [rho, phi, z];
  }

  /// Converts the Vector from Cartesian to Polar coordinates.
  ///
  /// This function assumes the vector is 2D.
  /// Throws an exception if the vector has more than two components.
  ///
  /// Returns a list of doubles [r, theta] where:
  /// - r is the radius (distance from origin)
  /// - theta is the angle from the positive x-axis, in range [0, 2*pi])
  ///
  /// Example:
  /// ```dart
  /// Vector v = Vector.fromList([1, 1]);
  /// print(v.toPolar());
  /// // Output: [1.4142135623730951, 0.7853981633974483]
  /// ```
  List<double> toPolar() {
    if (length != 2) {
      throw Exception("Vector must be 2D for conversion to Polar coordinates");
    }
    double x = _data[0].toDouble();
    double y = _data[1].toDouble();
    double r = math.sqrt(x * x + y * y);
    double theta = math.atan2(y, x);
    return [r, theta];
  }

  @override
  int get hashCode {
    int result = 17;
    for (int i = 0; i < length; ++i) {
      result = result * 31 + this[i].hashCode;
    }
    return result;
  }

  // @override  //performance optimization
  // int get hashCode {
  //   const int numberOfElements = 10;
  //   int stride = length < numberOfElements ? 1 : length ~/ numberOfElements;
  //   int result = 17;
  //   for (int i = 0; i < length; i += stride) {
  //     result = result * 31 + this[i].hashCode;
  //   }
  //   result = result * 31 + length.hashCode; // Include length in hash computation
  //   return result;
  // }

  @override
  String toString() {
    return _data.toString();
  }
}
