// ignore_for_file: avoid_print

abstract class ChessPlatformLogger {
  void messageIn(String message);
  void messageOut(String message);
  void error(String message);
}

class PrintLogger implements ChessPlatformLogger {
  @override
  void error(String message) {
    print("ERROR: $message");
  }

  @override
  void messageIn(String message) {
    print("IN: $message");
  }

  @override
  void messageOut(String message) {
    print("OUT: $message");
  }
}

class DummyLogger implements ChessPlatformLogger {
  const DummyLogger();

  @override
  void error(String message) {}

  @override
  void messageIn(String message) {}

  @override
  void messageOut(String message) {}
}