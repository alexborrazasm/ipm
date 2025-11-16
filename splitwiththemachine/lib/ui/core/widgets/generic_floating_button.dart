import 'package:flutter/material.dart';
import 'package:splitwiththemachine/utils/command.dart';

/// Generic Floating Action Button that listens to a ViewModel and optional commands
class GenericFloatingButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final ChangeNotifier viewModel;
  final List<Command>? commands; // Commands to listen
  final Object? heroTag;

  const GenericFloatingButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.viewModel,
    this.tooltip = '',
    this.commands,
    this.heroTag,
  });

  bool _isLoading() {
    if (commands == null || commands!.isEmpty) return false;

    return commands!.any((c) => c.running);
  }


  @override
  Widget build(BuildContext context) {
    // Listen to both the viewModel and all commands
    final listeners = <Listenable>[viewModel, ...(commands ?? [])];

    return AnimatedBuilder(
      animation: Listenable.merge(listeners),
      builder: (context, child) {
        final loading = _isLoading();

        return FloatingActionButton(
          heroTag: heroTag,
          tooltip: tooltip,
          onPressed: loading ? null : onPressed,
          child: loading
              ? SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation(
                Theme.of(context).colorScheme.onSurface,
              ),
            ),
          )
              : Icon(icon),
        );
      },
    );
  }
}
