import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:slay_the_spire_path_finder_mobile/blocs/user.bloc.dart';
import 'package:slay_the_spire_path_finder_mobile/constants/settings.dart';

class OutputPage extends StatelessWidget {
  const OutputPage({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(
      context,
    )!;

    final userBloc = Provider.of<UserBloc>(
      context,
    );

    final fieldPadding = Theme.of(
          context,
        ).textTheme.labelLarge?.fontSize ??
        0.0;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => onBackPressed(
            context: context,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.title,
              style: Theme.of(
                context,
              ).textTheme.bodySmall,
            ),
            Text(
              l10n.bestPath,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(fieldPadding),
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            labelText: l10n.outputLabel,
            hintText: l10n.outputHint,
            // needs an extra -1
            hintMaxLines: Settings.intMax53 - 1,
          ),
          initialValue: userBloc.output.join(
            "\n",
          ),
        ),
      ),
    );
  }

  onBackPressed({
    required BuildContext context,
  }) {
    final userBloc = Provider.of<UserBloc>(
      context,
      listen: false,
    );

    userBloc.clearPaths();
  }
}
