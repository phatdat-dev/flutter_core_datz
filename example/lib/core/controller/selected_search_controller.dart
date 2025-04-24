import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';

// https://api.flutter.dev/flutter/material/SearchAnchor-class.html
class SelectedSearchController<T extends SearchDelegateQueryName> extends SearchController {
  SelectedSearchController({this.maxHistory = 5});
  List<T> listData = []; //nên để final
  ValueChanged<T>? onSelectionChanged;
  final int maxHistory;
  Set<T> searchHistory = {};

  T? _selectedItem;

  T? get selectedItem => _selectedItem;
  set selectedItem(T? value) {
    _selectedItem = value;
    final newText = value?.queryName ?? '';
    if (newText != text) text = newText;
  }

  void _handleSelection(T item) {
    closeView(item.queryName);
    WidgetsBinding.instance.addPostFrameCallback((_) => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus());
    //
    _selectedItem = item;

    searchHistory.remove(item);
    searchHistory.add(item);
    if (searchHistory.length > maxHistory) {
      searchHistory.remove(searchHistory.last);
    }
    //
    onSelectionChanged?.call(item);
  }

  Iterable<Widget> getHistoryList() {
    return searchHistory
        .map(
          (item) => ListTile(
            leading: const Icon(Icons.history_outlined),
            title: Text(item.queryName),
            trailing: _buildTrailingIconButton(item),
            onTap: () => _handleSelection(item),
          ),
        )
        .toList()
        .reversed;
  }

  Iterable<Widget> getSuggestions() {
    return listData
        .where((element) => element.queryName.toLowerCase().contains(text.toLowerCase()))
        .map((item) => ListTile(title: Text(item.queryName), trailing: _buildTrailingIconButton(item), onTap: () => _handleSelection(item)));
  }

  Widget _buildTrailingIconButton(T item) => IconButton(
    icon: const Icon(Icons.call_missed_outlined),
    onPressed: () {
      text = item.queryName;
      selection = TextSelection.collapsed(offset: text.length);
    },
  );
}

class TesttSearchDelegateModel extends SearchDelegateQueryName {
  final String? id;
  final String? no;
  final String? name;

  TesttSearchDelegateModel({this.id, this.no, this.name});

  @override
  String get queryName => name ?? '';
}

/*
searchController = CSearchController<TesttSearchDelegateModel>(searchSuggestions: [
      ...List.generate(10, (index) => TesttSearchDelegateModel(id: '$index', no: 'no $index', name: 'name $index')),
    ]);
    
SearchAnchor(
            searchController: searchController,
            viewHintText: 'Search friends',
            headerHintStyle: Theme.of(context).textTheme.bodySmall,
            builder: (context, searchController) => AppBarIcon(
                  icon: const Icon(MdiIcons.magnify),
                  onPressed: () => searchController.openView(),
                ),
            suggestionsBuilder: (context, searchController) {
              searchController = (searchController as CSearchController);
              if (searchController.text.isEmpty) {
                if (searchController.searchHistory.isNotEmpty) {
                  return searchController.getHistoryList();
                }
                return <Widget>[
                  const Center(
                    child: Text('No search history.', style: TextStyle(color: Colors.grey)),
                  )
                ];
              }
              return searchController.getSuggestions();
            }),
*/
