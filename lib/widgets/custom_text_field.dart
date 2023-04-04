import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  String? prompText;
  bool? isPassField;
  String? initialValue;
  String? hintText;
  Icon? prefixIcon;
  int? maxLines;

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  TextEditingController? textEditingController;
  CustomTextField({
    this.textEditingController,
    this.prompText,
    this.isPassField,
    this.initialValue,
    this.hintText,
    this.prefixIcon,
    this.controller,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.onSaved,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        obscureText: widget.isPassField ?? false,
        validator: widget.validator,
        enableSuggestions: false,
        autocorrect: false,
        maxLines: widget.maxLines,
        onSaved: widget.onSaved,
        initialValue: widget.initialValue ?? '',
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
            hintText: widget.hintText ?? '',
            labelText: widget.prompText ?? '',
            prefixIcon: widget.prefixIcon,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Theme.of(context).colorScheme.surface),
              borderRadius: BorderRadius.circular(25),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Colors.red.shade100),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Theme.of(context).colorScheme.error),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.circular(15),
            )),
      ),
    );
  }
}
