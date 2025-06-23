import 'package:aqaraty/models/real_estate.dart';
import 'package:aqaraty/pages/search_page.dart';
import 'package:aqaraty/router/router.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    this.onSearch,
    required this.hint,
    this.showLeading = false,
    required this.title,
    this.leading,
    this.trailing,
    this.resultBuilder,
    required this.allEstates,
  });

  final List<RealEstate> Function(dynamic)? onSearch;
  final String hint;
  final String title;
  final bool showLeading;
  final Widget? leading;
  final Widget? trailing;
  final Widget Function(BuildContext, int, RealEstate)? resultBuilder;
  final List<RealEstate> allEstates;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(100),
      ),
      constraints: const BoxConstraints(minHeight: 50),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () {
          context.myPush(
            SearchScreen<RealEstate>(
              allEstates: allEstates,
              onSearch: onSearch,
              hint: hint,
              resultBuilder: resultBuilder,
            ),
          );
        },
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            leading ??
                IconButton(
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
            const IconButton(onPressed: null, icon: Icon(Icons.search)),
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
