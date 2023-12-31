import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:slay_the_spire_path_finder_mobile/blocs/user.bloc.dart';
import 'package:slay_the_spire_path_finder_mobile/constants/settings.dart';
import 'package:slay_the_spire_path_finder_mobile/ui/pages/tabs.page.dart';

// flutter build web --base-href "/slay_the_spire_path_finder/"

void main() {
  runApp(
    const MyApp(),
  );
}

void showSnackBar({
  required String? message,
}) =>
    Settings.snackState.currentState!.showSnackBar(
      SnackBar(
        content: Text(
          message ?? "",
        ),
      ),
    );

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
          title: getTitle(
            context: context,
          ),
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
          scaffoldMessengerKey: Settings.snackState,
          home: const TabsPage(),
        ),
      );

  /// Only needed here
  getTitle({
    required BuildContext context,
  }) {
    var a = AppLocalizations.of(
      context,
    );
    return a?.title ?? "";
  }
}
