import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import '../../../../core/error/failure.dart';
import '../entities/number_trivia.dart';

class GetConcreteNumberTrivia {
  final NumberTriviaRepository numberTriviaRepository;
  const GetConcreteNumberTrivia({required this.numberTriviaRepository});

  Future<Either<Failure, NumberTrivia>?> execute({required int number}) async {
    return await numberTriviaRepository.getConcreteNumberTrivia(number);
  }
}
