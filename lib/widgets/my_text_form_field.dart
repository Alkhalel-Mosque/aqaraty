import 'package:aqaraty/api/local_data/currency2.dart';
import 'package:aqaraty/models/real_estate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

/// ----- Formatter: يضيف فواصل كل 3 خانات مع المحافظة على موضع المؤشر -----
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter;

  ThousandsSeparatorInputFormatter({String? locale})
      : _formatter = NumberFormat.decimalPattern(locale);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // حذف كل شيء غير الأرقام
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.isEmpty) {
      return TextEditingValue(
          text: '', selection: TextSelection.collapsed(offset: 0));
    }

    // حاول تحويل للأعداد (int) ثم تنسيقها
    String formatted;
    try {
      final number = int.parse(digitsOnly);
      formatted = _formatter.format(number);
    } catch (e) {
      // لو العدد كبير جداً، نكتفي بإرجاع النص غير المعدل
      formatted = digitsOnly;
    }

    // نحسب موضع المؤشر الجديد بطريقة تحفظ المسافة من اليمين
    final selectionIndexFromRight =
        newValue.text.length - newValue.selection.end;
    final newOffset = formatted.length - selectionIndexFromRight;
    final clampedOffset = newOffset.clamp(0, formatted.length);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: clampedOffset),
    );
  }
}

/// ----- الـ Widget -----
const String validateMax = "يجب أن لا يتعدى  عن  محارف ";
const String validateMin = "يجب أن لا يقل  عن  محارف ";

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
  final bool isrequired;
  final bool iscurrency;
  final RealEstate realEstate;

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
    this.isrequired = true,
    this.iscurrency = false,
    required this.realEstate,
  });

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField>
    with SingleTickerProviderStateMixin {
  late TextEditingController textEditingController;
  late FocusNode _focusNode;
  bool _isFocused = false;
  late ThousandsSeparatorInputFormatter _thousandsFormatter;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusnode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);

    textEditingController = widget.textEditingController ??
        TextEditingController(text: widget.initVal ?? '');

    _thousandsFormatter = ThousandsSeparatorInputFormatter();

    if (widget.iscurrency && textEditingController.text.isNotEmpty) {
      final digits =
          textEditingController.text.replaceAll(RegExp(r'[^0-9]'), '');
      if (digits.isNotEmpty) {
        try {
          final number = int.parse(digits);
          textEditingController.text =
              _thousandsFormatter._formatter.format(number);
          textEditingController.selection = TextSelection.collapsed(
              offset: textEditingController.text.length);
        } catch (_) {}
      }
    }
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusnode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onLongPress: widget.enabled
          ? null
          : () => Clipboard.setData(
                ClipboardData(text: widget.initVal ?? ""),
              ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.15),
                    blurRadius: 12,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Stack(
          children: [
            TextFormField(
              minLines: 1,
              maxLines: 6,
              controller: textEditingController,
              enabled: widget.enabled,
              keyboardType: widget.textInputType,
              autofillHints: widget.autofillHints,
              focusNode: _focusNode,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              // تعديل: التعامل مع العملة
              onChanged: (val) {
                if (widget.iscurrency) {
                  final clean = val.replaceAll(',', '');
                  widget.realEstate.price = int.tryParse(clean);

                  if (clean.isNotEmpty) {
                    final formatted =
                        NumberFormat.decimalPattern().format(int.parse(clean));
                    textEditingController.value = TextEditingValue(
                      text: formatted,
                      selection:
                          TextSelection.collapsed(offset: formatted.length),
                    );
                  }
                } else {
                  widget.onChanged?.call(val);
                }
              },
              inputFormatters: widget.iscurrency
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : null,
              validator: (value) => validate(
                text: value,
                min: widget.minimum,
                max: widget.maximum,
                msgMin: validateMin,
                msgMax: validateMax,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: isDarkMode
                    ? Colors.grey[800]!.withOpacity(0.5)
                    : Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: theme.focusColor,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                prefixIcon: widget.preIcon != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: IconTheme(
                          data: IconThemeData(
                              color: _isFocused
                                  ? theme.colorScheme.primary
                                  : Colors.grey[600]),
                          child: widget.preIcon!,
                        ),
                      )
                    : null,
                suffixIcon: widget.iscurrency
                    ? IconButton(
                        icon: widget.realEstate.currency == Currency.USD
                            ? const Icon(Icons.monetization_on)
                            : Text("ل.س",
                                style: TextStyle(
                                    color: theme.canvasColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                        onPressed: () {
                          setState(() {
                            widget.realEstate.currency =
                                widget.realEstate.currency == Currency.USD
                                    ? Currency.SYP
                                    : Currency.USD;
                          });
                        },
                      )
                    : widget.suffixIcon,
                label: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  style: TextStyle(
                    color: _isFocused
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primary.withOpacity(0.7),
                    fontSize:
                        _isFocused || textEditingController.text.isNotEmpty
                            ? 14
                            : 16,
                    fontWeight:
                        _isFocused ? FontWeight.w500 : FontWeight.normal,
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: widget.labelText,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        color: theme.colorScheme.outline,
                      ),
                      children: [
                        TextSpan(
                          text: widget.isrequired ? '*' : '',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String? validate({
  required String? text,
  required int min,
  required int max,
  required String msgMin,
  required String msgMax,
}) {
  if (text == null || text.isEmpty) return null;
  if (text.length < min) return '$msgMin $min';
  if (text.length > max) return '$msgMax $max';
  return null;
}
