import 'package:flutter_clean_architecture/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';

class MockDataConnectionChecker extends Mock implements InternetConnectionChecker {}

void main() {

  late NetworkInfoImpl networkInfoImpl;
  late MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(internetConnectionChecker: mockDataConnectionChecker);
  });

  test('should return true when the device is connected to internet', () async {
    // arrange
    when(() => mockDataConnectionChecker.hasConnection).thenAnswer((_) async => true);

    // act
    final result = await networkInfoImpl.isConnected;

    // assert
    verify(() => mockDataConnectionChecker.hasConnection);
    expect(result, true);
  });

  test('should return true when the device is not connected to internet', () async {
    // arrange
    when(() => mockDataConnectionChecker.hasConnection).thenAnswer((_) async => false);

    // act
    final result = await networkInfoImpl.isConnected;

    // assert
    verify(() => mockDataConnectionChecker.hasConnection);
    expect(result, false);
  });

}