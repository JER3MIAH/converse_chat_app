import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int maxLength;
  final int maxLines;
  final Color? fillColor;
  final Color? borderColor;
  final double borderRadius;
  final double? fontSize;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry contentPadding;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? Function(String?)? validator;
  final bool autoFocus;
  final bool readOnly;
  final InputDecoration? decoration;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.maxLength = 50,
    this.maxLines = 1,
    this.fillColor = Colors.white,
    this.borderColor = Colors.grey,
    this.borderRadius = 10.0,
    this.fontSize,
    this.hintStyle,
    this.labelStyle,
    this.textStyle,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.autoFocus = false,
    this.readOnly = false,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLength: maxLength,
      maxLines: maxLines,
      autofocus: autoFocus,
      readOnly: readOnly,
      style: textStyle ?? TextStyle(fontSize: fontSize ?? 16.0),
      decoration: decoration ??
          InputDecoration(
            hintText: hintText,
            labelText: labelText,
            hintStyle: hintStyle ?? const TextStyle(color: Colors.grey),
            labelStyle: labelStyle ?? const TextStyle(color: Colors.blueGrey),
            fillColor: fillColor,
            filled: true,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
            contentPadding: contentPadding,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor ?? Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor ?? Colors.blue),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor ?? Colors.grey),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      validator: validator,
    );
  }
}
