import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:slay_the_spire_path_finder_mobile/constants/settings.dart';
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

    final mediaSize = MediaQuery.of(
      context,
    ).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.title,
        ),
      ),
      body: SizedBox(
        height: mediaSize.height,
        width: mediaSize.width,
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
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: l10n.map,
                    hintText: l10n.mapHint,
                    // needs an extra -1
                    hintMaxLines: Settings.intMax53 - 1,
                  ),
                  initialValue:
                      "N-E0 N-E1 N-E2 N-E3 N-E4\nE0-E5 E1-E6 E2-U0 E3-U1 E4-M0\nE5-U2 E5-E7 E6-E7 U0-E8 U1-U3 M0-U3\nU2-M1 E7-U4 E8-U4 U3-E9\nM1-U5 U4-U5 U4-E10 E9-E10 E9-U6\nU5-R0 U5-L0 E10-R1 U6-R2\nR0-U7 R0-E11 L0-E12 R1-L1 R1-E13 R2-E14\nU7-M2 E11-L2 E12-E15 L1-E15 E13-E16 E14-E17\nM2-T0 L2-T1 E15-T1 E15-T2 E16-T3 E17-T4\nT0-E18 T1-E18 T1-R3 T2-R3 T3-E19 T4-E19\nE18-E20 R3-E20 R3-U8 E19-L3 E19-E21\nE20-E22 E20-R4 U8-E23 L3-U9 E21-E24\nE22-E25 R4-U10 E23-E26 U9-U11 E24-U11\nE25-L4 E25-E27 U10-U12 E26-E28 U11-E29\nL4-R5 E27-R5 U12-R6 E28-R7 E29-R7 E29-R8\nR5-B R6-B R7-B R8-B",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
