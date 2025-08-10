import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class DutyRecordText extends StatelessWidget {
  final String? timeRecord;
  const DutyRecordText({super.key, this.timeRecord});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      timeRecord ?? S.current.notClockedIn,
      style: TextStyle(
        fontSize: timeRecord == null ? 18 : 24,
        fontWeight: FontWeight.w600,
        color: timeRecord != null ? colorScheme.onSurface : colorScheme.onSurface.withValues(alpha: 0.6),
      ),
    );
  }
}
