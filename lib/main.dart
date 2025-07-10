import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/register_screen.dart';
import 'application/providers/auth_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://etuphmrfytrdmnlsizgy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV0dXBobXJmeXRyZG1ubHNpemd5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTIwMzk0MzksImV4cCI6MjA2NzYxNTQzOX0.Cz2VcS_dvW4LaCPsOHJLZl6KZgfHsWIbnbOOGPmtEDo',
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bitácora Viajera',
      theme: ThemeData(primarySwatch: Colors.indigo),
      // rutas estáticas
      routes: {
        '/register': (_) => const RegisterScreen(),
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const HomeScreen(),
      },
      // pantalla principal según sesión activa
      home: auth.when(
        data: (session) {
          final isLoggedIn = session.session != null;
          return isLoggedIn ? const HomeScreen() : const LoginScreen();
        },
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (err, _) => Scaffold(body: Center(child: Text('Error: $err'))),
      ),
    );
  }
}
