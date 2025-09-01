import 'package:aqaraty/components/back_ground_effict.dart';
import 'package:aqaraty/components/filter_drawer.dart';
import 'package:aqaraty/components/sort_dialog.dart';
import 'package:aqaraty/api/local_data/currency2.dart';

import 'package:aqaraty/models/real_estate.dart';
import 'package:aqaraty/provider/filter.dart';
import 'package:aqaraty/provider/notifiers.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen<T extends RealEstate> extends ConsumerStatefulWidget {
  const SearchScreen(
      {super.key,
      this.onSearch,
      this.resultBuilder,
      required this.allEstates,
      this.openDrawer = false});
  final bool openDrawer;

  final List<T> Function(dynamic)? onSearch;
  final Widget Function(BuildContext, int, T)? resultBuilder;
  final List<T> allEstates;

  @override
  ConsumerState<SearchScreen<T>> createState() => _SearchScreenState<T>();
}

class _SearchScreenState<T extends RealEstate>
    extends ConsumerState<SearchScreen<T>> {
  final TextEditingController _controller = TextEditingController();
  String lastSortBy = 'createdAt';
  bool lastAscending = true;
  List<T> filteredList = [];
  List<T> result = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isAscending = true;

  void updateResult() {
    final searchQuery = _controller.text.toLowerCase();

    setState(() {
      if (searchQuery.isEmpty) {
        result = filteredList;
      } else {
        result = filteredList.where((realEstate) {
          final office = realEstate.officeName?.toLowerCase() ?? '';
          final customer = realEstate.customerName?.toLowerCase() ?? '';
          return office.contains(searchQuery) || customer.contains(searchQuery);
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.openDrawer) {
        _scaffoldKey.currentState?.openDrawer();
      }
    });
    filteredList = widget.allEstates;
    result = widget.allEstates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
      body: Stack(
        children: [
          background(context),

          // عناصر زخرفية
          circl1(context),
          circl2(context),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
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
                            fillColor: const Color.fromARGB(0, 0, 0, 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "بحث",
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
                      Builder(
                          builder: (contextt) => IconButton(
                              onPressed: () {
                                Scaffold.of(contextt).openDrawer();
                              },
                              icon: const Icon(Icons.filter_alt_outlined))),
                      IconButton(
                        icon: const Icon(Icons.sort),
                        onPressed: () async {
                          final sortResult = await showSortDialog(
                            context,
                            initialSortBy: lastSortBy,
                            initialAscending: lastAscending,
                          );

                          if (sortResult != null) {
                            setState(() {
                              final filterState = ref.read(filterProvider);
                              final core = ref.read(coreProvider);

                              result.sort((a, b) {
                                lastSortBy = sortResult.sortBy;
                                lastAscending = sortResult.ascending;

                                dynamic valA, valB;
                                switch (sortResult.sortBy) {
                                  case 'price':
                                    valA = core.convertPrice(
                                      a.price,
                                      a.currency,
                                      filterState.currency ?? Currency.SYP,
                                    );
                                    valB = core.convertPrice(
                                      b.price,
                                      b.currency,
                                      filterState.currency ?? Currency.SYP,
                                    );
                                    break;
                                  case 'rooms':
                                    valA = a.rooms;
                                    valB = b.rooms;
                                    break;
                                  case 'area':
                                    valA = a.area ?? 0;
                                    valB = b.area ?? 0;
                                    break;
                                  case 'createdAt':
                                  default:
                                    valA = a.createdAt ?? DateTime(1900);
                                    valB = b.createdAt ?? DateTime(1900);
                                    break;
                                }

                                if (valA is Comparable && valB is Comparable) {
                                  return sortResult.ascending
                                      ? valA.compareTo(valB)
                                      : valB.compareTo(valA);
                                }
                                return 0;
                              });
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (result.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("تم العثور على ${result.length} نتيجة"),
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
                          separatorBuilder: (context, index) => const Divider(
                              height: 1, endIndent: 10, indent: 10),
                          itemBuilder: (context, index) => widget.resultBuilder
                              ?.call(context, index, result[index]),
                          itemCount: result.length,
                        )),
            ],
          ),
        ],
      ),
    );
  }
}
