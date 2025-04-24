import 'package:flutter/material.dart' hide ConfirmDismissCallback;
import 'package:flutter_slidable/flutter_slidable.dart';

class DismissibleFavoriteDeleteWidget extends StatelessWidget {
  const DismissibleFavoriteDeleteWidget({
    super.key,
    required this.onFavorite,
    this.onDelete,
    required this.child,
    this.confirmDismiss,
  });
  final VoidCallback onFavorite;
  final VoidCallback? onDelete;
  final ConfirmDismissCallback? confirmDismiss;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (confirmDismiss != null) {
      return FutureBuilder(
        future: confirmDismiss!.call(),
        builder: (context, snapshot) {
          if (snapshot.data == true) return buildWidget(context);
          return child;
        },
      );
    }
    return buildWidget(context);
  }

  Widget buildWidget(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      startActionPane: favoriteActionPanel(context),
      endActionPane: onDelete != null ? deleteActionPanel(context) : null,
      child: child,
    );
  }

  ActionPane favoriteActionPanel(BuildContext context) => ActionPane(
    motion: const StretchMotion(),
    children: [
      SlidableAction(
        onPressed: (context) async => onFavorite.call(),
        backgroundColor: Colors.green,
        foregroundColor: Theme.of(context).colorScheme.surface,
        icon: Icons.favorite,
      ),
    ],
  );

  ActionPane deleteActionPanel(BuildContext context) => ActionPane(
    // A motion is a widget used to control how the pane animates.
    motion: const StretchMotion(),

    // A pane can dismiss the Slidable.
    dismissible: DismissiblePane(
      onDismissed: onDelete!,
      confirmDismiss: confirmDismiss,
    ),

    // All actions are defined in the children parameter.
    children: [
      // A SlidableAction can have an icon and/or a label.
      SlidableAction(
        onPressed: (context) async => onDelete!.call(),
        backgroundColor: Theme.of(context).colorScheme.error,
        foregroundColor: Theme.of(context).colorScheme.surface,
        icon: Icons.delete_outline,
      ),
    ],
  );
}
