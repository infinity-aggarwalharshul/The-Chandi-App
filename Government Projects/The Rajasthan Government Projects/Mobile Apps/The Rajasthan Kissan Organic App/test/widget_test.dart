import 'package:flutter_test/flutter_test.dart';
import 'package:raj_kissan_organic/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Since it uses Provider, we might need to handle that, but here main() already does it.
    await tester.pumpWidget(const RajKissanApp());
  });
}
