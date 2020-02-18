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
          child: Wrap(
            children: TextStyled().getStyledTextWidgets(
                "This is normal text with [b]bold text[/b] [i]italic text[/i] [u]underlined text[/u] and [b][i][u]mixed styled[/b][/i][/u]"),
          ),
        ),
      ),
    );
  }
}
