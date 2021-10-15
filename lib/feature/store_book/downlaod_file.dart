import 'package:http/http.dart' as http;

Future<http.StreamedResponse> downloadFile() async {
  late http.StreamedResponse response;
  http.Client client = http.Client();

  response = await client.send(
    http.Request(
      'GET',
      Uri.parse('http://www.africau.edu/images/default/sample.pdf'),
    ),
  );

  return response;
}
