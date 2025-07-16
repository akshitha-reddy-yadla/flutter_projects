import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:number_trivia_app/core/error/exceptions.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixtures_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])
void main() {
  late NumberTriviaRemoteDataSourceImpl dataSourceImpl;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSourceImpl = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(
      mockHttpClient.get(any, headers: anyNamed('headers')),
    ).thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(
      mockHttpClient.get(any, headers: anyNamed('headers')),
    ).thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreateNumberTrivia', () {
    final tNumber = 1;

    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(fixture('trivia.json')),
    );

    test(
      'should preform a GET request on a URL with number being the endpoint and with application/json header',
      () {
        setUpMockHttpClientSuccess200();

        dataSourceImpl.getConcreteNumberTrivia(tNumber);

        verify(
          mockHttpClient.get(
            Uri.parse('http://numbersapi.com/$tNumber'),
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        setUpMockHttpClientSuccess200();

        final result = await dataSourceImpl.getConcreteNumberTrivia(tNumber);

        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        setUpMockHttpClientFailure404();

        final call = dataSourceImpl.getConcreteNumberTrivia;

        expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(fixture('trivia.json')),
    );

    test(
      'should perform a GET request on a URL with random endpoint with application/json header',
      () {
        setUpMockHttpClientSuccess200();

        dataSourceImpl.getRandomNumberTrivia();

        verify(
          mockHttpClient.get(
            Uri.parse('http://numbersapi.com/random'),
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        setUpMockHttpClientSuccess200();

        final result = await dataSourceImpl.getRandomNumberTrivia();

        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should return a ServerException when the response code is not 200 (failure)',
      () async {
        setUpMockHttpClientFailure404();

        final call = dataSourceImpl.getRandomNumberTrivia;

        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
