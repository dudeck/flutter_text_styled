import 'package:flutter/material.dart';
import 'package:flutter_text_styled/flutter_text_styled.dart';

void main() {
  runApp(const StyledPage());
}

class StyledPage extends StatefulWidget {
  const StyledPage({super.key});

  @override
  StyledPageState createState() => StyledPageState();
}

class StyledPageState extends State<StyledPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Text Style Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Title"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: TextStyled(
              textStyle: const TextStyle(
                fontSize: 30,
                color: Colors.grey,
              ),
            ).getRichText(
                "This is normal grey by style text [color=blue]blue text[/color] with [b]bold text[/b] [i]italic text[/i] [u]underlined text[/u] and [color=0xFFFFD600][b][i][u]mixed styled[/b][/i][/u][/color] and [a=https://pub.dev/packages/flutter_text_styled] link to open pub.dev[/a]"),
          ),
        ),
      ),
    );
  }
}
