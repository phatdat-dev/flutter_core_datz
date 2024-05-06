import 'package:dartz/dartz.dart';

extension EitherExtension<L, R> on Either<L, R> {
  L? toLeft() => fold((l) => l, (r) => null);
  R? toRight() => fold((l) => null, (r) => r);
}

extension EitherExceptionExtension<L extends Exception, R> on Either<L, R> {
  R toRightOrThrowError() => fold((l) => throw (l), (r) => r);
}
