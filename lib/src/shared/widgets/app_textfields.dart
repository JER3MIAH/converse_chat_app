import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AppTextField extends HookWidget {
  final String? hintText, initialText, topLabelText, address, labelText;
  final String? Function(String?)? validator;
  final TextInputType? keyBoardType;
  final TextEditingController? controller;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSubmitted;
  final bool obscureText, readOnly, hasTopTitle, isPasswordField, isActive;
  final int? multiLine;
  final Widget? prefixWidget, suffixWidget;
  final VoidCallback? onTap;
  final double? verticalPadding;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? contentPadding;

  const AppTextField({
    super.key,
    this.hintText,
    this.topLabelText = '',
    this.labelText = '',
    this.controller,
    this.keyBoardType,
    this.validator,
    this.verticalPadding,
    this.onChanged,
    this.obscureText = false,
    this.isPasswordField = false,
    this.multiLine,
    this.onTap,
    this.readOnly = false,
    this.initialText,
    this.inputFormatters,
    this.isActive = true,
    this.onSubmitted,
    this.prefixWidget,
    this.suffixWidget,
    this.address = '',
    this.hasTopTitle = false,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final isObscure = useState<bool>(obscureText);
    final currentBorderColor = useState<Color>(
      controller != null && controller!.text.isNotEmpty
          ? theme.primary
          : appColors.inputFieldBorderColor.withOpacity(.5),
    );
    final errorText = useState<String>('');
    final focusNode = useFocusNode();

    focusNode.addListener(() {
      if (focusNode.hasFocus || address!.isNotEmpty) {
        currentBorderColor.value = theme.primary;
      } else {
        if (controller != null && controller!.text.isEmpty) {
          currentBorderColor.value = appColors.inputFieldBorderColor;
        }
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hasTopTitle
            ? Text(
                topLabelText!,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.normal,
                  height: 2,
                ),
              )
            : const SizedBox.shrink(),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: 15, vertical: verticalPadding ?? 7),
          decoration: BoxDecoration(
            border: Border.all(color: currentBorderColor.value, width: 0.7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              TextFormField(
                focusNode: !isActive ? focusNode : null,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: theme.outline),
                cursorColor: theme.primaryContainer,
                onTap: onTap,
                initialValue: initialText,
                textAlign: TextAlign.start,
                textAlignVertical: isPasswordField
                    ? TextAlignVertical.center
                    : TextAlignVertical.top,
                inputFormatters: inputFormatters,
                onFieldSubmitted: onSubmitted,
                maxLines: multiLine ?? 1,
                validator: (text) {
                  var errorMessage = validator!(text);
                  if (errorMessage != null) {
                    errorText.value = errorMessage;
                    currentBorderColor.value = appColors.error;
                  } else {
                    errorText.value = '';
                    currentBorderColor.value = theme.primary;
                  }
                  return validator!(text) != null ? '' : null;
                },
                obscureText: isObscure.value,
                onChanged: (text) {
                  if (onChanged != null) {
                    onChanged!(text);
                  }
                },
                keyboardType: keyBoardType,
                readOnly: readOnly,
                controller: controller,
                decoration: InputDecoration(
                  contentPadding: contentPadding,
                  prefixIcon: prefixWidget,
                  prefixIconConstraints: const BoxConstraints(),
                  suffix: suffixWidget,
                  suffixIcon: isPasswordField
                      ? IconButton(
                          onPressed: () {
                            isObscure.value = !isObscure.value;
                          },
                          icon: Icon(
                            isObscure.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFF476072),
                          ),
                        )
                      : null,
                  labelText: labelText,
                  hintText: hintText,
                  hintStyle: address!.isEmpty
                      ? Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: Theme.of(context).colorScheme.secondary)
                      : Theme.of(context).textTheme.displayMedium,
                ),
              ),
            ],
          ),
        ),
        if (errorText.value.isNotEmpty) YBox(12.w),
        if (errorText.value.isNotEmpty)
          Text(
            errorText.value,
            style: TextStyle(color: appColors.error, fontSize: 12),
          )
      ],
    );
  }
}
