import 'package:flutter/material.dart';

class NotifyCardWidget extends StatelessWidget {
  const NotifyCardWidget({
    super.key,
    this.isRead = false,
  });
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        isThreeLine: true,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            border: Border.fromBorderSide(BorderSide(color: Colors.grey, width: 0.5)),
          ),
          child: const Icon(Icons.notifications_outlined),
        ),
        title: Row(
          children: [
            if (!isRead)
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Icon(Icons.circle, color: Colors.green, size: Theme.of(context).textTheme.bodySmall?.fontSize),
              ),
            Text(
              'Title',
              style: TextStyle(
                fontWeight: !isRead ? FontWeight.bold : null,
                fontStyle: isRead ? FontStyle.italic : null,
              ),
            ),
            const Spacer(),
            const Text('Date Ago'),
          ],
        ),
        subtitle: const Text(
          'lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
          maxLines: 3,
        ),
        titleTextStyle: Theme.of(context).textTheme.titleSmall,
        subtitleTextStyle: Theme.of(context).textTheme.bodySmall?.apply(fontSizeFactor: 0.9),
      ),
    );
  }
}
