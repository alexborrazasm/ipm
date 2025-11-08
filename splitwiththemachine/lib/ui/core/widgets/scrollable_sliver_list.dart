import 'package:flutter/material.dart';

/// Custom scrollable sliver list with optional header (e.g. search bar).
class ScrollableSliverList extends StatelessWidget {
  const ScrollableSliverList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.header,
  });

  /// Number of items to render.
  final int itemCount;

  /// Builder for each row.
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// Optional header widget (e.g. a search bar).
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              itemBuilder,
              childCount: itemCount,
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 200),
        ),
      ],
    );
  }
}
