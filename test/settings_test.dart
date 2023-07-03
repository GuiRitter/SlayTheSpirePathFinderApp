import 'package:flutter_test/flutter_test.dart';
import 'package:slay_the_spire_path_finder_mobile/constants/settings.dart';

void main() {
  test(
    'white spaces; single incidence',
    () async {
      expect(
        Settings.mapRegex.hasMatch(
          "N-B\n",
        ),
        true,
      );
      expect(
        Settings.mapRegex.hasMatch(
          "N-B ",
        ),
        true,
      );
      expect(
        Settings.mapRegex.hasMatch(
          "N-B\n\n",
        ),
        true,
      );
      expect(
        Settings.mapRegex.hasMatch(
          "N-B  ",
        ),
        true,
      );
      expect(
        Settings.mapRegex.hasMatch(
          "N-B\n ",
        ),
        true,
      );
      expect(
        Settings.mapRegex.hasMatch(
          "N-B \n",
        ),
        true,
      );
    },
  );

  test(
    'white spaces; two incidences',
    () async {
      expect(
        Settings.mapRegex.hasMatch(
          "N-B\nN-B\n",
        ),
        true,
        reason: "single break",
      );
      expect(
        Settings.mapRegex.hasMatch(
          "N-B N-B\n",
        ),
        true,
        reason: "single space",
      );
      expect(
        Settings.mapRegex.hasMatch(
          "N-B\n\nN-B\n",
        ),
        true,
        reason: "two breaks",
      );
      expect(
        Settings.mapRegex.hasMatch(
          "N-B  N-B\n",
        ),
        true,
        reason: "two spaces",
      );
      expect(
        Settings.mapRegex.hasMatch(
          "N-B\n N-B\n",
        ),
        true,
        reason: "a break and a space",
      );
      expect(
        Settings.mapRegex.hasMatch(
          "N-B \nN-B\n",
        ),
        true,
        reason: "a space and a break",
      );
    },
  );

  test(
    'different kinds of floors',
    () async {
      expect(
        Settings.mapRegex.hasMatch(
          "N-U0 U0-M1 M1-T9 T9-R10 R10-E19 E19-L100 L100-B\n",
        ),
        true,
      );
    },
  );

  test(
    'allMatches matches nothing',
    () async {
      var matchList = Settings.floorRegex.allMatches(
        "",
      );

      expect(
        matchList.length,
        0,
      );
    },
  );

  test(
    'all matches',
    () async {
      final matchList = Settings.floorRegex.allMatches(
        "N-U0 U0-M1\nM1-T9 T9-R10 R10-E19\nE19-L100 L100-B\n",
      );

      expect(
        matchList.length,
        7,
      );

      expect(
        matchList
            .elementAt(
              0,
            )
            .namedGroup(
              "exitingNeow",
            ),
        "N",
        reason: "0 - exitingNeow",
      );
      expect(
        matchList
            .elementAt(
              0,
            )
            .namedGroup(
              "exitingFloor",
            ),
        null,
        reason: "0 - exitingFloor",
      );
      expect(
        matchList
            .elementAt(
              0,
            )
            .namedGroup(
              "exitingNumber",
            ),
        null,
        reason: "0 - exitingNumber",
      );
      expect(
        matchList
            .elementAt(
              0,
            )
            .namedGroup(
              "enteringBoss",
            ),
        null,
        reason: "0 - enteringBoss",
      );
      expect(
        matchList
            .elementAt(
              0,
            )
            .namedGroup(
              "enteringFloor",
            ),
        "U",
        reason: "0 - enteringFloor",
      );
      expect(
        matchList
            .elementAt(
              0,
            )
            .namedGroup(
              "enteringNumber",
            ),
        "0",
        reason: "0 - enteringNumber",
      );

      expect(
        matchList
            .elementAt(
              1,
            )
            .namedGroup(
              "exitingNeow",
            ),
        null,
        reason: "1 - exitingNeow",
      );
      expect(
        matchList
            .elementAt(
              1,
            )
            .namedGroup(
              "exitingFloor",
            ),
        "U",
        reason: "1 - exitingFloor",
      );
      expect(
        matchList
            .elementAt(
              1,
            )
            .namedGroup(
              "exitingNumber",
            ),
        "0",
        reason: "1 - exitingNumber",
      );
      expect(
        matchList
            .elementAt(
              1,
            )
            .namedGroup(
              "enteringBoss",
            ),
        null,
        reason: "1 - enteringBoss",
      );
      expect(
        matchList
            .elementAt(
              1,
            )
            .namedGroup(
              "enteringFloor",
            ),
        "M",
        reason: "1 - enteringFloor",
      );
      expect(
        matchList
            .elementAt(
              1,
            )
            .namedGroup(
              "enteringNumber",
            ),
        "1",
        reason: "1 - enteringNumber",
      );

      expect(
        matchList
            .elementAt(
              2,
            )
            .namedGroup(
              "exitingNeow",
            ),
        null,
        reason: "2 - exitingNeow",
      );
      expect(
        matchList
            .elementAt(
              2,
            )
            .namedGroup(
              "exitingFloor",
            ),
        "M",
        reason: "2 - exitingFloor",
      );
      expect(
        matchList
            .elementAt(
              2,
            )
            .namedGroup(
              "exitingNumber",
            ),
        "1",
        reason: "2 - exitingNumber",
      );
      expect(
        matchList
            .elementAt(
              2,
            )
            .namedGroup(
              "enteringBoss",
            ),
        null,
        reason: "2 - enteringBoss",
      );
      expect(
        matchList
            .elementAt(
              2,
            )
            .namedGroup(
              "enteringFloor",
            ),
        "T",
        reason: "2 - enteringFloor",
      );
      expect(
        matchList
            .elementAt(
              2,
            )
            .namedGroup(
              "enteringNumber",
            ),
        "9",
        reason: "2 - enteringNumber",
      );

      expect(
        matchList
            .elementAt(
              3,
            )
            .namedGroup(
              "exitingNeow",
            ),
        null,
        reason: "3 - exitingNeow",
      );
      expect(
        matchList
            .elementAt(
              3,
            )
            .namedGroup(
              "exitingFloor",
            ),
        "T",
        reason: "3 - exitingFloor",
      );
      expect(
        matchList
            .elementAt(
              3,
            )
            .namedGroup(
              "exitingNumber",
            ),
        "9",
        reason: "3 - exitingNumber",
      );
      expect(
        matchList
            .elementAt(
              3,
            )
            .namedGroup(
              "enteringBoss",
            ),
        null,
        reason: "3 - enteringBoss",
      );
      expect(
        matchList
            .elementAt(
              3,
            )
            .namedGroup(
              "enteringFloor",
            ),
        "R",
        reason: "3 - enteringFloor",
      );
      expect(
        matchList
            .elementAt(
              3,
            )
            .namedGroup(
              "enteringNumber",
            ),
        "10",
        reason: "3 - enteringNumber",
      );

      expect(
        matchList
            .elementAt(
              4,
            )
            .namedGroup(
              "exitingNeow",
            ),
        null,
        reason: "4 - exitingNeow",
      );
      expect(
        matchList
            .elementAt(
              4,
            )
            .namedGroup(
              "exitingFloor",
            ),
        "R",
        reason: "4 - exitingFloor",
      );
      expect(
        matchList
            .elementAt(
              4,
            )
            .namedGroup(
              "exitingNumber",
            ),
        "10",
        reason: "4 - exitingNumber",
      );
      expect(
        matchList
            .elementAt(
              4,
            )
            .namedGroup(
              "enteringBoss",
            ),
        null,
        reason: "4 - enteringBoss",
      );
      expect(
        matchList
            .elementAt(
              4,
            )
            .namedGroup(
              "enteringFloor",
            ),
        "E",
        reason: "4 - enteringFloor",
      );
      expect(
        matchList
            .elementAt(
              4,
            )
            .namedGroup(
              "enteringNumber",
            ),
        "19",
        reason: "4 - enteringNumber",
      );

      expect(
        matchList
            .elementAt(
              5,
            )
            .namedGroup(
              "exitingNeow",
            ),
        null,
        reason: "5 - exitingNeow",
      );
      expect(
        matchList
            .elementAt(
              5,
            )
            .namedGroup(
              "exitingFloor",
            ),
        "E",
        reason: "5 - exitingFloor",
      );
      expect(
        matchList
            .elementAt(
              5,
            )
            .namedGroup(
              "exitingNumber",
            ),
        "19",
        reason: "5 - exitingNumber",
      );
      expect(
        matchList
            .elementAt(
              5,
            )
            .namedGroup(
              "enteringBoss",
            ),
        null,
        reason: "5 - enteringBoss",
      );
      expect(
        matchList
            .elementAt(
              5,
            )
            .namedGroup(
              "enteringFloor",
            ),
        "L",
        reason: "5 - enteringFloor",
      );
      expect(
        matchList
            .elementAt(
              5,
            )
            .namedGroup(
              "enteringNumber",
            ),
        "100",
        reason: "5 - enteringNumber",
      );

      expect(
        matchList
            .elementAt(
              6,
            )
            .namedGroup(
              "exitingNeow",
            ),
        null,
        reason: "6 - exitingNeow",
      );
      expect(
        matchList
            .elementAt(
              6,
            )
            .namedGroup(
              "exitingFloor",
            ),
        "L",
        reason: "6 - exitingFloor",
      );
      expect(
        matchList
            .elementAt(
              6,
            )
            .namedGroup(
              "exitingNumber",
            ),
        "100",
        reason: "6 - exitingNumber",
      );
      expect(
        matchList
            .elementAt(
              6,
            )
            .namedGroup(
              "enteringBoss",
            ),
        "B",
        reason: "6 - enteringBoss",
      );
      expect(
        matchList
            .elementAt(
              6,
            )
            .namedGroup(
              "enteringFloor",
            ),
        null,
        reason: "6 - enteringFloor",
      );
      expect(
        matchList
            .elementAt(
              6,
            )
            .namedGroup(
              "enteringNumber",
            ),
        null,
        reason: "6 - enteringNumber",
      );
    },
  );

  test(
    'allMatches does not fail despite malformatted input',
    () async {
      final matchList = Settings.floorRegex.allMatches(
        "N-U0 U0-M1\nM1-T9 T9R10 R10-E19\nE19-L100 L100-B\n",
      );

      expect(
        matchList.length,
        6,
      );
    },
  );
}
