export '_connection_unsupported.dart'
    if (dart.library.ffi) '_connection_native.dart'
    if (dart.library.js_interop) '_connection_web.dart';
