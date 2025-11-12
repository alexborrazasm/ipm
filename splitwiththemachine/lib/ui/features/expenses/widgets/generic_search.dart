import 'package:flutter/material.dart';

class GenericSearch<T extends Listenable> extends StatefulWidget {
  const GenericSearch({
    super.key,
    required this.viewModel,
    required this.getSearchQuery,
    required this.onSearchChanged,
    this.hintText = 'Search...',
  });

  final T viewModel;
  final String Function(T viewModel) getSearchQuery;
  final void Function(T viewModel, String value) onSearchChanged;
  final String hintText;

  @override
  State<GenericSearch<T>> createState() => _GenericSearchState<T>();

  static String stripAccents(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[áàäâã]'), 'a')
        .replaceAll(RegExp(r'[éèëê]'), 'e')
        .replaceAll(RegExp(r'[íìïî]'), 'i')
        .replaceAll(RegExp(r'[óòöôõ]'), 'o')
        .replaceAll(RegExp(r'[úùüû]'), 'u')
        .replaceAll('ñ', 'n');
  }

  static bool matchSearch(String source, String query) {
    if (query.trim().isEmpty) return true;
    return stripAccents(source).contains(stripAccents(query));
  }
}

class _GenericSearchState<T extends Listenable> extends State<GenericSearch<T>> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final initial = widget.getSearchQuery(widget.viewModel);
    _controller = TextEditingController(text: initial);
    widget.viewModel.addListener(_syncFromViewModel);
  }

  void _syncFromViewModel() {
    final newValue = widget.getSearchQuery(widget.viewModel);
    if (_controller.text != newValue) {
      _controller.text = newValue;
    }
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_syncFromViewModel);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: (value) => widget.onSearchChanged(widget.viewModel, value),
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }
}
