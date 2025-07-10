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
}
