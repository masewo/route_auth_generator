// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// RouteAuthGenerator
// **************************************************************************

List<RouteAuth> _$AppAuth() {
  final authList = <RouteAuth>[];
  authList.add(RouteAuth.configurable('GET', r'/api/packages/<name>'));
  authList.add(RouteAuth.configurable(
      'GET', r'/api/packages/<name>/versions/<version>'));
  authList.add(RouteAuth.anonymous(
      'GET', r'/packages/<name>/versions/<version>.tar.gz'));
  authList.add(RouteAuth.always('GET', r'/api/packages/versions/new'));
  authList.add(RouteAuth.always('POST', r'/api/packages/versions/newUpload'));
  authList
      .add(RouteAuth.always('GET', r'/api/packages/versions/newUploadFinish'));
  authList.add(RouteAuth.always('POST', r'/api/packages/<name>/uploaders'));
  authList.add(
      RouteAuth.always('DELETE', r'/api/packages/<name>/uploaders/<email>'));
  authList.add(RouteAuth.configurable('GET', r'/webapi/packages'));
  authList
      .add(RouteAuth.configurable('GET', r'/webapi/package/<name>/<version>'));
  authList.add(RouteAuth.always('GET', r'/webapi/token'));
  authList.add(RouteAuth.always('POST', r'/webapi/token'));
  authList.add(RouteAuth.anonymous('GET', r'/'));
  authList.add(RouteAuth.anonymous('GET', r'/packages'));
  authList.add(RouteAuth.anonymous('GET', r'/packages/<name>'));
  authList
      .add(RouteAuth.anonymous('GET', r'/packages/<name>/versions/<version>'));
  authList.add(RouteAuth.anonymous('GET', r'/tokens'));
  authList.add(RouteAuth.anonymous('GET', r'/tokens/new'));
  authList.add(RouteAuth.anonymous('GET', r'/main.dart.js'));
  authList.add(RouteAuth.anonymous('GET', r'/badge/<type>/<name>'));
  return authList;
}

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$AppRouter(App service) {
  final router = Router();
  router.add('GET', r'/api/packages/<name>', service.getVersions);
  router.add(
      'GET', r'/api/packages/<name>/versions/<version>', service.getVersion);
  router.add(
      'GET', r'/packages/<name>/versions/<version>.tar.gz', service.download);
  router.add('GET', r'/api/packages/versions/new', service.getUploadUrl);
  router.add('POST', r'/api/packages/versions/newUpload', service.upload);
  router.add(
      'GET', r'/api/packages/versions/newUploadFinish', service.uploadFinish);
  router.add('POST', r'/api/packages/<name>/uploaders', service.addUploader);
  router.add('DELETE', r'/api/packages/<name>/uploaders/<email>',
      service.removeUploader);
  router.add('GET', r'/webapi/packages', service.getPackages);
  router.add('GET', r'/packages/<name>.json', service.getPackageVersions);
  router.add(
      'GET', r'/webapi/package/<name>/<version>', service.getPackageDetail);
  router.add('GET', r'/webapi/token', service.getToken);
  router.add('POST', r'/webapi/token', service.createToken);
  router.add('GET', r'/', service.indexHtml);
  router.add('GET', r'/packages', service.indexHtml);
  router.add('GET', r'/packages/<name>', service.indexHtml);
  router.add('GET', r'/packages/<name>/versions/<version>', service.indexHtml);
  router.add('GET', r'/tokens', service.indexHtml);
  router.add('GET', r'/tokens/new', service.indexHtml);
  router.add('GET', r'/main.dart.js', service.mainDartJs);
  router.add('GET', r'/badge/<type>/<name>', service.badge);
  return router;
}
