import "package:flutter/material.dart";

import "package:app/ui/.index.dart" as ui;

enum Route {
  home(path: "/");

  const Route({
    required this.path,
  });

  final String path;
}

MaterialPageRoute<Widget> onGenerateRoute(RouteSettings settings) {
  MaterialPageRoute<Widget> getRoute(Widget widget) {
    return MaterialPageRoute(
      builder: (context) => widget,
    );
  }

  if (settings.name == Route.home.path) {
    return getRoute(const ui.Home());
  }

  throw Exception("ROUTE_NOT_DEFINED: ${settings.name}");
}
