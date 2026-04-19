import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WeatherSearchBar extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final VoidCallback onClear;
  final bool isLoading;

  const WeatherSearchBar({super.key, required this.onSearch, required this.onClear, this.isLoading = false});

  @override
  State<WeatherSearchBar> createState() => _WeatherSearchBarState();
}

class _WeatherSearchBarState extends State<WeatherSearchBar> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final city = _controller.text.trim();
    if (city.isNotEmpty) widget.onSearch(city);
  }

  void _clear() {
    _controller.clear();
    setState(() => _hasText = false);
    widget.onClear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Skeletonizer(
      enabled: widget.isLoading,
      child: IgnorePointer(
        ignoring: widget.isLoading,
        child: Skeleton.leaf(
          enabled: widget.isLoading,
          child: SearchBar(
            controller: _controller,
            hintText: 'Search city...',
            elevation: const WidgetStatePropertyAll(0),
            backgroundColor: WidgetStatePropertyAll(theme.colorScheme.surfaceContainerHighest),
            padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
            leading: const Icon(Icons.search),
            trailing: [if (_hasText) IconButton(icon: const Icon(Icons.close), onPressed: _clear)],
            onSubmitted: (_) => _submit(),
          ),
        ),
      ),
    );
  }
}
