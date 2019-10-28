class PdfiumException implements Exception {
  int errorCode;

  PdfiumException();

  factory PdfiumException.fromErrorCode(int errorCode) {
    var e = FileException();
    e.errorCode = errorCode;
    return e;
  }

  @override
  String toString() {
    return "${runtimeType}: ${errorCode}";
  }
}

class UnknownException extends PdfiumException {}

class FileException extends PdfiumException {}

class FormatException extends PdfiumException {}

class PasswordException extends PdfiumException {}

class SecurityException extends PdfiumException {}

class PageException extends PdfiumException {}
