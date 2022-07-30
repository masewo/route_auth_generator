import 'dart:io';

import 'package:example/auth_middleware.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_router/shelf_router.dart';
import 'package:route_auth/route_auth.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

part 'app.g.dart';

class App {

  Future<HttpServer> serve([
    String host = '0.0.0.0',
    int port = 4000,
    bool strictAuth = false,
  ]) async {
    //final routeOptions = findRouteAuthsFromDeclarations(App);

    var handler = const shelf.Pipeline()
        .addMiddleware(shelf.logRequests())
        .addMiddleware(authMiddleware(strictAuth: strictAuth, routeOptions: routeAuth))
        .addHandler((req) async {
      // Return 404 by default
      // https://github.com/google/dart-neats/issues/1
      var res = await router.call(req);
      return res;
    });

    var server = await shelf_io.serve(handler, host, port);
    return server;
  }

  Router get router => _$AppRouter(this);
  List<RouteAuth> get routeAuth => _$AppAuth();

  @Auth.configurable
  @Route.get('/api/packages/<name>')
  Future<shelf.Response> getVersions(shelf.Request req, String name) async {
    return shelf.Response.ok(null);
  }

  @Auth.configurable
  @Route.get('/api/packages/<name>/versions/<version>')
  Future<shelf.Response> getVersion(
      shelf.Request req, String name, String version) async {
    return shelf.Response.ok(null);
  }

  @Auth.anonymous
  @Route.get('/packages/<name>/versions/<version>.tar.gz')
  Future<shelf.Response> download(
      shelf.Request req, String name, String version) async {
    return shelf.Response.ok(null);
  }

  @Auth.always
  @Route.get('/api/packages/versions/new')
  Future<shelf.Response> getUploadUrl(shelf.Request req) async {
    return shelf.Response.ok(null);
  }

  @Auth.always
  @Route.post('/api/packages/versions/newUpload')
  Future<shelf.Response> upload(shelf.Request req) async {
    return shelf.Response.ok(null);
  }

  @Auth.always
  @Route.get('/api/packages/versions/newUploadFinish')
  Future<shelf.Response> uploadFinish(shelf.Request req) async {
    return shelf.Response.ok(null);
  }

  @Auth.always
  @Route.post('/api/packages/<name>/uploaders')
  Future<shelf.Response> addUploader(shelf.Request req, String name) async {
    return shelf.Response.ok(null);
  }

  @Auth.always
  @Route.delete('/api/packages/<name>/uploaders/<email>')
  Future<shelf.Response> removeUploader(
      shelf.Request req, String name, String email) async {
    return shelf.Response.ok(null);
  }

  @Auth.configurable
  @Route.get('/webapi/packages')
  Future<shelf.Response> getPackages(shelf.Request req) async {
    return shelf.Response.ok(null);
  }

  // TODO: Auth?
  @Route.get('/packages/<name>.json')
  Future<shelf.Response> getPackageVersions(
      shelf.Request req, String name) async {
    return shelf.Response.ok(null);
  }

  @Auth.configurable
  @Route.get('/webapi/package/<name>/<version>')
  Future<shelf.Response> getPackageDetail(
      shelf.Request req, String name, String version) async {
    return shelf.Response.ok(null);
  }

  @Auth.always
  @Route.get('/webapi/token')
  Future<shelf.Response> getToken(shelf.Request req) async {
    return shelf.Response.ok(null);
  }

  @Auth.always
  @Route.post('/webapi/token')
  Future<shelf.Response> createToken(shelf.Request req) async {
    return shelf.Response.ok(null);
  }

  @Auth.anonymous
  @Route.get('/')
  @Route.get('/packages')
  @Route.get('/packages/<name>')
  @Route.get('/packages/<name>/versions/<version>')
  @Route.get('/tokens')
  @Route.get('/tokens/new')
  Future<shelf.Response> indexHtml(shelf.Request req) async {
    return shelf.Response.ok(null);
  }

  @Auth.anonymous
  @Route.get('/main.dart.js')
  Future<shelf.Response> mainDartJs(shelf.Request req) async {
    return shelf.Response.ok(null);
  }

  @Auth.anonymous
  @Route.get('/badge/<type>/<name>')
  Future<shelf.Response> badge(
      shelf.Request req, String type, String name) async {
    return shelf.Response.ok(null);
  }
}
