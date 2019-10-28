import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:pdfium/src/structs.dart';

import 'exceptions.dart';

// Function: FPDF_InitLibraryWithConfig
//          Initialize the FPDFSDK library
// Parameters:
//          config - configuration information as above.
// Return value:
//          None.
// Comments:
//          You have to call this function before you can call any PDF
//          processing functions.
typedef Void FPDF_InitLibraryWithConfig(Pointer<FPDF_LIBRARY_CONFIG> config);
typedef void InitLibraryWithConfig(Pointer<FPDF_LIBRARY_CONFIG> config);

InitLibraryWithConfig fInitLibraryWithConfig;

void initLibrary({Pointer<FPDF_LIBRARY_CONFIG> config}) {
  fInitLibraryWithConfig(config ?? nullptr);
}

// Function: FPDF_CloseDocument
//          Close a loaded PDF document.
// Parameters:
//          document    -   Handle to the loaded document.
// Return value:
//          None.
typedef Void FPDF_DestroyLibrary();
typedef void DestroyLibrary();

DestroyLibrary fDestroyLibrary;

/// Function: FPDF_GetLastError
///          Get last error code when a function fails.
/// Parameters:
///          None.
/// Return value:
///          A 32-bit integer indicating error code as defined above.
/// Comments:
///          If the previous SDK call succeeded, the return value of this
///          function is not defined.
typedef Uint64 FPDF_GetLastError();
typedef int GetLastError();

GetLastError fGetLastError;

///PdfiumException getLastError() {
///  switch (nGetLastError()) {
///    case FPDF_ERR_SUCCESS:
///      fprintf(stderr, "Success");
///      break;
///    case FPDF_ERR_UNKNOWN:
///      fprintf(stderr, "Unknown error");
///      break;
///    case FPDF_ERR_FILE:
///      fprintf(stderr, "File not found or could not be opened");
///      break;
///    case FPDF_ERR_FORMAT:
///      fprintf(stderr, "File not in PDF format or corrupted");
///      break;
///    case FPDF_ERR_PASSWORD:
///
///      fprintf(stderr, "Password required or incorrect password");
///      break;
///    case FPDF_ERR_SECURITY:
///      fprintf(stderr, "Unsupported security scheme");
///      break;
///    case FPDF_ERR_PAGE:
///      fprintf(stderr, "Page not found or content error");
///      break;
///    default:
///      fprintf(stderr, "Unknown error %ld", err);
///  }
///}

// Function: FPDF_LoadDocument
//          Open and load a PDF document.
// Parameters:
//          file_path -  Path to the PDF file (including extension).
//          password  -  A string used as the password for the PDF file.
//                       If no password is needed, empty or NULL can be used.
//                       See comments below regarding the encoding.
// Return value:
//          A handle to the loaded document, or NULL on failure.
// Comments:
//          Loaded document can be closed by FPDF_CloseDocument().
//          If this function fails, you can use FPDF_GetLastError() to retrieve
//          the reason why it failed.
//
//          The encoding for |password| can be either UTF-8 or Latin-1. PDFs,
//          depending on the security handler revision, will only accept one or
//          the other encoding. If |password|'s encoding and the PDF's expected
//          encoding do not match, FPDF_LoadDocument() will automatically
//          convert |password| to the other encoding.
typedef Pointer<FPDF_DOCUMENT> FPDF_LoadDocument(
  Pointer<Utf8> filePath,
  Pointer<Utf8> password,
);

FPDF_LoadDocument fLoadDocument;

Pointer<FPDF_DOCUMENT> loadDocument(String filePath, {String password}) {
  var doc = fLoadDocument(Utf8.toUtf8(filePath), Utf8.toUtf8(password ?? ""));
  if (doc == nullptr) {
    var err = fGetLastError();
    throw PdfiumException.fromErrorCode(err);
  }
  return doc;
}

/// Function: FPDF_CloseDocument
///          Close a loaded PDF document.
/// Parameters:
///          document    -   Handle to the loaded document.
/// Return value:
///          None.
typedef Void FPDF_CloseDocument(Pointer<FPDF_DOCUMENT> document);
typedef void CloseDocument(Pointer<FPDF_DOCUMENT> document);

CloseDocument fCloseDocument;

/// Function: FPDF_LoadPage
///          Load a page inside the document.
/// Parameters:
///          document    -   Handle to document. Returned by FPDF_LoadDocument
///          page_index  -   Index number of the page. 0 for the first page.
/// Return value:
///          A handle to the loaded page, or NULL if page load fails.
/// Comments:
///          The loaded page can be rendered to devices using FPDF_RenderPage.
///          The loaded page can be closed using FPDF_ClosePage.
typedef Pointer<FPDF_PAGE> FPDF_LoadPage(
  Pointer<FPDF_DOCUMENT> document,
  Int32 pageIndex,
);
typedef Pointer<FPDF_PAGE> LoadPage(
  Pointer<FPDF_DOCUMENT> document,
  int pageIndex,
);

LoadPage fLoadPage;

/// Function: FPDF_GetPageCount
///          Get total number of pages in the document.
/// Parameters:
///          document    -   Handle to document. Returned by FPDF_LoadDocument.
/// Return value:
///          Total number of pages in the document.
typedef Int32 FPDF_GetPageCount(Pointer<FPDF_DOCUMENT> document);
typedef int GetPageCount(Pointer<FPDF_DOCUMENT> document);

GetPageCount fGetPageCount;

// Function: FPDFBitmap_Create
//          Create a device independent bitmap (FXDIB).
// Parameters:
//          width       -   The number of pixels in width for the bitmap.
//                          Must be greater than 0.
//          height      -   The number of pixels in height for the bitmap.
//                          Must be greater than 0.
//          alpha       -   A flag indicating whether the alpha channel is used.
//                          Non-zero for using alpha, zero for not using.
// Return value:
//          The created bitmap handle, or NULL if a parameter error or out of
//          memory.
// Comments:
//          The bitmap always uses 4 bytes per pixel. The first byte is always
//          double word aligned.
//
//          The byte order is BGRx (the last byte unused if no alpha channel) or
//          BGRA.
//
//          The pixels in a horizontal line are stored side by side, with the
//          left most pixel stored first (with lower memory address).
//          Each line uses width * 4 bytes.
//
//          Lines are stored one after another, with the top most line stored
//          first. There is no gap between adjacent lines.
//
//          This function allocates enough memory for holding all pixels in the
//          bitmap, but it doesn't initialize the buffer. Applications can use
//          FPDFBitmap_FillRect() to fill the bitmap using any color. If the OS
//          allows it, this function can allocate up to 4 GB of memory.
typedef Pointer<FPDF_BITMAP> FPDFBitmap_Create(
  Int32 width,
  Int32 height,
  Int32 alpha,
);
typedef Pointer<FPDF_BITMAP> BitmapCreate(
  int width,
  int height,
  int alpha,
);

BitmapCreate fBitmapCreate;

// Function: FPDFBitmap_FillRect
//          Fill a rectangle in a bitmap.
// Parameters:
//          bitmap      -   The handle to the bitmap. Returned by
//                          FPDFBitmap_Create.
//          left        -   The left position. Starting from 0 at the
//                          left-most pixel.
//          top         -   The top position. Starting from 0 at the
//                          top-most line.
//          width       -   Width in pixels to be filled.
//          height      -   Height in pixels to be filled.
//          color       -   A 32-bit value specifing the color, in 8888 ARGB
//                          format.
// Return value:
//          None.
// Comments:
//          This function sets the color and (optionally) alpha value in the
//          specified region of the bitmap.
//
//          NOTE: If the alpha channel is used, this function does NOT
//          composite the background with the source color, instead the
//          background will be replaced by the source color and the alpha.
//
//          If the alpha channel is not used, the alpha parameter is ignored.
typedef Void FPDFBitmap_FillRect(
  Pointer<FPDF_BITMAP> bitmap,
  Int32 left,
  Int32 top,
  Int32 width,
  Int32 height,
  Uint32 color,
);
typedef void BitmapFillRect(
  Pointer<FPDF_BITMAP> bitmap,
  int left,
  int top,
  int width,
  int height,
  int color,
);

BitmapFillRect fBitmapFillRect;

// Function: FPDF_RenderPageBitmap
//          Render contents of a page to a device independent bitmap.
// Parameters:
//          bitmap      -   Handle to the device independent bitmap (as the
//                          output buffer). The bitmap handle can be created
//                          by FPDFBitmap_Create or retrieved from an image
//                          object by FPDFImageObj_GetBitmap.
//          page        -   Handle to the page. Returned by FPDF_LoadPage
//          start_x     -   Left pixel position of the display area in
//                          bitmap coordinates.
//          start_y     -   Top pixel position of the display area in bitmap
//                          coordinates.
//          size_x      -   Horizontal size (in pixels) for displaying the page.
//          size_y      -   Vertical size (in pixels) for displaying the page.
//          rotate      -   Page orientation:
//                            0 (normal)
//                            1 (rotated 90 degrees clockwise)
//                            2 (rotated 180 degrees)
//                            3 (rotated 90 degrees counter-clockwise)
//          flags       -   0 for normal display, or combination of the Page
//                          Rendering flags defined above. With the FPDF_ANNOT
//                          flag, it renders all annotations that do not require
//                          user-interaction, which are all annotations except
//                          widget and popup annotations.
// Return value:
//          None.
typedef Void FPDF_RenderPageBitmap(
  Pointer<FPDF_BITMAP> bitmap,
  Pointer<FPDF_PAGE> page,
  Int32 start_x,
  Int32 start_y,
  Int32 size_x,
  Int32 size_y,
  Int32 rotate,
  Int32 flags,
);
typedef void RenderPageBitmap(
  Pointer<FPDF_BITMAP> bitmap,
  Pointer<FPDF_PAGE> page,
  int start_x,
  int start_y,
  int size_x,
  int size_y,
  int rotate,
  int flags,
);

RenderPageBitmap fRenderPageBitmap;

// Function: FPDF_GetPageWidth
//          Get page width.
// Parameters:
//          page        -   Handle to the page. Returned by FPDF_LoadPage.
// Return value:
//          Page width (excluding non-displayable area) measured in points.
//          One point is 1/72 inch (around 0.3528 mm).
typedef Double FPDF_GetPageWidth(Pointer<FPDF_PAGE> page);
typedef double GetPageWidth(Pointer<FPDF_PAGE> page);

GetPageWidth fGetPageWidth;

// Function: FPDF_GetPageHeight
//          Get page height.
// Parameters:
//          page        -   Handle to the page. Returned by FPDF_LoadPage.
// Return value:
//          Page height (excluding non-displayable area) measured in points.
//          One point is 1/72 inch (around 0.3528 mm)
typedef Double FPDF_GetPageHeight(Pointer<FPDF_PAGE> page);
typedef double GetPageHeight(Pointer<FPDF_PAGE> page);

GetPageHeight fGetPageHeight;

// Function: FPDFBitmap_GetBuffer
//          Get data buffer of a bitmap.
// Parameters:
//          bitmap      -   Handle to the bitmap. Returned by FPDFBitmap_Create
//                          or FPDFImageObj_GetBitmap.
// Return value:
//          The pointer to the first byte of the bitmap buffer.
// Comments:
//          The stride may be more than width * number of bytes per pixel
//
//          Applications can use this function to get the bitmap buffer pointer,
//          then manipulate any color and/or alpha values for any pixels in the
//          bitmap.
//
//          The data is in BGRA format. Where the A maybe unused if alpha was
//          not specified.
typedef Pointer<Uint32> FPDFBitmap_GetBuffer(Pointer<FPDF_BITMAP> bitmap);
typedef Pointer<Uint32> BitmapGetBuffer(Pointer<FPDF_BITMAP> bitmap);

BitmapGetBuffer fBitmapGetBuffer;
