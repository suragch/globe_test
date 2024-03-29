import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

final _router = Router()
  ..get('/', _rootHandler)
  ..get('/env', _envHandler);

Response _rootHandler(Request req) {
  final keyEnv = Platform.environment['KEY'];
  const keyString = String.fromEnvironment('KEY');
  print('keyEnv: $keyEnv');
  print('keyString: $keyString');
  return Response.ok('keyEnv: $keyEnv\nkeyString: $keyString');
}

Response _envHandler(Request req) {
  final content = JsonEncoder.withIndent('  ').convert(Platform.environment);
  return Response.ok(
    content,
    headers: {'content-type': 'application/json'},
  );
}

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;
  final handler =
      Pipeline().addMiddleware(logRequests()).addHandler(_router.call);
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
