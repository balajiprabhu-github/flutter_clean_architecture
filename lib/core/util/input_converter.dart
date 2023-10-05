import 'package:dartz/dartz.dart';
import '../error/failure.dart';

class InputConverter {
  Either<Failure,int?> stringToUnsignedInteger(String string) {
    int? value = int.tryParse(string);
    if (value != null && value >= 0) {
      return Right(value);
    } else {
      return Left(InvalidInputFailure()); // Parsing failed or negative value
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object?> get props => [];
}