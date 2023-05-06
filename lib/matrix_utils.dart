library matrix_utils;

import 'dart:collection';

/// Dart package for matrix or list operations
/// The library was developed, documented, and published by
/// [Charles Gameti]

import 'dart:math' as math;
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:scidart/numdart.dart';
//import 'package:scidart/scidart.dart';

export 'matrix_utils.dart';

part 'src/matrix_utils.dart';
part 'src/utils/utils.dart';
part 'src/enum/enum.dart';

part 'src/models/row.dart';
part 'src/models/column.dart';
part 'src/models/diagonal.dart';
part 'src/models/eigen/eigen.dart';
part 'src/models/complex.dart';
part 'src/models/eigen/divide_conqour.dart';
part 'src/models/iterators/matrix_iterator.dart';
part 'src/models/iterators/element_iterator.dart';

part 'src/models/vector/vector.dart';
part 'src/models/vector/matrix_vector.dart';
part 'src/models/vector/vector_matrix.dart';

part 'src/extension/extension.dart';
part 'src/extension/manipulate.dart';
part 'src/extension/stats.dart';
part 'src/extension/operations.dart';
part 'src/extension/structure.dart';
part 'src/extension/hyperbolic_functions.dart';

part 'src/extension/interoperability.dart';
part 'src/extension/decomposition/decomposition.dart';
part 'src/extension/decomposition/svd.dart';
part 'src/extension/decomposition/lu.dart';
part 'src/extension/decomposition/models.dart';
part 'src/extension/linear_algebra_utils.dart';
part 'src/extension/matrix_functions.dart';
