library flutter_text_styled;

import 'dart:collection';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

enum TAGS { BOLD, ITALIC, UNDERLINE }

RegExp _anyTagRegExp = RegExp(r'\[[\/]{0,1}[b|i|u]\]');
RegExp _openTagRegExp = RegExp(r'\[[b|i|u]\]');
RegExp _closeTagRegExp = RegExp(r'\[\/[b|i|u]\]');

class TextStyled {
  String _remainingText;
  int _startStyledTextIndex;
  String _normalText;
  int _endStyledTextIndex;
  String _styledText;

  LinkedHashSet<TAGS> _styledTextTags = LinkedHashSet<TAGS>();

  static const BOLD_START_TAG = '[b]';
  static const BOLD_END_TAG = '[/b]';

  static const ITALIC_START_TAG = '[i]';
  static const ITALIC_END_TAG = '[/i]';

  static const UNDERLINE_START_TAG = '[u]';
  static const UNDERLINE_END_TAG = '[/u]';

  static const REPLACEMENT_EMPTY_TAG = "";

  List<Text> getStyledTextWidgets(String text) {
    List<Text> resultWidgets = List();
    _remainingText = text;
    while (_remainingText != null && _remainingText.isNotEmpty) {
      int openTagIndex = _remainingText.indexOf(_openTagRegExp);
      int closeTagIndex = _remainingText.indexOf(_closeTagRegExp);

      _handleTagOnFirstIndex(openTagIndex, closeTagIndex);

      _handleNextTag(openTagIndex, closeTagIndex, resultWidgets);
    }
    return resultWidgets;
  }

  void _handleNextTag(
      int openTagIndex, int closeTagIndex, List<Text> resultWidgets) {
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
      _remainingText.replaceFirst(_openTagRegExp, REPLACEMENT_EMPTY_TAG);
    }
    if (closeTagIndex == 0) {
      _removeStyledTag(closeTagIndex);
      _remainingText.replaceFirst(_closeTagRegExp, REPLACEMENT_EMPTY_TAG);
    }
  }

  void _removeStyledTag(int tagIndex) {
    if (_remainingText.indexOf(BOLD_END_TAG) == tagIndex) {
      _styledTextTags.remove(TAGS.BOLD);
    } else if (_remainingText.indexOf(ITALIC_END_TAG) == tagIndex) {
      _styledTextTags.remove(TAGS.ITALIC);
    } else if (_remainingText.indexOf(UNDERLINE_END_TAG) == tagIndex) {
      _styledTextTags.remove(TAGS.UNDERLINE);
    }
  }

  void _addStyledTag(int tagIndex) {
    if (_remainingText.indexOf(BOLD_START_TAG) == tagIndex) {
      _styledTextTags.add(TAGS.BOLD);
    } else if (_remainingText.indexOf(ITALIC_START_TAG) == tagIndex) {
      _styledTextTags.add(TAGS.ITALIC);
    } else if (_remainingText.indexOf(UNDERLINE_START_TAG) == tagIndex) {
      _styledTextTags.add(TAGS.UNDERLINE);
    }

    if (tagIndex < 0) {
      _startStyledTextIndex = _remainingText.length;
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

    _normalText = _remainingText.substring(0, _startStyledTextIndex);
    _remainingText =
        _remainingText.substring(_startStyledTextIndex, _remainingText.length);
    _remainingText =
        _remainingText.replaceFirst(_anyTagRegExp, REPLACEMENT_EMPTY_TAG);
  }

  void _findEndStyledTextIndex(
      List<Text> resultWidgets, int openTagIndex, int closeTagIndex) {
    int openTagIndex = _remainingText.indexOf(_openTagRegExp);
    int closeTagIndex = _remainingText.indexOf(_closeTagRegExp);

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

  void _generateTextWidgets(List<Text> resultWidgets) {
    _styledText = _remainingText.substring(0, _endStyledTextIndex);
    _remainingText =
        _remainingText.substring(_endStyledTextIndex, _remainingText.length);
    _remainingText.replaceFirst(_anyTagRegExp, REPLACEMENT_EMPTY_TAG);
    _clearTagsFromText();
    _addNormalTextWidget(resultWidgets);
    _addStyledTextWidget(resultWidgets);
  }

  void _addNormalTextWidget(List<Text> resultWidgets) {
    if (_normalText != null && _normalText.isNotEmpty) {
      resultWidgets.add(Text(_normalText));
      _normalText = null;
    }
  }

  void _addStyledTextWidget(List<Text> resultWidgets) {
    if (_styledText != null && _styledText.isNotEmpty) {
      resultWidgets.add(Text(_styledText, style: _generateTextStyle()));
      _styledText = null;
    }
  }

  void _clearTagsFromText() {
    _styledText.replaceAll(_anyTagRegExp, REPLACEMENT_EMPTY_TAG);
    _normalText.replaceAll(_anyTagRegExp, REPLACEMENT_EMPTY_TAG);
  }

  TextStyle _generateTextStyle() {
    TextStyle style = TextStyle();
    _styledTextTags.forEach((tag) {
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
      }
    });
    return style;
  }
}
