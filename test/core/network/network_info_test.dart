import 'package:flutter_clean_architecture/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements InternetConnectionChecker {}

@GenerateMocks([InternetConnectionChecker])
void main() {

  late NetworkInfoImpl networkInfoImpl;
  late MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(internetConnectionChecker: mockDataConnectionChecker);
  });

  // test('should return true when the device is connected to internet', () async {
  //   final tHasConnectionFuture = Future.value(true);
  //
  //   // arrange
  //   when(mockDataConnectionChecker.hasConnection).thenAnswer((_) => tHasConnectionFuture);
  //
  //   // act
  //   final result = networkInfoImpl.isConnected;
  //
  //   // assert
  //   verify(mockDataConnectionChecker.hasConnection);
  //   expect(result, tHasConnectionFuture);
  // });
}