library flutter_text_styled;

import 'package:flutter/widgets.dart';

class TextStyled {
  String _remainingText;
  int _startBoldIndex;
  String _normalText;
  int _endBoldIndex;
  String _boldText;

  static const BOLD_START_TAG = '[b]';
  static const BOLD_END_TAG = '[/b]';
  static const REPLACEMENT_EMPTY_TAG = "";

  List<Text> getStyledTextWidgets(String text) {
    List<Text> resultWidgets = List();
    _remainingText = text;
    while (_remainingText != null && _remainingText.isNotEmpty) {
      _findBoldTextStart();

      _findBoldTextEnd();

      _addNormalTextWidget(resultWidgets);
      _addBoldTextWidget(resultWidgets);
    }
    return resultWidgets;
  }

  void _findBoldTextStart() {
    _startBoldIndex = _remainingText.indexOf(BOLD_START_TAG);
    if (_startBoldIndex < 0) {
      _startBoldIndex = _remainingText.length;
    }
    _normalText = _remainingText.substring(0, _startBoldIndex);
    _remainingText =
        _remainingText.substring(_startBoldIndex, _remainingText.length);
  }

  void _findBoldTextEnd() {
    _endBoldIndex = _remainingText.indexOf(BOLD_END_TAG);

    if (_endBoldIndex > 0) {
      _boldText = _remainingText.substring(0, _endBoldIndex);
      _remainingText =
          _remainingText.substring(_endBoldIndex, _remainingText.length);
    }
  }

  void _addNormalTextWidget(List<Text> resultWidgets) {
    if (_normalText != null && _normalText.isNotEmpty) {
      _normalText =
          _normalText.replaceAll(BOLD_START_TAG, REPLACEMENT_EMPTY_TAG);
      _normalText = _normalText.replaceAll(BOLD_END_TAG, REPLACEMENT_EMPTY_TAG);
      resultWidgets.add(Text(_normalText));
      _normalText = null;
    }
  }

  void _addBoldTextWidget(List<Text> resultWidgets) {
    if (_boldText != null && _boldText.isNotEmpty) {
      _boldText = _boldText.replaceAll(BOLD_START_TAG, REPLACEMENT_EMPTY_TAG);
      _boldText = _boldText.replaceAll(BOLD_END_TAG, REPLACEMENT_EMPTY_TAG);
      resultWidgets
          .add(Text(_boldText, style: TextStyle(fontWeight: FontWeight.bold)));
      _boldText = null;
    }
  }
}
