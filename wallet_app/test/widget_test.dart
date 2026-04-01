import 'package:flutter_test/flutter_test.dart';

import 'package:wallet_app/app/app.dart';

void main() {
  testWidgets('App renders without errors', (WidgetTester tester) async {
    await tester.pumpWidget(WalletApp());
  });
}
