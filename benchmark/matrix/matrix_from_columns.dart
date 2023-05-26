import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:matrix_utils/matrix_utils.dart';

const numOfRows = 10000;
const numOfColumns = 1000;

class MatrixFromColumnsBenchmark extends BenchmarkBase {
  MatrixFromColumnsBenchmark() : super('Matrix initialization (fromColumns)');

  late List<Column> _source;

  static void main() {
    MatrixFromColumnsBenchmark().report();
  }

  @override
  void run() {
    Matrix.fromColumns(_source);
  }

  @override
  void setup() {
    _source =
        List<Column>.filled(numOfColumns, Column.random(numOfRows, seed: 12));
  }
}

void main() {
  MatrixFromColumnsBenchmark.main();
}
