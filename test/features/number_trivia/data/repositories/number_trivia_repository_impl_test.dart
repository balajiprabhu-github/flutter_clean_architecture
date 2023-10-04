import 'package:flutter_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_clean_architecture/core/error/failure.dart';
import 'package:flutter_clean_architecture/core/network/network_info.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetWorkInfo extends Mock implements NetworkInfo {}

void main() {

  late NumberTriviaRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetWorkInfo mockNetWorkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetWorkInfo = MockNetWorkInfo();

    repository = NumberTriviaRepositoryImpl(
        numberTriviaRemoteDataSource: mockRemoteDataSource,
        numberTriviaLocalDataSource: mockLocalDataSource,
        netWorkInfo: mockNetWorkInfo);
  });

  runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetWorkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetWorkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('get concrete number trivia', () {

    const tNumber = 1;
    const NumberTriviaModel tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: "Testing");
    const tNumberTrivia = tNumberTriviaModel;


    test('should check if the device is connected to online', () async {

      // arrange
      when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber)).thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => true);
      when(() => mockNetWorkInfo.isConnected).thenAnswer((_) async => true);

      // act
      await repository.getConcreteNumberTrivia(tNumber);

      // assert
      verify(() =>  mockNetWorkInfo.isConnected).called(1);

    });

    runTestOnline(() {

      test('should return remote data when the call to remote data source is success', () async {
        // arrange

        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber)).thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => true);
        when(() => mockNetWorkInfo.isConnected).thenAnswer((_) async => true);

        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        // assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result,const Right(tNumberTrivia));

      });


      test('should cache the remote data when the call to remote data source is success', () async {
        // arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber)).thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => true);
        when(() => mockNetWorkInfo.isConnected).thenAnswer((_) async => true);

        // act
        await repository.getConcreteNumberTrivia(tNumber);

        // assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test('should return server failure data when the call to remote data source is unsuccessful', () async {
        // arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber)).thenThrow(ServerException());

        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        // assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyNoMoreInteractions(mockLocalDataSource);
        expect(result,Left(ServerFailure()));

      });
    });


    runTestOffline(() {

      test('should return cache response when device is not connected to network', () async {
        // arrange
        when(() => mockLocalDataSource.getLastCachedNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);

        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        // assert
        verify(() => mockLocalDataSource.getLastCachedNumberTrivia());
        verifyNoMoreInteractions(mockRemoteDataSource);
        expect(result,const Right(tNumberTrivia));
      });


      test('should throw cache failure when call to local data source returns cache exception', () async {
        // arrange
        when(() => mockLocalDataSource.getLastCachedNumberTrivia()).thenThrow(CacheException());

        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        // assert
        verify(() => mockLocalDataSource.getLastCachedNumberTrivia());
        verifyNoMoreInteractions(mockRemoteDataSource);
        expect(result,Left(CacheFailure()));

      });

    });

  });

  group('get random number trivia', () {

    const NumberTriviaModel tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Testing");
    const tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is connected to online', () async {

      // arrange
      when(() => mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => true);
      when(() => mockNetWorkInfo.isConnected).thenAnswer((_) async => true);

      // act
      await repository.getRandomNumberTrivia();

      // assert
      verify(() => mockNetWorkInfo.isConnected);

    });

    runTestOnline(() {

      test('should return remote data when the call to remote data source is success', () async {
        // arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => true);
        when(() => mockNetWorkInfo.isConnected).thenAnswer((_) async => true);
        // act
        final result = await repository.getRandomNumberTrivia();

        // assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        expect(result,const Right(tNumberTrivia));

      });


      test('should cache the remote data when the call to remote data source is success', () async {
        // arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => true);
        when(() => mockNetWorkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repository.getRandomNumberTrivia();

        // assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test('should return server failure data when the call to remote data source is unsuccessful', () async {
        // arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia()).thenThrow(ServerException());
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => true);
        when(() => mockNetWorkInfo.isConnected).thenAnswer((_) async => true);
        // act
        final result = await repository.getRandomNumberTrivia();

        // assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        verifyNoMoreInteractions(mockLocalDataSource);
        expect(result,Left(ServerFailure()));

      });


    });


    runTestOffline(() {

      test('should return cache response when device is not connected to network', () async {
        // arrange
        when(() => mockLocalDataSource.getLastCachedNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);

        // act
        final result = await repository.getRandomNumberTrivia();

        // assert
        verify(() => mockLocalDataSource.getLastCachedNumberTrivia());
        verifyNoMoreInteractions(mockRemoteDataSource);
        expect(result,const Right(tNumberTrivia));
      });


      test('should throw cache failure when call to local data source returns cache exception', () async {
        // arrange
        when(() => mockLocalDataSource.getLastCachedNumberTrivia()).thenThrow(CacheException());

        // act
        final result = await repository.getRandomNumberTrivia();

        // assert
        verify(() => mockLocalDataSource.getLastCachedNumberTrivia());
        verifyNoMoreInteractions(mockRemoteDataSource);
        expect(result,Left(CacheFailure()));

      });

    });

  });
}