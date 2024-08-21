import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  // Método genérico para requisições GET
  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    Uri url = Uri.parse('$baseUrl$endpoint');
    final String basicAuth = 'Basic ${base64Encode(utf8.encode('jhamerski:0612'))}';
    final response = await http.get(url, headers: {
        'Authorization': basicAuth,
      });

    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  // Método genérico para requisições POST
  Future<dynamic> post(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    Uri url = Uri.parse('$baseUrl$endpoint');
    final String basicAuth = 'Basic ${base64Encode(utf8.encode('jhamerski:0612'))}';
    print(body);
    final response = await http.post(url, body: body, headers: {
        'Authorization': basicAuth,
      });
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

Future<dynamic> postFile(String endpoint, List<int> fileContent, String fileType, String fileName,
    {Map<String, String>? headers}) async {
  Uri url = Uri.parse('$baseUrl$endpoint');
  final String basicAuth = 'Basic ${base64Encode(utf8.encode('jhamerski:0612'))}';
  String contentType;

  if (fileType == 'csv') {
    contentType = 'text/csv';
  } else if (fileType == 'xlsx') {
    contentType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
  } else {
    throw Exception('Unsupported file type');
  }

  var request = http.MultipartRequest('POST', url)
    ..headers.addAll({
      'Authorization': basicAuth,
      ...?headers,
    })
    ..files.add(http.MultipartFile.fromBytes('file', fileContent, filename: fileName, contentType: MediaType.parse(contentType)));

  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);

  return jsonDecode(utf8.decode(response.bodyBytes));
}



  // Método genérico para requisições PUT
  Future<dynamic> put(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  // Método genérico para requisições DELETE
  Future<dynamic> delete(String endpoint,
      {Map<String, String>? headers}) async {
    final response =
        await http.delete(Uri.parse('$baseUrl$endpoint'), headers: headers);
    return _processResponse(response);
  }

  // Método para processar a resposta das requisições
  dynamic _processResponse(http.Response response) {
    return response;
  }
}
