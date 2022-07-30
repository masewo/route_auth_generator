import 'dart:async';
import 'package:analyzer/dart/element/element.dart'
    show ClassElement, ExecutableElement;
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart' as g;
import 'package:route_auth/route_auth.dart' as route_auth;
import 'package:code_builder/code_builder.dart' as code;
import 'package:shelf_router/shelf_router.dart' as shelf_router;

const _authType = g.TypeChecker.fromRuntime(route_auth.Auth);
const _routeType = g.TypeChecker.fromRuntime(shelf_router.Route);

class _Handler {
  final String verb, route, name;

  _Handler(this.verb, this.route, this.name);
}

code.Method _buildRouterMethod({
  required ClassElement classElement,
  required List<_Handler> handlers,
}) =>
    code.Method(
      (b) => b
        ..name = '_\$${classElement.name}Auth'
        ..returns = code.refer('List<RouteAuth>')
        ..body = code.Block(
          (b) => b
            ..addExpression(code.literalList([], code.refer('RouteAuth')).assignFinal('authList'))
            ..statements.addAll(handlers.map((h) => _buildAddHandlerCode(
                  router: code.refer('authList'),
                  handler: h,
                )))
            ..addExpression(code.refer('authList').returned),
        ),
    );

code.Code _buildAddHandlerCode({
  required code.Reference router,
  required _Handler handler,
}) {
  return router.property('add').call([
        code.refer('RouteAuth').newInstanceNamed(handler.name, [
          code.literalString(handler.verb.toUpperCase()),
          code.literalString(handler.route, raw: true)
        ])
      ]).statement;
}

class RouteAuthGenerator extends g.Generator {
  @override
  FutureOr<String?> generate(
      g.LibraryReader library, BuildStep buildStep) async {
    final classes = <ClassElement, List<_Handler>>{};

    for (final cls in library.classes) {
      final elements = getAnnotatedElementsOrderBySourceOffset(cls);
      if (elements.isEmpty) {
        continue;
      }
      print('found shelf_router.Route annotations in ${cls.name}');
      log.info('found shelf_router.Route annotations in ${cls.name}');

      classes[cls] = elements
          .map((e) {
            var auth = _authType.annotationsOfExact(e).first;
            var name = auth.variable?.name;

            if (name == null) {
              throw g.InvalidGenerationSourceError(
                  '`Auth` can only be used with a valid value (Auth.X).',
                  element: e);
            }

            var routes = _routeType.annotationsOfExact(e);

            if (routes.isEmpty) {
              throw g.InvalidGenerationSourceError(
                  '`Auth` can only be used with `Route` annotated methods.',
                  element: e);
            }

            return routes.map((a) => _Handler(
                  a.getField('verb')!.toStringValue()!,
                  a.getField('route')!.toStringValue()!,
                  name,
                ));
          })
          .expand((i) => i)
          .toList();
    }

    if (classes.isEmpty) {
      return null; // nothing to do if nothing was annotated
    }

    // Build library and emit code with all generate methods.
    final methods = classes.entries.map((e) => _buildRouterMethod(
          classElement: e.key,
          handlers: e.value,
        ));
    return code.Library((b) => b.body.addAll(methods))
        .accept(code.DartEmitter())
        .toString();
  }

  List<ExecutableElement> getAnnotatedElementsOrderBySourceOffset(
          ClassElement cls) =>
      <ExecutableElement>[
        ...cls.methods.where(_authType.hasAnnotationOfExact),
        ...cls.accessors.where(_authType.hasAnnotationOfExact)
      ]..sort((a, b) => (a.nameOffset).compareTo(b.nameOffset));
}
