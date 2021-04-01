# flutter_text_styled

A Flutter helper class to add tag-styled text into your widgets.

## Features

- [X] [b][/b] **bold text**
- [X] [i][/i] *italics text*
- [X] [u][/u] __underline text__
- [X] [color=NAME_OF_COLOR_OR_VALUE] [/color] Colored text
- [X] Hyperlinks
- [X] Styles
- [ ] Text size

In current version **[b][/b], [i][/i], [u][/u], [color=NAME_OF_COLOR_OR_VALUE] [/color] [a=LINK][/a]** tags are allowed for bold, italic, underline colored text style and hyperlinks.

`getRichText` returns `RichText` widget.

Color could be defined as name from `colors.dart` from `material` package or using int to parse by this class. See example.

List of supported colors:
-  "amber":
-  "amberAccent"
-  "black"
-  "black12"
-  "black26"
-  "black38"
-  "black45"
-  "black54"
-  "black87"
-  "blue"
-  "blueAccent"
-  "blueGrey"
-  "brown"
-  "cyan"
-  "cyanAccent"
-  "deepOrangeAccent"
-  "deepPurple"
-  "deepPurpleAccent"
-  "green"
-  "greenAccent";
-  "grey"
-  "indigo"
-  "indigoAccent"
-  "lightBlue"
-  "lightBlueAccent"
-  "lightGreen"
-  "lightGreenAccent"
-  "lime"
-  "limeAccent"
-  "orange"
-  "orangeAccent"
-  "pink"
-  "pinkAccent"
-  "purple"
-  "purpleAccent"
-  "pink"
-  "red"
-  "redAccent"
-  "teal"
-  "tealAccent"
-  "transparent"
-  "white"
-  "yellow"
-  "yellowAccent"

## Questions or Feedback?

Feel free to [open an issue](https://github.com/dudeck/flutter_text_styled/issues/new).