# flutter_text_styled

A Flutter helper class to add tag-styled text into your widgets.

## Getting Started

In current version only **[b] [/b]** tags are allowed for bold text style.

Example of usage:
```dart
class StyledPage extends StatefulWidget {
  @override
  _StyledPageState createState() => _StyledPageState();
}

class _StyledPageState extends State<StyledPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBarWithBack(
        context: context,
        title: AppLocalizations.of(context).menuHelp,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: TextStyled()
                .getStyledTextWidgets("Your normal text with [b]bolded text inside[/b] "
                "\n and again normal and again [b]bold text[/b]."),
          ),
        ),
      ),
    );
  }
}
```

`getStyledTextWidgets` returns `List<Text>` widgets.

## Questions or Feedback?

Feel free to [open an issue](https://github.com/dudeck/flutter_text_styled/issues/new).