part of maths;

/// Returns the mathematical constant Pi.
///
/// Example:
/// ```dart
/// print(pi);  // Output: 3.141592653589793
/// ```
num get pi => math.pi;

/// Returns the mathematical constant e. Base of the natural logarithms
///
/// Example:
/// ```dart
/// print(e);  // Output: 2.718281828459045
/// ```
num get e => math.e;

/*
Angle constants
 */

class AngleConstants {
  // Trigonometric constants related to angles
  /// Pi is the ratio of a circle's circumference to its diameter, equivalent to 180 degrees.
  static const double pi = 3.14159265358979323846;

  /// Tau (or 2*Pi) is the ratio of a circle's circumference to its radius, equivalent to 360 degrees.
  static const double tau = 6.28318530717958647692;

  /// Half of Pi is equivalent to 90 degrees.
  static const double halfPi = 1.57079632679489661923;

  /// Quarter of Pi is equivalent to 45 degrees.
  static const double quarterPi = 0.78539816339744830962;

  /// Pi divided by 180 is used for the conversion from degrees to radians.
  static const double piOver180 = 0.01745329251994329576;

  /// 180 divided by Pi is used for the conversion from radians to degrees.
  static const double _180OverPi = 57.2957795130823208768;
}

class PhysicsConstants {
  /// Speed of light in vacuum, in meters per second.
  static const double speedOfLight = 299792458;

  /// Planck constant, in joule-seconds.
  static const double planckConstant = 6.62607015e-34;

  /// Reduced Planck constant (ħ), in joule-seconds.
  static const double reducedPlanckConstant = planckConstant / (2 * math.pi);

  /// Gravitational constant (G), in cubic meters per kilogram per second squared.
  static const double gravitationalConstant = 6.67430e-11;

  /// Standard acceleration due to gravity on Earth, in meters per second squared.
  static const double standardGravity = 9.80665;

  /// Boltzmann constant, in joules per kelvin.
  static const double boltzmannConstant = 1.380649e-23;

  /// Electron mass, in kilograms.
  static const double electronMass = 9.10938356e-31;

  /// Proton mass, in kilograms.
  static const double protonMass = 1.672621898e-27;

  /// Neutron mass, in kilograms.
  static const double neutronMass = 1.674927471e-27;

  /// Elementary charge (charge of an electron), in coulombs.
  static const double elementaryCharge = 1.602176634e-19;

  /// Avogadro's number, the number of atoms or molecules in one mole.
  static const double avogadrosNumber = 6.02214076e23;

  /// Gas constant (R), in joules per mole per kelvin.
  static const double gasConstant = 8.314462618;

  /// Stefan-Boltzmann constant, in watts per meter squared per kelvin to the fourth.
  static const double stefanBoltzmannConstant = 5.670374419e-8;
}
