import 'package:flutter/material.dart';
import 'package:flutter_text_styled/flutter_text_styled.dart';

class StyledPage extends StatefulWidget {
  @override
  _StyledPageState createState() => _StyledPageState();
}

class _StyledPageState extends State<StyledPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Title"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: TextStyled().getStyledTextWidgets(
                "Your normal text with [b]bolded text inside[/b] "
                "\n and again normal and again [b]bold text[/b]."),
          ),
        ),
      ),
    );
  }
}
