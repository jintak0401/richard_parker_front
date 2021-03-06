import 'package:flutter/material.dart';

import 'common_size.dart';

// auth 관련 페이지의 TextFromField 의 decoration 에서 사용
InputDecoration textInputDeco(String hint) {
  return InputDecoration(
    enabledBorder: _activeInputBorder(),
    focusedBorder: _activeInputBorder(),
    errorBorder: _errorInputBorder(),
    focusedErrorBorder: _errorInputBorder(),
    hintText: hint,
    filled: true,
    fillColor: Colors.grey[100],
  );
}

OutlineInputBorder _activeInputBorder() {
  return OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey[300],
    ),
    borderRadius: BorderRadius.circular(common_s_gap),
  );
}

OutlineInputBorder _errorInputBorder() {
  return OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.redAccent,
    ),
    borderRadius: BorderRadius.circular(common_s_gap),
  );
}
