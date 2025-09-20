import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../generated/l10n.dart';

class DutyRecordText extends StatelessWidget {
  final String? timeRecord;
  const DutyRecordText({super.key, this.timeRecord});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(
          timeRecord != null ? FontAwesomeIcons.solidCircleCheck : FontAwesomeIcons.solidCircleXmark,
          color: timeRecord != null ? Color(0xffFFD58B) : Color(0xff666666),
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          timeRecord ?? S.current.notClockedIn,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
        ),
      ],
    );
  }
}
