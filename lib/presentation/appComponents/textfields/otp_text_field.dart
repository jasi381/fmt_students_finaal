import 'package:flutter/material.dart';

class ResponsivePinView extends StatefulWidget {
  final int pinLength;
  final ValueChanged<String> onCompleted;

  const ResponsivePinView({
    super.key,
    this.pinLength = 4,
    required this.onCompleted,
  });

  @override
  ResponsivePinViewState createState() => ResponsivePinViewState();
}

class ResponsivePinViewState extends State<ResponsivePinView> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late List<String> _pinValues;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.pinLength, (index) => TextEditingController());
    _focusNodes = List.generate(widget.pinLength, (index) => FocusNode());
    _pinValues = List.generate(widget.pinLength, (index) => '');
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onTextChanged(int index, String value) {
    setState(() {
      _pinValues[index] = value;
    });

    if (value.length == 1) {
      if (index < widget.pinLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        widget.onCompleted(_pinValues.join());
      }
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final pinFieldWidth = screenWidth * 0.12; // Adjust as needed
    final pinFieldHeight =  MediaQuery.of(context).size.height * 0.5 ;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.pinLength, (index) {
        return SizedBox(
          width: pinFieldWidth,
          height: pinFieldHeight, // Use the same value for width and height to keep it square
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
            onChanged: (value) => _onTextChanged(index, value),
            keyboardType: TextInputType.number,
          ),
        );
      }),
    );
  }
}