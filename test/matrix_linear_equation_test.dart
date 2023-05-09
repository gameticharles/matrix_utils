import 'package:matrix_utils/matrix_utils.dart';
import 'package:test/test.dart';

void main() {
  var res = Matrix([
    [1],
    [7],
    [6]
  ]);

  test('Inverse Matrix', () {
    Matrix A = Matrix([
      [4, 1, -1],
      [1, 4, -1],
      [-1, -1, 4]
    ]);
    Matrix b = Matrix([
      [6],
      [25],
      [14]
    ]);

    expect(A.linear.solve(b, method: LinearSystemMethod.inverseMatrix).round(),
        res);
  });

  test('LU Decomposition', () {
    Matrix A = Matrix([
      [4, 1, -1],
      [1, 4, -1],
      [-1, -1, 4]
    ]);
    Matrix b = Matrix([
      [6],
      [25],
      [14]
    ]);

    expect(
        A.linear.solve(b, method: LinearSystemMethod.luDecomposition).round(),
        res);
  });

  test('Gauss-Jordan Elimination', () {
    Matrix A = Matrix([
      [4, 1, -1],
      [1, 4, -1],
      [-1, -1, 4]
    ]);
    Matrix b = Matrix([
      [6],
      [25],
      [14]
    ]);

    expect(
        A.linear
            .solve(b, method: LinearSystemMethod.gaussJordanElimination)
            .round(),
        res);
  });

  test('Ridge Regression', () {
    Matrix A = Matrix([
      [4, 1, -1],
      [1, 4, -1],
      [-1, -1, 4]
    ]);
    Matrix b = Matrix([
      [6],
      [25],
      [14]
    ]);

    expect(
        A.linear.solve(b, method: LinearSystemMethod.ridgeRegression).round(),
        res);
  });

  test('Gauss Elimination', () {
    Matrix A = Matrix([
      [4, 1, -1],
      [1, 4, -1],
      [-1, -1, 4]
    ]);
    Matrix b = Matrix([
      [6],
      [25],
      [14]
    ]);

    expect(
        A.linear.solve(b, method: LinearSystemMethod.gaussElimination).round(),
        res);
  });

  test('Least Squares', () {
    Matrix A = Matrix([
      [4, 1, -1],
      [1, 4, -1],
      [-1, -1, 4]
    ]);
    Matrix b = Matrix([
      [6],
      [25],
      [14]
    ]);

    expect(A.linear.solve(b, method: LinearSystemMethod.leastSquares).round(),
        res);
  });

  test('Jacobi', () {
    Matrix A = Matrix([
      [4, 1, -1],
      [1, 4, -1],
      [-1, -1, 4]
    ]);
    Matrix b = Matrix([
      [6],
      [25],
      [14]
    ]);

    expect(
        A.linear.solve(b, method: LinearSystemMethod.jacobi).round(),
        Matrix([
          [1],
          [7],
          [5]
        ]));
  });

  test('Successive Over-Relaxation (SOR)', () {
    Matrix A = Matrix([
      [4, 1, -1],
      [1, 4, -1],
      [-1, -1, 4]
    ]);
    Matrix b = Matrix([
      [6],
      [25],
      [14]
    ]);

    expect(
        A.linear.solve(b, method: LinearSystemMethod.sor).round(),
        Matrix([
          [2],
          [6],
          [5]
        ]));
  });

  test('Gauss-Seidel method', () {
    Matrix A = Matrix([
      [4, 1, -1],
      [1, 4, -1],
      [-1, -1, 4]
    ]);
    Matrix b = Matrix([
      [6],
      [25],
      [14]
    ]);

    expect(
        A.linear.solve(b, method: LinearSystemMethod.gaussSeidel).round(),
        Matrix([
          [2],
          [6],
          [5]
        ]));
  });

  test('Gram Schmidt method', () {
    Matrix A = Matrix([
      [4, 1, -1],
      [1, 4, -1],
      [-1, -1, 4]
    ]);
    Matrix b = Matrix([
      [6],
      [25],
      [14]
    ]);

    expect(
        A.linear.solve(b, method: LinearSystemMethod.gramSchmidt).round(), res);
  });

  test('Conjugate Gradient', () {
    Matrix A = Matrix([
      [4, 1, -1],
      [1, 4, -1],
      [-1, -1, 4]
    ]);
    Matrix b = Matrix([
      [6],
      [25],
      [14]
    ]);

    expect(
        A.linear.solve(b, method: LinearSystemMethod.conjugateGradient).round(),
        res);
  });

  test('Montante\'s Method (Bareiss algorithm)', () {
    Matrix A = Matrix([
      [4, 1, -1],
      [1, 4, -1],
      [-1, -1, 4]
    ]);
    Matrix b = Matrix([
      [6],
      [25],
      [14]
    ]);

    expect(A.linear.solve(b, method: LinearSystemMethod.bareiss).round(), res);
  });

  test('Cramers Rule', () {
    Matrix A = Matrix([
      [4, 1, -1],
      [1, 4, -1],
      [-1, -1, 4]
    ]);
    Matrix b = Matrix([
      [6],
      [25],
      [14]
    ]);

    expect(
        A.linear.solve(b, method: LinearSystemMethod.cramersRule).round(), res);
  });
}
