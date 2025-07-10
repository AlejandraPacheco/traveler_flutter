import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/recomendacion_service.dart';
import '../../model/recomendacion.dart';
import 'auth_provider.dart';

final recomendacionServiceProvider = Provider((ref) => RecomendacionService());

final recomendacionesUsuarioProvider = FutureProvider<List<Recomendacion>>((
  ref,
) async {
  final service = ref.read(recomendacionServiceProvider);
  final userId = ref.watch(currentUserIdProvider);

  if (userId == null) return [];

  return service.obtenerRecomendacionesUsuario(userId);
});
