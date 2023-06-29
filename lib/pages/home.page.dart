import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(
      context,
    )!;

    final fieldPadding = Theme.of(
          context,
        ).textTheme.labelLarge?.fontSize ??
        0.0;

    // final halfFieldPadding = fieldPadding / 2.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.title,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(
            Theme.of(
                  context,
                ).textTheme.labelLarge?.fontSize ??
                0,
          ),
          child: Column(
            children: [
              Wrap(
                spacing: fieldPadding,
                children: [
                  IntrinsicWidth(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        // TODO
                        labelText: l10n.unknown,
                        hintText: l10n.unknown,
                      ),
                    ),
                  ),
                  IntrinsicWidth(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        // TODO
                        labelText: l10n.merchant,
                        hintText: l10n.merchant,
                      ),
                    ),
                  ),
                  IntrinsicWidth(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        // TODO
                        labelText: l10n.treasure,
                        hintText: l10n.treasure,
                      ),
                    ),
                  ),
                  IntrinsicWidth(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        // TODO
                        labelText: l10n.rest,
                        hintText: l10n.rest,
                      ),
                    ),
                  ),
                  IntrinsicWidth(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        // TODO
                        labelText: l10n.enemy,
                        hintText: l10n.enemy,
                      ),
                    ),
                  ),
                  IntrinsicWidth(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        // TODO
                        labelText: l10n.elite,
                        hintText: l10n.elite,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
