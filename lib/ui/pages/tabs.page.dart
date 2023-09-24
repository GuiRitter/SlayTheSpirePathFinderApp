import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slay_the_spire_path_finder_mobile/blocs/user.bloc.dart';
import 'package:slay_the_spire_path_finder_mobile/ui/pages/home.page.dart';
import 'package:slay_the_spire_path_finder_mobile/ui/pages/output.page.dart';

class TabsPage extends StatelessWidget {
  const TabsPage({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final userBloc = Provider.of<UserBloc>(
      context,
    );

    return (userBloc.output.isEmpty) ? HomePage() : const OutputPage();
  }
}
