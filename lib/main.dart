import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) =>
      MaterialApp(
        title: getTitle(context),
        theme: Theme.of(
          context,
        ).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.brown,
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.brown,
          ),
        ),
        // flutter gen-l10n
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Slay the Spire Path Finder",
            ),
          ),
        ),
      );

  /// Only needed here
  getTitle(
    context,
  ) {
    var a = AppLocalizations.of(
      context,
    );
    return a?.title ?? "";
  }
}
