import 'package:aqaraty/components/filter_drawer.dart';

import 'package:aqaraty/models/real_estate.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen<T extends RealEstate> extends ConsumerStatefulWidget {
  const SearchScreen({
    super.key,
    this.onSearch,
    required this.hint,
    this.resultBuilder,
    required this.allEstates,
  });

  final String hint;
  final List<T> Function(dynamic)? onSearch;
  final Widget Function(BuildContext, int, T)? resultBuilder;
  final List<T> allEstates;

  @override
  ConsumerState<SearchScreen<T>> createState() => _SearchScreenState<T>();
}

class _SearchScreenState<T extends RealEstate>
    extends ConsumerState<SearchScreen<T>> {
  final TextEditingController _controller = TextEditingController();

  List<T> filteredList = [];
  List<T> result = [];

  void updateResult() {
    final searchQuery = _controller.text.toLowerCase();

    setState(() {
      if (searchQuery.isEmpty) {
        result = filteredList;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    filteredList = widget.allEstates;
    result = widget.allEstates;
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: FilterDrawer(
        allEstates: widget.allEstates.cast<RealEstate>(),
        onFilterChanged: (filteredEstates) {
          setState(() {
            filteredList = filteredEstates.cast<T>();
            updateResult();
          });
          Navigator.of(context).maybePop();
        },
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
            ),
            constraints: const BoxConstraints(minHeight: 50),
            child: SafeArea(
              child: Row(
                children: [
                  const BackButton(),
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      controller: _controller,
                      onChanged: (_) {
                        setState(() {
                          updateResult();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: widget.hint,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (_controller.text.isNotEmpty)
                    IconButton(
                      onPressed: () {
                        _controller.clear();
                        updateResult();
                      },
                      icon: const Icon(Icons.close),
                    ),
                ],
              ),
            ),
          ),
          // SizedBox(
          //   height: 50,
          //   child: Padding(
          //     padding: const EdgeInsets.only(top: 10),
          //     child: MyListFilter(
          //       allEstates: widget.allEstates.cast<RealEstate>(),
          //       onFilterChanged: (filtered) {
          //         setState(() {
          //           filteredList = filtered.cast<T>();
          //         });
          //         updateResult();
          //       },
          //     ),
          //   ),
          // ),
          if (result.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("تم العثور على ${result.length} نتيجة"),
            ),
          if (result.isEmpty && _controller.text.isNotEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(Icons.search_off),
                  Text("لا توجد نتائج بحث"),
                ],
              ),
            ),
          Expanded(
              child: result.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(Icons.search_off),
                          Text("لا توجد نتائج بحث"),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.zero,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1, endIndent: 10, indent: 10),
                      itemBuilder: (context, index) => widget.resultBuilder
                          ?.call(context, index, result[index]),
                      itemCount: result.length,
                    )),
        ],
      ),
    );
  }
}
