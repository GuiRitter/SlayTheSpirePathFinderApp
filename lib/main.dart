import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:slay_the_spire_path_finder_mobile/blocs/user.bloc.dart';
import 'package:slay_the_spire_path_finder_mobile/pages/tabs.page.dart';

// flutter build web --base-href "/slay_the_spire_path_finder/"

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
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserBloc>.value(
            value: UserBloc(),
          ),
        ],
        child: MaterialApp(
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
          // TODO see if the names in the map Legend change in Portuguese
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const TabsPage(),
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
