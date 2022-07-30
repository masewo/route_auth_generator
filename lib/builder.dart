library builder;

import 'package:build/build.dart';
import 'package:route_auth_generator/src/route_auth_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder routeAuth(BuilderOptions _) => SharedPartBuilder(
      [RouteAuthGenerator()],
      'route_auth',
    );
