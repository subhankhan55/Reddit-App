// lib/core/type_defs.dart

import 'package:fpdart/fpdart.dart';
import 'package:reddit_app/core/failure.dart';

// Represents a Future that returns nothing (void) on success, or a Failure on error.
typedef FutureVoid = Future<Either<Failure, void>>;

// Represents a Future that returns an arbitrary Type 'T' on success, or a Failure on error.
typedef FutureEither<T> = Future<Either<Failure, T>>;
