import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:slay_the_spire_path_finder_mobile/blocs/user.bloc.dart';

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

    final childrenList = userBloc.output
        .getRange(
          0,
          userBloc.outputIndex! + 1,
        )
        .map<Widget>(
          (
            outputLine,
          ) =>
              Padding(
            padding: EdgeInsets.only(
              bottom: fieldPadding,
            ),
            child: Text(
              outputLine.toString(
                l10n: l10n,
              ),
            ),
          ),
        )
        .toList();

    if (userBloc.hasMoreOutput()) {
      childrenList.add(
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: userBloc.getMoreOutput,
            child: Text(
              l10n.showMore(userBloc.outputIndex! + 1, userBloc.output.length),
            ),
          ),
        ),
      );
    }

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
        child: SingleChildScrollView(
          child: Column(
            children: childrenList,
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
