
import '../../domain/entities/number_trivia.dart';

abstract class NumberTriviaLocalDataSource {

  Future<NumberTrivia>? getLastCachedNumberTrivia();

  Future<void>? cacheNumberTrivia(NumberTrivia? numberTriviaModel);

}