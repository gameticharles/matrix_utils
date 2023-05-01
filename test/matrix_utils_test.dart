import 'package:matrix_utils/matrix_utils.dart';
import 'package:test/test.dart';

void main() {
  // create a matrix
  Matrix m = Matrix([
    [1, 2, 3, 4, 5],
    [6, 7, 8, 9, 10],
    [5, 7, 8, 9, 10]
  ]);

  test('test flatten', () {
    expect(m.flatten(), Row([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 5, 7, 8, 9, 10]));
  });

  test('test transpose with double', () {
    expect(
        [
          [1.0, 2.0],
          [1.0, 2.0]
        ].toMatrix().transpose(),
        Matrix([
          [1.0, 1.0],
          [2.0, 2.0]
        ]));
  });

  test('test transpose with int', () {
    expect(
        [
          [1, 2],
          [1, 2]
        ].toMatrix().transpose(),
        Matrix([
          [1, 1],
          [2, 2]
        ]));
  });

  test('test transpose with string', () {
    expect(
        [
          ['1', '2'],
          ['1', '2']
        ].toMatrix().transpose(),
        Matrix([
          ['1', '1'],
          ['2', '2']
        ]));
  });

  test('test transpose with bool', () {
    expect(
        [
          [true, false],
          [true, false]
        ].toMatrix().transpose(),
        Matrix([
          [true, true],
          [false, false]
        ]));
  });

  test('test transpose with dynamic', () {
    expect(
        [
          [1, '2', true],
          [1, '2', false]
        ].toMatrix().transpose(),
        Matrix([
          [1, 1],
          ['2', '2'],
          [true, false]
        ]));
  });

  test('test reshape', () {
    expect(
        m.reshape(5, 3),
        Matrix([
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
          [10, 5, 7],
          [8, 9, 10]
        ]));
  });

  test('test #1 with 2 row and column indices', () {
    expect(
        m.slice(0, 2, 1, 4),
        Matrix([
          [2, 3, 4],
          [7, 8, 9]
        ]));
  });

  test('test diagonal', () {
    expect(m.diagonal(), [1, 7, 8]);
  });

  test('test concatenate', () {
    expect(
        Matrix([
          [1, 2],
          [3, 4]
        ]).concatenate([
          Matrix([
            [5, 6]
          ])
        ]),
        Matrix([
          [1, 2],
          [3, 4],
          [5, 6]
        ]));
  });

  test('test reciprocal', () {
    expect(
        Matrix([
          [1, 2],
          [3, 4]
        ]).reciprocal(),
        Matrix([
          [1.0, 0.5],
          [0.3333333333333333, 0.25],
        ]));
  });

  test('test dot product', () {
    expect(
        Matrix([
          [1, 2],
          [3, 4]
        ]).dot(Matrix([
          [2, 0],
          [1, 2]
        ])),
        Matrix([
          [4, 4],
          [10, 8],
        ]));
  });

  test('test inverse', () {
    expect(
        Matrix([
          [1.0, 2.0],
          [3.0, 4.0]
        ]).inverse(),
        Matrix([
          [-2.0, 1.0],
          [1.5, -0.5],
        ]));
  });

  test('test normalize', () {
    expect(
        Matrix([
          [1, 2],
          [3, 4]
        ]).normalize(),
        Matrix([
          [0.25, 0.5],
          [0.75, 1.0],
        ]));
  });

  test('test #2 with 1 row and 2 column index', () {
    expect(
        m.submatrix(rowStart: 1, rowEnd: 2, colStart: 0, colEnd: 1),
        Matrix([
          [6]
        ]));
  });

  test('test #3 with 3 row and column indices', () {
    expect(
        m.slice(0, 3, 2, 3),
        Matrix([
          [3],
          [8],
          [8]
        ]));
  });

  test('test #4', () {
    expect(
        m.slice(0, 3, 3, 4),
        Matrix([
          [4],
          [9],
          [9]
        ]));
  });

  test('test #5 flip matrix axis - 0', () {
    expect(
        m.reverse(0),
        Matrix([
          [5, 7, 8, 9, 10],
          [6, 7, 8, 9, 10],
          [1, 2, 3, 4, 5]
        ]));
  });

  test('test #6 flip matrix axis - 1', () {
    expect(
        m.reverse(1),
        Matrix([
          [5, 4, 3, 2, 1],
          [10, 9, 8, 7, 6],
          [10, 9, 8, 7, 5]
        ]));
  });

  test('test #1 Column to Diagonal', () {
    var column = Column([1, 2, 3]);
    expect(column.toDiagonal(), Diagonal([1, 2, 3]));
  });

  test('test #1 Row to Diagonal', () {
    var row = Row([1, 2, 3]);
    expect(row.toDiagonal(), Diagonal([1, 2, 3]));
  });

  test('test #2 Row to Matrix', () {
    var row = Row([1, 2, 3]);
    expect(row.toDiagonal(), Diagonal([1, 2, 3]));
  });

  test('test solve matrix', () {
    var A = Matrix([
      [2, 1, 1],
      [1, 3, 2],
      [1, 0, 0]
    ]);
    var b = Matrix([
      [4],
      [5],
      [6]
    ]);
    //var result = A.gaussianElimination(b);
    var result = A.solve(b, method: 'lu');
    expect(
        result.round(1),
        Matrix([
          [6.0],
          [15.0],
          [-23.0]
        ]));
  });
}
