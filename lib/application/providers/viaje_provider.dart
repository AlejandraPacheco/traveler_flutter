import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database_helper.dart';
import '../../model/viaje.dart';
import 'auth_provider.dart';

final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider).value;
  return authState?.session?.user.id;
});

final viajeListProvider = FutureProvider<List<Viaje>>((ref) async {
  final db = DatabaseHelper();
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return [];
  return db.obtenerViajesPorUsuario(userId);
});

final selectedViajeProvider = StateProvider<Viaje?>((ref) => null);
