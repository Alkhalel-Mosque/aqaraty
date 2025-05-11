import 'package:aqaraty/router/router.dart';
import 'package:flutter/material.dart';

class CustomSearchBar<T> extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    this.onSearch,
    required this.hint,
    this.showLeading = false,
    required this.title,
    this.leading,
    this.trailing,
    this.resultBuilder,
  });
  final List<T> Function(dynamic)? onSearch;
  final String hint;
  final String title;
  final bool showLeading;
  final Widget? leading;
  final Widget? trailing;
  final Widget Function(BuildContext, int, T)? resultBuilder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(100)),
      constraints: const BoxConstraints(minHeight: 50),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () {
          context.myPush(
            SearchScreen<T>(
              onSearch: onSearch,
              hint: hint,
              resultBuilder: resultBuilder,
            ),
          );
        },
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            leading != null
                ? leading!
                : IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(Icons.menu),
                  ),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const IconButton(onPressed: null, icon: Icon(Icons.search))
          ],
        ),
      ),
    );
  }

  Widget cuprtinoText(String text, BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

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
