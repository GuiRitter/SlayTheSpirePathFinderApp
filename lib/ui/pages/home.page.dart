import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:slay_the_spire_path_finder_mobile/ui/shared/formatters/decimal_text_input.formatter.dart';

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
                      inputFormatters: [
                        DecimalTextInputFormatter(),
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.unknown,
                        hintText: l10n.unknown,
                      ),
                      initialValue: "1",
                    ),
                  ),
                  IntrinsicWidth(
                    child: TextFormField(
                      inputFormatters: [
                        DecimalTextInputFormatter(),
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.merchant,
                        hintText: l10n.merchant,
                      ),
                      initialValue: "1",
                    ),
                  ),
                  IntrinsicWidth(
                    child: TextFormField(
                      inputFormatters: [
                        DecimalTextInputFormatter(),
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.treasure,
                        hintText: l10n.treasure,
                      ),
                      initialValue: "1",
                    ),
                  ),
                  IntrinsicWidth(
                    child: TextFormField(
                      inputFormatters: [
                        DecimalTextInputFormatter(),
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.rest,
                        hintText: l10n.rest,
                      ),
                      initialValue: "1",
                    ),
                  ),
                  IntrinsicWidth(
                    child: TextFormField(
                      inputFormatters: [
                        DecimalTextInputFormatter(),
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.enemy,
                        hintText: l10n.enemy,
                      ),
                      initialValue: "1",
                    ),
                  ),
                  IntrinsicWidth(
                    child: TextFormField(
                      inputFormatters: [
                        DecimalTextInputFormatter(),
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.elite,
                        hintText: l10n.elite,
                      ),
                      initialValue: "1",
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
