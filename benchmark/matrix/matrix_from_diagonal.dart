import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:matrix_utils/matrix_utils.dart';

const size = 10000;

class MatrixDiagonalBenchmark extends BenchmarkBase {
  MatrixDiagonalBenchmark() : super('Matrix initialization (diagonal)');

  late final List<dynamic> _source = Vector.random(size, seed: 12).toList();

  static void main() {
    MatrixDiagonalBenchmark().report();
  }

  @override
  void run() {
    Matrix.fromDiagonal(_source);
  }
}

void main() {
  MatrixDiagonalBenchmark.main();
}
