import 'package:flutter_test/flutter_test.dart';
import 'package:video_call_demo/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const VCallApp());
    expect(find.text('VCall'), findsOneWidget);
    // Let splash finish and navigate to login
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();
    expect(find.text('Welcome back!'), findsOneWidget);
  });
}
