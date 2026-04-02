import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:crypto/crypto.dart';
// import 'package:basic_utils/basic_utils.dart';
// import 'package:asn1lib/asn1lib.dart';

import 'package:wallet_app/core/utils/app_logger.dart';

class TlsPinning {
  // Your SPKI / SHA-256 pin(s)
  static const List<String> trustedPins = [
    "drJ7gKWAJ9w88dpo2sFwEO2TmX0LYD4vrb6FASSTtac=",
  ];
String extractSpkiHash(List<int> derBytes) {
    // Convert List<int> to Uint8List to satisfy ASN1Parser requirements
    final uint8Bytes = Uint8List.fromList(derBytes);

    final parser = ASN1Parser(uint8Bytes);
    final signedCert = parser.nextObject() as ASN1Sequence;

    // Elements[0] is the tbsCertificate
    final cert = signedCert.elements[0] as ASN1Sequence;

    // SubjectPublicKeyInfo is typically at index 6
    final pubKeyElement = cert.elements[6] as ASN1Sequence;

    // Hash the entire SPKI element
    final hash = sha256.convert(pubKeyElement.contentBytes()).bytes;
    return base64.encode(hash);
  }

  static void debugCertificate(X509Certificate cert) {
    AppLogger.info("📜 Certificate DER length: ${cert.der.length}");
    AppLogger.info("📜 Certificate valid from: ${cert.startValidity}");
    AppLogger.info("📜 Certificate valid to: ${cert.endValidity}");
    AppLogger.info("📜 Certificate issuer: ${cert.issuer}");
    AppLogger.info("📜 Certificate subject: ${cert.subject}");
    AppLogger.info("📜 Certificate SHA1: ${cert.sha1}");
    AppLogger.info("📜 Certificate PEM: ${cert.pem}");
  }

  /// Convert certificate → SHA-256 fingerprint
  static String _fingerprint(X509Certificate cert) {
    final bytes = cert.der; // raw certificate
    final digest = sha256.convert(bytes);
    AppLogger.info("🔐 Server Certificate SHA-256: $digest");
    return base64Encode(digest.bytes);
  }

  /// Validate certificate
  static bool verify(X509Certificate cert) {
    debugCertificate(cert);
    final pin = _fingerprint(cert);
    AppLogger.info("🔐 Server Pin: $pin");
    final isValid = trustedPins.contains(pin);
    AppLogger.debug(isValid ? "✅ PIN MATCH" : "❌ PIN MISMATCH");
    return isValid;
  }
}
