import 'package:flutter/material.dart';

// Generic SnackBar to show info messages
class GenericSnackBar {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        behavior: SnackBarBehavior.fixed,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class ErrorSnackBar {
  static OverlayEntry? _currentOverlay;

  static void show(
      BuildContext context,
      String message, {
        String? actionLabel,
        VoidCallback? onAction,
        Duration? duration,
        bool autoDismiss = false,
      }) {
    hide();

    final theme = Theme.of(context).colorScheme;
    final backgroundColor = theme.error;
    final textColor = theme.onError;

    _currentOverlay = OverlayEntry(
      builder: (context) => _ErrorSnackBarWidget(
        message: message,
        backgroundColor: backgroundColor,
        textColor: textColor,
        actionLabel: actionLabel,
        onAction: onAction,
        onClose: hide,
        duration: duration,
        autoDismiss: autoDismiss,
      ),
    );

    Overlay.of(context).insert(_currentOverlay!);
  }

  static void hide() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }
}

class _ErrorSnackBarWidget extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback onClose;
  final Duration? duration;
  final bool autoDismiss;

  const _ErrorSnackBarWidget({
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    required this.onClose,
    this.duration,
    this.autoDismiss = false,
    this.actionLabel,
    this.onAction,
  });

  @override
  State<_ErrorSnackBarWidget> createState() => _ErrorSnackBarWidgetState();
}

class _ErrorSnackBarWidgetState extends State<_ErrorSnackBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();

    if (widget.autoDismiss && widget.duration != null) {
      Future.delayed(widget.duration!, () {
        if (mounted) {
          _animateOut();
        }
      });
    }
  }

  void _animateOut() async {
    if (!mounted) return;
    await _controller.reverse();
    if (mounted) {
      widget.onClose();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: widget.textColor, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: TextStyle(
                        color: widget.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (widget.actionLabel != null && widget.onAction != null) ...[
                    OutlinedButton(
                      onPressed: () {
                        widget.onAction!();
                        _animateOut();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: widget.textColor,
                        side: BorderSide(color: widget.textColor, width: 1.5),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        widget.actionLabel!.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ] else
                    OutlinedButton(
                      onPressed: _animateOut,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: widget.textColor,
                        side: BorderSide(color: widget.textColor, width: 1.5),
                        padding: const EdgeInsets.all(8),
                        minimumSize: const Size(40, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Icon(Icons.close, color: widget.textColor, size: 20),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}