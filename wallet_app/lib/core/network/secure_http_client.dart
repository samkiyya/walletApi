import 'dart:io';
import 'tls_pinning.dart';

HttpClient createSecureHttpClient() {
  final context = SecurityContext(withTrustedRoots: true);

  return HttpClient(context: context)
    ..badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      // 🔐 ONLY allow pinned certs
      return TlsPinning.verify(cert);
    }
    ..connectionTimeout = const Duration(seconds: 30);
}