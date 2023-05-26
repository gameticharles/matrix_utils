import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:matrix_utils/matrix_utils.dart';

const numOfRows = 10000;
const numOfColumns = 1000;

class MatrixFromRowsBenchmark extends BenchmarkBase {
  MatrixFromRowsBenchmark() : super('Matrix initialization (fromRows)');

  final _source = List<Row>.filled(
      numOfColumns, Row.random(numOfRows, min: -10000, max: 10000, seed: 12));

  static void main() {
    MatrixFromRowsBenchmark().report();
  }

  @override
  void run() {
    Matrix.fromRows(_source);
  }
}

void main() {
  MatrixFromRowsBenchmark.main();
}
