import 'dart:async';

import 'package:rxdart/rxdart.dart';

class PrefsBlocError extends Error {
  final String message;

  PrefsBlocError(this.message);
}

class PrefsState {
  final bool showWebView;

  const PrefsState(this.showWebView);
}

class PrefsBloc {
  final _currentPrefs = BehaviorSubject<PrefsState>(
    seedValue: PrefsState(true),
  );

  final _showWebViewPref = StreamController<bool>();

  PrefsBloc() {}

  Stream<PrefsState> get currentPrefs => _currentPrefs.stream;

  Sink<bool> get showWebViewPref => _showWebViewPref.sink;

  void close() {
    _showWebViewPref.close();
    _currentPrefs.close();
  }
}
