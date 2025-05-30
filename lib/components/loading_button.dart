import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  final Future<void> Function() onPressed;
  final String text;

  const LoadingButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              widget.onPressed().then((value) {
                setState(() {
                  isLoading = false;
                });
              });
            },
      child: isLoading
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  )),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(widget.text),
            ),
    );
  }
}
