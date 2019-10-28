import 'dart:ffi';

import 'package:ffi/ffi.dart';

class FPDF_LIBRARY_CONFIG extends Struct {
  // Version number of the interface. Currently must be 2.
  @Int32()
  int version;

  // Array of paths to scan in place of the defaults when using built-in
  // FXGE font loading code. The array is terminated by a NULL pointer.
  // The Array may be NULL itself to use the default paths. May be ignored
  // entirely depending upon the platform.
  Pointer<Pointer<Utf8>> userFontPaths;

  // Version 2.

  // pointer to the v8::Isolate to use, or NULL to force PDFium to create one.
  Pointer<Void> isolate;

  // The embedder data slot to use in the v8::Isolate to store PDFium's
  // per-isolate data. The value needs to be between 0 and
  // v8::Internals::kNumIsolateDataLots (exclusive). Note that 0 is fine
  // for most embedders.
  @Int32()
  int v8EmbedderSlot;

  factory FPDF_LIBRARY_CONFIG.allocate({
    int version = 2,
    List<String> userFontPaths,
    Pointer<void> isolate,
    int v8EmbedderSlot = 0,
  }) {
    Pointer<Pointer<Utf8>> userFontPathsPtr;
    if (userFontPaths == null) {
      userFontPathsPtr = nullptr;
    } else {
      userFontPathsPtr = allocate<Pointer<Utf8>>();
      for (var i = 0; i < userFontPaths.length; i++) {
        userFontPathsPtr[i] = Utf8.toUtf8(userFontPaths[i]);
      }
    }

    return allocate<FPDF_LIBRARY_CONFIG>().ref
      ..version = version
      ..userFontPaths = userFontPathsPtr
      ..isolate = isolate ?? nullptr
      ..v8EmbedderSlot = v8EmbedderSlot;
  }
}

class FPDF_DOCUMENT extends Struct {}

class FPDF_PAGE extends Struct {}

class FPDF_BITMAP extends Struct {}
