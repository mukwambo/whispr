import 'package:fpdart/fpdart.dart';

import 'failure.dart';

/// A `Result<T>` is either a [Failure] (`Left`) or a successful value of
/// type `T` (`Right`). Domain and data layers return this instead of
/// throwing for expected failure cases, so callers pattern-match instead
/// of wrapping calls in try/catch.
typedef Result<T> = Either<Failure, T>;
