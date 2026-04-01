import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

class TlsPinning {
  // Your SPKI / SHA-256 pin(s)
  static const List<String> trustedPins = [
    "T4eoRdbfIYF3G9IOGamqR3Vgye2bNLHQTSCOY8u3y5w="
  ];

  /// Convert certificate → SHA-256 fingerprint
  static String _fingerprint(X509Certificate cert) {
    final bytes = cert.der; // raw certificate
    final digest = sha256.convert(bytes);
    return base64Encode(digest.bytes);
  }

  /// Validate certificate
  static bool verify(X509Certificate cert) {
    final pin = _fingerprint(cert);
    return trustedPins.contains(pin);
  }
}