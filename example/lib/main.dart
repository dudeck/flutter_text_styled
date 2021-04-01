import 'package:flutter/material.dart';
import 'package:flutter_text_styled/flutter_text_styled.dart';

void main() {
  runApp(StyledPage());
}

class StyledPage extends StatefulWidget {
  @override
  _StyledPageState createState() => _StyledPageState();
}

class _StyledPageState extends State<StyledPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Text Style Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Title"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
              child: TextStyled(
                      textStyle: TextStyle(fontSize: 30, color: Colors.red))
                  .getRichText(
                      "This is normal text [color=blue]blue text[/color] with [b]bold text[/b] [i]italic text[/i] [u]underlined text[/u] and [color=0xFFFFD600][b][i][u]mixed styled[/b][/i][/u][/color] and [a=https://pub.dev/packages/flutter_text_styled]link to open pub.dev[/a]")),
        ),
      ),
    );
  }
}
