import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'my_text_form_field.dart';

class MyAutoComplete extends StatefulWidget {
  final void Function(String)? onChanged;
  final String? initVal;
  final String labelText;
  final bool enabled;
  final Widget? suffixIcon;
  final List<String>? data;
  final void Function(String) onSelected;
  final void Function()? onTap;

  const MyAutoComplete({
    super.key,
    required this.labelText,
    this.onTap,
    this.suffixIcon,
    this.enabled = true,
    required this.onSelected,
    this.onChanged,
    required this.data,
    this.initVal,
  });

  @override
  State<MyAutoComplete> createState() => _MyAutoCompleteState();
}

class _MyAutoCompleteState extends State<MyAutoComplete> {
  late TextEditingController textEditingController =
      TextEditingController(text: widget.initVal);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TypeAheadField<String>(
      controller: textEditingController,
      builder: (context, controller, focusNode) {
        return MyTextFormField(
          focusnode: focusNode,
          onChanged: (val) {
            widget.onChanged!(val);
          },
          labelText: widget.labelText,
          textEditingController: controller,
          enabled: widget.enabled,
          suffixIcon: widget.suffixIcon,
          minimum: 2,
          maximum: 20,
        );
      },
      hideOnLoading: true,
      onSelected: (value) {
        textEditingController.text = value;
        widget.onSelected(value);
      },
      decorationBuilder: (context, child) {
        return Material(
          type: MaterialType.card,
          elevation: 4,
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(15),
          child: child,
        );
      },
      itemBuilder: (context, itemData) {
        return CupertinoListTile(
          title: Text(
            itemData,
            style: theme.textTheme.bodyMedium,
          ),
        );
      },
      suggestionsCallback: (pattern) {
        return widget.data;
        //   if (pattern.isEmpty) {
        //     return widget.data;
        //   }
        //   List<String>? matches = widget.data
        //       ?.where((element) =>
        //           element.getSearshFilter().contains(pattern.getSearshFilter()))
        //       .toList();
        //   return matches;
      },
      hideOnEmpty: true,
    );
  }
}

extension SearshFilter on String {
  String getSearshFilter() => replaceAll("أ", "ا")
      .replaceAll("ة", "ه")
      .replaceAll("إ", "ا")
      .replaceAll(" ", "")
      .toLowerCase();
}
