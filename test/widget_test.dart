import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zerodoc/app.dart';

void main() {
  testWidgets('ZeroDocApp renders without crashing', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: ZeroDocApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
  });
}
