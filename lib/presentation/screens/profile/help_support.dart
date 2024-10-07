import 'package:flutter/material.dart';
import 'package:students/presentation/appComponents/textComponents/text_component.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          title: const  PoppinsText(
              text: "Help And Support",
              fontSize: 22,
              fontWeight: FontWeight.w400)
      ),
      body: Column(

      ),
    );
  }
}
