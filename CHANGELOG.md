## 0.0.4

* Added linear equation solver (cramersRule, ridgeRegression, bareissAlgorithm, inverseMatrix, gaussElimination, gaussJordanElimination, leastSquares, etc.)
* Added function to compute matrix condition number with both SVD and norm2 approaches.
* Added matrix decompositions
* - LU decompositions
  * - Crout's algorithm
  * - Doolittle algorithm
  * - Doolittle algorithm with Partial Pivoting
  * - Doolittle algorithm with Complete Pivoting
  * - Gauss Elimination Method
* - QR decompositions
  * - QR decomposition Gram Schmidt
  * - QR decomposition Householder
* - LQ decomposition
* - Cholesky Decomposition
* - Eigenvalue Decomposition
* - Singular Value Decomposition
* - Schur Decomposition
* Added matrix condition
* Added support for exponential, logarithmic, and trigonometric functions on matrices
* Added more matrix operations like scale,norm, norm2, l2Norms,
* Added support for checking matrix properties.
* Added class for Complex numbers
* Added support for to auto detect matrix types.
* Added scaleRow and addRow operations.
* Implemented new constructors like tridiagonal matrix
* Modified the Matrix.diagonal() to accept super-diagonal, diagonal, minor diagonals.
* Implemented Iterator and Iterable interfaces for easy traversal of matrix elements
* Provide methods to import and export matrices to and from other formats (e.g., CSV, JSON, binary)
* Fixed bugs

## 0.0.3

* Improved the arithmetic (+, -, *) functions to work for both scalars and matrices
* Updated range to create row and column matrices
* Added updateRow(), updateColumn, insertRow, insertColumn, appendRows, appendColumns
* Added creating random matrix
* Added more looks and feel to the toString() method
* Corrected some wrong calculations
* Fixed bugs
* Fix README file

## 0.0.2

* Added info on the README file.
* Added more functionalities
* Fixed bugs
* Tests now works with most of the functions

## 0.0.1

* initial release.
