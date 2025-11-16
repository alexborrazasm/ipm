import 'package:flutter/material.dart';
import 'package:splitwiththemachine/ui/core/widgets/centered_message.dart';

/// Custom scrollable sliver list with optional header (e.g. search bar).
class ScrollableSliverList extends StatelessWidget {
  const ScrollableSliverList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.header,
    this.emptyListMsg = "",
    this.loading = false,
    this.loadBuilder,
  });

  /// Number of items to render.
  final int itemCount;

  /// Builder for each row.
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// Optional header widget (e.g. a search bar).
  final Widget? header;

  /// Optional builder for loading indicator row
  final Widget Function(BuildContext context)? loadBuilder;

  /// Optional message to show on empty list
  final String emptyListMsg;

  final bool loading;

  @override
  Widget build(BuildContext context) {
    return StretchingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        child:
        CustomScrollView(
        slivers: [
          if (header != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                  left: 12,
                  right: 12,
                  bottom: 0,
                ),
                child: header!,
              ),
            ),

          if (itemCount == 0 && !loading)
            SliverFillRemaining(
              hasScrollBody: false,
              child: CenteredMessage(message: emptyListMsg),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  itemBuilder,
                  childCount: itemCount,
                ),
              ),
            ),

          if (loading && loadBuilder != null)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverToBoxAdapter(
                child: loadBuilder!(context),
              ),
            ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 200),
          ),
        ],
      )
    );
  }
}
