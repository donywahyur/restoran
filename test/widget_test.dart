// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';

import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restoran/test_search.dart';

@GenerateMocks([http.Client])
void main() {
  test('Search', () async {
    final client = MockClient(
      (request) async {
        return http.Response(
            '{"error":false,"founded":1,"restaurants":[{"id":"rqdv5juczeskfw1e867","name":"Melting Pot","description":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.","pictureId":"14","city":"Medan","rating":4.2}]}',
            200);
      },
    );
    await when(client
        .get(Uri.parse('https://restaurant-api.dicoding.dev/search?=melting'))
        .then((response) async {
      // debugPrint(response.body.toString());
    }));

    expect(await fetchData(client), isA<searchRestoranModel>());
  });
}
