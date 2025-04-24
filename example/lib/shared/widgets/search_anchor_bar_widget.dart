import 'package:flutter/material.dart';

import '../../core/controller/selected_search_controller.dart';

class SearchAnchorBarWidget extends StatefulWidget {
  const SearchAnchorBarWidget({
    super.key,
    required this.searchController,
    this.barLeading,
    this.barTrailing,
    this.viewTrailing,
    this.barHintText,
    this.viewShape,
    this.barShape,
    this.onTapAndScrollToTop = false,
    this.onTap,
  });
  final SelectedSearchController searchController;
  final Widget? barLeading;
  final Iterable<Widget>? barTrailing;
  final Iterable<Widget>? viewTrailing;
  final String? barHintText;
  final OutlinedBorder? viewShape;
  final OutlinedBorder? barShape;
  final bool onTapAndScrollToTop;
  final VoidCallback? onTap;

  @override
  State<SearchAnchorBarWidget> createState() => _SearchAnchorBarWidgetState();
}

class _SearchAnchorBarWidgetState extends State<SearchAnchorBarWidget> {
  double _scrollPosition = 0;

  void updateScrollPosition() => _scrollPosition = Scrollable.of(context).position.pixels;

  Future<void> _handleOnTapAndScrollToTop() async {
    final currentPosition = Scrollable.of(context).position.pixels;

    await Scrollable.ensureVisible(context, duration: const Duration(milliseconds: 100));
    if (widget.searchController.isOpen) return;

    if (currentPosition != _scrollPosition || currentPosition == 0) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.searchController.openView();
        updateScrollPosition();
      });
    } else {
      widget.searchController.openView();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTapAndScrollToTop) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _handleOnTapAndScrollToTop,
        child: IgnorePointer(child: _buildSearchBar()),
      );
    }
    if (widget.onTap != null) {
      return GestureDetector(behavior: HitTestBehavior.translucent, onTap: widget.onTap, child: IgnorePointer(child: _buildSearchBar()));
    }
    return _buildSearchBar();
  }

  Widget _buildSearchBar() => SearchAnchor.bar(
    searchController: widget.searchController,
    isFullScreen: false,
    barBackgroundColor: WidgetStatePropertyAll(Theme.of(context).inputDecorationTheme.fillColor),
    barShape: WidgetStatePropertyAll(widget.barShape ?? _getShape(context)),
    barElevation: const WidgetStatePropertyAll(0),
    barLeading: widget.barLeading,
    barPadding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 12)),
    barTrailing: widget.barTrailing,
    barHintText: widget.barHintText,
    //
    viewShape: widget.viewShape ?? _getShape(context),
    viewTrailing: widget.viewTrailing ?? [IconButton(icon: const Icon(Icons.close), onPressed: widget.searchController.clear)],
    viewConstraints: MediaQuery.sizeOf(context).height > 1000 ? null : const BoxConstraints(maxHeight: 300),
    suggestionsBuilder: (context, searchController) {
      (searchController as SelectedSearchController);
      return [
        if (widget.searchController.searchHistory.isNotEmpty)
          ...widget.searchController.getHistoryList()
        else
          const Center(child: Text('No search history.', style: TextStyle(color: Colors.grey))),
        const Divider(),
        ...widget.searchController.getSuggestions(),
      ];
    },
  );

  OutlinedBorder _getShape(BuildContext context) => RoundedRectangleBorder(
    borderRadius: const BorderRadius.all(Radius.circular(15)),
    side: BorderSide(color: Theme.of(context).hintColor, width: 0.1),
  );
}
