import 'package:flutter/material.dart';

class RecordListItem extends StatelessWidget {
  const RecordListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Record Title',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        'Record Subtitle',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurface),
      onTap: () {
        // Handle tap action
      },
    );
  }
}
