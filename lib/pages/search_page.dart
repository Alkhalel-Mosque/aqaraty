import 'package:aqaraty/components/filter_button.dart';
import 'package:aqaraty/components/my_list_filter.dart';
import 'package:aqaraty/enums/enums.dart';
import 'package:flutter/material.dart';

class SearchScreen<T> extends StatefulWidget {
  const SearchScreen({
    super.key,
    this.onSearch,
    required this.hint,
    this.resultBuilder,
  });
  final String hint;
  final List<T> Function(dynamic)? onSearch;
  final Widget Function(BuildContext, int, T)? resultBuilder;
  @override
  State<SearchScreen<T>> createState() => _SearchScreenState<T>();
}

class _SearchScreenState<T> extends State<SearchScreen<T>> {
  List<T> result = [];

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                      onChanged: (value) {
                        setState(() {
                          result = widget.onSearch?.call(value) ?? [];
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
                        setState(() {
                          _controller.clear();
                          result = [];
                        });
                      },
                      icon: const Icon(Icons.close),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 50,
            child: Padding(
                padding: EdgeInsets.only(top: 10), child: MyListFilter()),
          ),
          if (result.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("تم العثور على ${result.length} نتيجة"),
            ),
          if (result.isEmpty && _controller.text.isNotEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Icon(Icons.data_array),
            ),
          if (result.isEmpty && _controller.text.isNotEmpty)
            const Text("لاتوجد نتائج بحث"),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, endIndent: 10, indent: 10),
              itemBuilder: (context, index) =>
                  widget.resultBuilder?.call(context, index, result[index]),
              itemCount: result.length,
            ),
          ),
        ],
      ),
    );
  }
}
