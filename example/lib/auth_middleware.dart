import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:shelf/shelf.dart';
import 'package:route_auth/route_auth.dart';

Middleware authMiddleware(
    {bool strictAuth = false, List<RouteAuth> routeOptions = const []}) {
  return (Handler handler) {
    return (Request request) async {
      final routeOption = routeOptions.firstWhereOrNull(
          (r) => r.match(request.method, '/${request.url.path}'));

      if (routeOption == null && strictAuth) {
        return _forbidden('Unauthorized.');
      } else if (routeOption == null) {
        return handler(request);
      }

      if (routeOption.isAnonymous) {
        return handler(request);
      } else if (routeOption.isConfigurable && !strictAuth) {
        return handler(request);
      }

      final authHeader = request.headers[HttpHeaders.authorizationHeader];
      final token = authHeader?.replaceFirst('Bearer ', '');

      if (token == null) {
        return _forbidden('Missing authorization header.');
      }

      // TODO: do your auth check here!
      final authResult = null;

      if (authResult == null) {
        return _forbidden('Not authenticated.');
      }

      final newRequest = request.change(
          context: {...request.context, 'auth_result': authResult});
      return await handler(newRequest);
    };
  };
}

Response _forbidden(String message) => Response(
      HttpStatus.unauthorized,
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
        HttpHeaders.wwwAuthenticateHeader:
            'Bearer realm="auth", message="$message"'
      },
      body: jsonEncode({
        'error': {'message': message}
      }),
    );
