import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter/material.dart";

import "package:app/repositories/.index.dart" as repositories;
import "package:app/navigation/.index.dart" as navigation;
import "package:app/usecases/.index.dart" as usecases;

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  runApp(
    _DependencyInjector(
      child: _App(
        initialRoute: navigation.Route.home.path,
      ),
    ),
  );
}

final class _DependencyInjector extends StatelessWidget {
  const _DependencyInjector({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<repositories.CurrencyRepository>(
          create: (_) => repositories.CurrencyRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<usecases.GetCurrencyCodes>(
            create: (context) => usecases.GetCurrencyCodes(
              currencyRepository: RepositoryProvider.of<repositories.CurrencyRepository>(context),
            )..execute(),
          ),
          BlocProvider<usecases.GetCurrency>(
            create: (context) => usecases.GetCurrency(
              currencyRepository: RepositoryProvider.of<repositories.CurrencyRepository>(context),
            ),
          ),
        ],
        child: child,
      ),
    );
  }
}

final class _App extends StatelessWidget {
  const _App({
    required this.initialRoute,
  });

  final String initialRoute;

  @override
  Widget build(context) {
    return MaterialApp(
      title: "Currency Information Service v0.0.1",
      onGenerateRoute: navigation.onGenerateRoute,
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        fontFamily: "Roboto",
      ),
    );
  }
}
