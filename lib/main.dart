import 'core/common/exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService().init();
  setupDependencyInjection();
  runApp(
    const App(),
  );
}
