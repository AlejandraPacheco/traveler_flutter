import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<AuthResponse> signUp(String email, String password) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );

    final userId = response.user?.id;
    if (userId == null) {
      throw Exception('No se pudo obtener el ID del usuario');
    }

    // Insertar usuario también en la tabla "usuarios"
    await _client.from('usuarios').insert({
      'id': userId,
      'nombre': 'Usuario sin nombre', // Puedes actualizarlo más adelante
      'pais': null,
      'avatar_url': null,
      // 'creado_en' se llenará automáticamente por la base de datos
    });

    return response;
  }

  Future<AuthResponse> signIn(String email, String password) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;
}
