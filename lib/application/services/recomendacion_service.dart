import 'package:supabase_flutter/supabase_flutter.dart';
import '../../model/recomendacion.dart';

class RecomendacionService {
  final _supabase = Supabase.instance.client;

  Future<List<Recomendacion>> obtenerRecomendacionesUsuario(
    String userId,
  ) async {
    final response = await _supabase
        .from('recomendaciones_usuario')
        .select()
        .eq('user_id', userId)
        .order('fecha_publicacion', ascending: false);

    return (response as List)
        .map((item) => Recomendacion.fromMap(item))
        .toList();
  }

  Future<void> crearRecomendacion(Recomendacion recomendacion) async {
    await _supabase
        .from('recomendaciones_usuario')
        .insert(recomendacion.toMap());
  }

  Future<List<Recomendacion>> obtenerRecomendacionesDeOtrosUsuarios(
    String userId,
  ) async {
    final response = await _supabase
        .from('recomendaciones_usuario')
        .select()
        .neq('user_id', userId) // distinto al usuario actual
        .order('fecha_publicacion', ascending: false);

    return (response as List)
        .map((item) => Recomendacion.fromMap(item))
        .toList();
  }

  Future<void> guardarFavorito(String userId, String recomendacionId) async {
    await _supabase.from('favoritos').insert({
      'user_id': userId,
      'recomendacion_id': recomendacionId,
    });
  }

  Future<List<String>> obtenerIdsFavoritosUsuario(String userId) async {
    final response = await _supabase
        .from('favoritos')
        .select('recomendacion_id')
        .eq('user_id', userId);

    return (response as List)
        .map((item) => item['recomendacion_id'] as String)
        .toList();
  }

  Future<void> eliminarFavorito(String userId, String recomendacionId) async {
    await _supabase.from('favoritos').delete().match({
      'user_id': userId,
      'recomendacion_id': recomendacionId,
    });
  }
}
