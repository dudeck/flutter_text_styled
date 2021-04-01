library flutter_text_styled;

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

enum TAGS { BOLD, ITALIC, UNDERLINE, COLOR, LINK }

RegExp _anyTagRegExp = RegExp(
    r'\[[\/]{0,1}[b|i|u]\]|(\[color[\=]{0,1}.+?\])|\[\/color\]|(\[a[\=]{0,1}.+?\])|\[\/a\]');
RegExp _openTagRegExp =
    RegExp(r'\[[b|i|u]\]|(\[color[\=]{0,1}.+?\])|(\[a[\=]{0,1}.+?\])');
RegExp _closeTagRegExp = RegExp(r'\[\/[b|i|u]\]|(\[\/color\])|(\[\/a\])');

class TextStyled {
  final TextStyle textStyle;

  String? _remainingText;
  int? _startStyledTextIndex;
  String? _normalText;
  int? _endStyledTextIndex;
  String? _styledText;

  LinkedHashMap<TAGS, String> _styledTextTags = LinkedHashMap<TAGS, String>();

  static const BOLD_START_TAG = '[b]';
  static const BOLD_END_TAG = '[/b]';

  static const ITALIC_START_TAG = '[i]';
  static const ITALIC_END_TAG = '[/i]';

  static const UNDERLINE_START_TAG = '[u]';
  static const UNDERLINE_END_TAG = '[/u]';

  static const COLOR_START_TAG = '[color=';
  static const COLOR_END_TAG = '[/color]';

  static const HYPERLINK_START_TAG = '[a=';
  static const HYPERLINK_END_TAG = '[/a]';

  static const REPLACEMENT_EMPTY_TAG = "";

  TextStyled({this.textStyle = const TextStyle()});

  RichText getRichText(String text) {
    List<TextSpan> resultWidgets = [];
    _remainingText = text;
    while (_remainingText != null && _remainingText!.isNotEmpty) {
      int openTagIndex = _remainingText!.indexOf(_openTagRegExp);
      int closeTagIndex = _remainingText!.indexOf(_closeTagRegExp);

      _handleTagOnFirstIndex(openTagIndex, closeTagIndex);

      _handleNextTag(openTagIndex, closeTagIndex, resultWidgets);
    }
    return RichText(text: TextSpan(style: textStyle, children: resultWidgets));
  }

  void _handleNextTag(
      int openTagIndex, int closeTagIndex, List<TextSpan> resultWidgets) {
    if (openTagIndex == -1 && closeTagIndex == -1) {
      _normalText = _remainingText;
      _addNormalTextWidget(resultWidgets);
      _remainingText = null;
    } else {
      _findStartStyledTextIndex(openTagIndex, closeTagIndex);
      _findEndStyledTextIndex(resultWidgets, openTagIndex, closeTagIndex);
    }
  }

  void _handleTagOnFirstIndex(int openTagIndex, int closeTagIndex) {
    if (openTagIndex == 0) {
      _addStyledTag(openTagIndex);
      _remainingText!.replaceFirst(_openTagRegExp, REPLACEMENT_EMPTY_TAG);
    }
    if (closeTagIndex == 0) {
      _removeStyledTag(closeTagIndex);
      _remainingText!.replaceFirst(_closeTagRegExp, REPLACEMENT_EMPTY_TAG);
    }
  }

  void _removeStyledTag(int tagIndex) {
    if (_remainingText!.indexOf(BOLD_END_TAG) == tagIndex) {
      _styledTextTags.remove(TAGS.BOLD);
    } else if (_remainingText!.indexOf(ITALIC_END_TAG) == tagIndex) {
      _styledTextTags.remove(TAGS.ITALIC);
    } else if (_remainingText!.indexOf(UNDERLINE_END_TAG) == tagIndex) {
      _styledTextTags.remove(TAGS.UNDERLINE);
    } else if (_remainingText!.indexOf(COLOR_END_TAG) == tagIndex) {
      _styledTextTags.remove(TAGS.COLOR);
    } else if (_remainingText!.indexOf(HYPERLINK_END_TAG) == tagIndex) {
      _styledTextTags.remove(TAGS.LINK);
    }
  }

  void _addStyledTag(int tagIndex) {
    if (_remainingText!.indexOf(BOLD_START_TAG) == tagIndex) {
      _styledTextTags.putIfAbsent(TAGS.BOLD, () => "");
    } else if (_remainingText!.indexOf(ITALIC_START_TAG) == tagIndex) {
      _styledTextTags.putIfAbsent(TAGS.ITALIC, () => "");
    } else if (_remainingText!.indexOf(UNDERLINE_START_TAG) == tagIndex) {
      _styledTextTags.putIfAbsent(TAGS.UNDERLINE, () => "");
    } else if (_remainingText!.indexOf(COLOR_START_TAG) == tagIndex) {
      final int indexOfCloseColorTag = _remainingText!.indexOf("]");
      final color =
          _remainingText!.substring(tagIndex + 7, indexOfCloseColorTag);
      _styledTextTags.putIfAbsent(TAGS.COLOR, () => color);
    } else if (_remainingText!.indexOf(HYPERLINK_START_TAG) == tagIndex) {
      final int indexOfCloseHyperlinkTag = _remainingText!.indexOf("]");
      final link =
          _remainingText!.substring(tagIndex + 3, indexOfCloseHyperlinkTag);
      _styledTextTags.putIfAbsent(TAGS.LINK, () => link);
    }

    if (tagIndex < 0) {
      _startStyledTextIndex = _remainingText!.length;
    }
  }

  void _findStartStyledTextIndex(int openTagIndex, int closeTagIndex) {
    if (openTagIndex < closeTagIndex && openTagIndex != -1) {
      if (openTagIndex != -1) {
        _startStyledTextIndex = openTagIndex;
        _addStyledTag(openTagIndex);
      } else {
        _startStyledTextIndex = 0;
      }
    } else {
      if (closeTagIndex != -1) {
        _startStyledTextIndex = closeTagIndex;
        _removeStyledTag(closeTagIndex);
      }
    }

    _normalText = _remainingText!.substring(0, _startStyledTextIndex);
    _remainingText = _remainingText!
        .substring(_startStyledTextIndex!, _remainingText!.length);
    _remainingText =
        _remainingText!.replaceFirst(_anyTagRegExp, REPLACEMENT_EMPTY_TAG);
  }

  void _findEndStyledTextIndex(
      List<TextSpan> resultWidgets, int openTagIndex, int closeTagIndex) {
    int openTagIndex = _remainingText!.indexOf(_openTagRegExp);
    int closeTagIndex = _remainingText!.indexOf(_closeTagRegExp);

    if (openTagIndex < closeTagIndex && openTagIndex != -1) {
      if (openTagIndex != -1) {
        _endStyledTextIndex = openTagIndex;
        _generateTextWidgets(resultWidgets);
        _addStyledTag(openTagIndex);
      }
    } else {
      if (closeTagIndex != -1) {
        _endStyledTextIndex = closeTagIndex;
        _generateTextWidgets(resultWidgets);
        _removeStyledTag(closeTagIndex);
      }
    }
  }

  void _generateTextWidgets(List<TextSpan> resultWidgets) {
    _styledText = _remainingText!.substring(0, _endStyledTextIndex);
    _remainingText =
        _remainingText!.substring(_endStyledTextIndex!, _remainingText!.length);
    _remainingText!.replaceFirst(_anyTagRegExp, REPLACEMENT_EMPTY_TAG);
    _clearTagsFromText();
    _addNormalTextWidget(resultWidgets);
    _addStyledTextWidget(resultWidgets);
  }

  void _addNormalTextWidget(List<TextSpan> resultWidgets) {
    if (_normalText != null && _normalText!.isNotEmpty) {
      resultWidgets.add(TextSpan(
        text: _normalText!,
      ));
      _normalText = null;
    }
  }

  void _addStyledTextWidget(List<TextSpan> resultWidgets) {
    if (_styledText != null && _styledText!.isNotEmpty) {
      resultWidgets.add(_generateTextStyledWidgets());
      _styledText = null;
    }
  }

  void _clearTagsFromText() {
    _styledText!.replaceAll(_anyTagRegExp, REPLACEMENT_EMPTY_TAG);
    _normalText!.replaceAll(_anyTagRegExp, REPLACEMENT_EMPTY_TAG);
  }

  TextSpan _generateTextStyledWidgets() {
    TextStyle style = textStyle;
    String link = '';
    _styledTextTags.forEach((tag, value) {
      switch (tag) {
        case TAGS.BOLD:
          style = style.copyWith(fontWeight: FontWeight.bold);
          break;
        case TAGS.ITALIC:
          style = style.copyWith(fontStyle: FontStyle.italic);
          break;
        case TAGS.UNDERLINE:
          style = style.copyWith(decoration: TextDecoration.underline);
          break;
        case TAGS.COLOR:
          style = _getColorStyle(value, style);
          break;
        case TAGS.LINK:
          style = style.copyWith(
              decoration: TextDecoration.underline, color: Colors.blue);
          link = value;
          break;
      }
    });
    return TextSpan(
      text: _styledText!,
      style: style,
    );
  }

  TextStyle _getColorStyle(String value, TextStyle style) {
    switch (value) {
      case "amber":
        style = style.copyWith(color: Colors.amber);
        break;
      case "amberAccent":
        style = style.copyWith(color: Colors.amberAccent);
        break;
      case "black":
        style = style.copyWith(color: Colors.black);
        break;
      case "black12":
        style = style.copyWith(color: Colors.black12);
        break;
      case "black26":
        style = style.copyWith(color: Colors.black26);
        break;
      case "black38":
        style = style.copyWith(color: Colors.black38);
        break;
      case "black45":
        style = style.copyWith(color: Colors.black45);
        break;
      case "black54":
        style = style.copyWith(color: Colors.black54);
        break;
      case "black87":
        style = style.copyWith(color: Colors.black87);
        break;
      case "blue":
        style = style.copyWith(color: Colors.blue);
        break;
      case "blueAccent":
        style = style.copyWith(color: Colors.blueAccent);
        break;
      case "blueGrey":
        style = style.copyWith(color: Colors.blueGrey);
        break;
      case "brown":
        style = style.copyWith(color: Colors.brown);
        break;
      case "cyan":
        style = style.copyWith(color: Colors.cyan);
        break;
      case "cyanAccent":
        style = style.copyWith(color: Colors.cyanAccent);
        break;
      case "deepOrangeAccent":
        style = style.copyWith(color: Colors.deepOrangeAccent);
        break;
      case "deepPurple":
        style = style.copyWith(color: Colors.deepPurple);
        break;
      case "deepPurpleAccent":
        style = style.copyWith(color: Colors.deepPurpleAccent);
        break;
      case "green":
        style = style.copyWith(color: Colors.green);
        break;
      case "greenAccent":
        style = style.copyWith(color: Colors.greenAccent);
        break;
      case "grey":
        style = style.copyWith(color: Colors.grey);
        break;
      case "indigo":
        style = style.copyWith(color: Colors.indigo);
        break;
      case "indigoAccent":
        style = style.copyWith(color: Colors.indigoAccent);
        break;
      case "lightBlue":
        style = style.copyWith(color: Colors.lightBlue);
        break;
      case "lightBlueAccent":
        style = style.copyWith(color: Colors.lightBlueAccent);
        break;
      case "lightGreen":
        style = style.copyWith(color: Colors.lightGreen);
        break;
      case "lightGreenAccent":
        style = style.copyWith(color: Colors.lightGreenAccent);
        break;
      case "lime":
        style = style.copyWith(color: Colors.lime);
        break;
      case "limeAccent":
        style = style.copyWith(color: Colors.limeAccent);
        break;
      case "orange":
        style = style.copyWith(color: Colors.orange);
        break;
      case "orangeAccent":
        style = style.copyWith(color: Colors.orangeAccent);
        break;
      case "pink":
        style = style.copyWith(color: Colors.pink);
        break;
      case "pinkAccent":
        style = style.copyWith(color: Colors.pinkAccent);
        break;
      case "purple":
        style = style.copyWith(color: Colors.purple);
        break;
      case "purpleAccent":
        style = style.copyWith(color: Colors.purpleAccent);
        break;
      case "pink":
        style = style.copyWith(color: Colors.pink);
        break;
      case "red":
        style = style.copyWith(color: Colors.red);
        break;
      case "redAccent":
        style = style.copyWith(color: Colors.redAccent);
        break;
      case "teal":
        style = style.copyWith(color: Colors.teal);
        break;
      case "tealAccent":
        style = style.copyWith(color: Colors.tealAccent);
        break;
      case "transparent":
        style = style.copyWith(color: Colors.transparent);
        break;
      case "white":
        style = style.copyWith(color: Colors.white);
        break;
      case "yellow":
        style = style.copyWith(color: Colors.yellow);
        break;
      case "yellowAccent":
        style = style.copyWith(color: Colors.yellowAccent);
        break;
      default:
        style = style.copyWith(color: Color(int.parse(value)));
    }
    return style;
  }
}
