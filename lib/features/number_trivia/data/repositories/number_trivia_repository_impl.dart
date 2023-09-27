
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_clean_architecture/core/error/failure.dart';
import 'package:flutter_clean_architecture/core/platform/network_info.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {

  final NumberTriviaRemoteDataSource numberTriviaRemoteDataSource;
  final NumberTriviaLocalDataSource numberTriviaLocalDataSource;
  final NetWorkInfo netWorkInfo;

  NumberTriviaRepositoryImpl ({required this.numberTriviaRemoteDataSource,
      required this.numberTriviaLocalDataSource, required this.netWorkInfo});

  @override
  Future<Either<Failure, NumberTrivia?>?>? getConcreteNumberTrivia(int number) async {
    return await _getTrivia(() {
      return numberTriviaRemoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia?>?>? getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return numberTriviaRemoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure,NumberTrivia?>>? _getTrivia(Future<NumberTrivia?>? Function() getConcreteOrRandomTrivia) async {
    final isConnected = await netWorkInfo.isConnected ?? false;
    if (isConnected) {
      return await getRemoteSourceData(getConcreteOrRandomTrivia);
    } else {
      return await getLocalDataSource(getConcreteOrRandomTrivia);
    }
  }

  Future<Either<Failure, NumberTrivia?>> getLocalDataSource(Future<NumberTrivia?>? Function() getConcreteOrRandomTrivia) async {
    try {
      return Right(await numberTriviaLocalDataSource.getLastCachedNumberTrivia());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  Future<Either<Failure, NumberTrivia?>> getRemoteSourceData(Future<NumberTrivia?>? Function() getConcreteOrRandomTrivia) async {
    try {
      final triviaModel = await getConcreteOrRandomTrivia();
      numberTriviaLocalDataSource.cacheNumberTrivia(triviaModel);
      return Right(triviaModel);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

}