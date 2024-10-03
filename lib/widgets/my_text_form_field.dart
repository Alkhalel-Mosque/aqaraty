import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String validateMax = "يجب ان لايتعدى الحقل عن عدد محارف ";
const String validateMin = "يجب ان لا يقل الحقل عن عدد محارف ";

class MyTextFormField extends StatefulWidget {
  final String labelText;
  final TextInputType textInputType;
  final TextEditingController? textEditingController;
  final Widget? preIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final int minimum;
  final int maximum;
  final FocusNode? focusnode;
  final void Function(String)? onChanged;
  final String? initVal;
  final Iterable<String>? autofillHints;

  const MyTextFormField({
    super.key,
    required this.labelText,
    this.enabled = true,
    this.textInputType = TextInputType.text,
    this.preIcon,
    this.suffixIcon,
    this.minimum = 0,
    this.maximum = 250,
    this.onChanged,
    this.initVal,
    this.autofillHints,
    this.focusnode,
    this.textEditingController,
  });

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    if (widget.textEditingController == null) {
      textEditingController = TextEditingController(text: widget.initVal);
    } else {
      textEditingController = widget.textEditingController!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.enabled
          ? null
          : () {
              Clipboard.setData(ClipboardData(text: widget.initVal ?? ""));
              // CustomToast.showToast(CustomToast.copySuccsed);
            },
      child: TextFormField(
        minLines: 1,
        maxLines: 6,
        validator: (value) {
          return validate(
            text: value,
            min: widget.minimum,
            max: widget.maximum,
            msgMin: validateMin,
            msgMax: validateMax,
          );
        },
        textDirection: widget.textInputType == TextInputType.emailAddress
            ? TextDirection.ltr
            : null,
        autofillHints: widget.autofillHints,
        controller: textEditingController,
        enabled: widget.enabled,
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
        inputFormatters: widget.textInputType != TextInputType.number
            ? null
            : [
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ThousandsSeparatorInputFormatter()
              ],
        focusNode: widget.focusnode,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainer,
          border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          contentPadding: const EdgeInsets.all(10),
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          labelText: widget.labelText,
          prefixIcon: widget.preIcon,
          suffixIcon: widget.suffixIcon,
        ),
        keyboardType: widget.textInputType,
      ),
    );
  }
}

validate({
  required String? text,
  required int min,
  required int max,
  required String msgMin,
  required String msgMax,
}) {
  if (text!.length < min) {
    return '$msgMin $min';
  } else if (text.length > max) {
    return '$msgMax $max';
  } else {
    return null;
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = ','; // Change this to '.' for other locales

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Short-circuit if the new value is empty
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Handle "deletion" of separator character
    String oldValueText = oldValue.text.replaceAll(separator, '');
    String newValueText = newValue.text.replaceAll(separator, '');

    if (oldValue.text.endsWith(separator) &&
        oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    // Only process if the old value and new value are different
    if (oldValueText != newValueText) {
      int selectionIndex =
          newValue.text.length - newValue.selection.extentOffset;
      final chars = newValueText.split('');

      String newString = '';
      for (int i = chars.length - 1; i >= 0; i--) {
        if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1) {
          newString = separator + newString;
        }
        newString = chars[i] + newString;
      }

      return TextEditingValue(
        text: newString.toString(),
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndex,
        ),
      );
    }

    // If the new value and old value are the same, just return as-is
    return newValue;
  }
}
