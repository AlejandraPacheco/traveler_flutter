import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/recomendacion_provider.dart';
import '../../application/providers/auth_provider.dart';
import 'detalle_recomendacion_screen.dart';

class FavoritosScreen extends ConsumerStatefulWidget {
  const FavoritosScreen({super.key});

  @override
  ConsumerState<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends ConsumerState<FavoritosScreen> {
  @override
  void initState() {
    super.initState();
    // Invalida el provider para forzar nueva carga desde Supabase
    Future.microtask(() {
      ref.invalidate(favoritosRecomendacionesProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritosAsync = ref.watch(favoritosRecomendacionesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Favoritos')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF64B6FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: favoritosAsync.when(
          data: (favoritos) {
            if (favoritos.isEmpty) {
              return const Center(
                child: Text(
                  'Aún no tienes recomendaciones en favoritos.',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: favoritos.length,
              itemBuilder: (context, index) {
                final rec = favoritos[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white.withOpacity(0.9),
                  child: ListTile(
                    title: Text(
                      '${rec.lugarRecomendado} - ${rec.tipo}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${rec.ciudad}, ${rec.pais}\n${rec.comentario ?? ''}',
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (rec.puntuacion != null)
                          Chip(
                            label: Text('⭐ ${rec.puntuacion}'),
                            backgroundColor: Colors.amber.shade100,
                          ),
                        IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () async {
                            final userId = ref
                                .read(authStateProvider)
                                .value
                                ?.session
                                ?.user
                                .id;

                            if (userId != null) {
                              await ref
                                  .read(recomendacionServiceProvider)
                                  .eliminarFavorito(userId, rec.id);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Eliminado de favoritos'),
                                ),
                              );

                              ref.invalidate(favoritosRecomendacionesProvider);
                              ref.invalidate(favoritosUsuarioProvider);
                            }
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DetalleRecomendacionScreen(recomendacion: rec),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
          error: (e, _) => Center(
            child: Text(
              'Error al cargar favoritos: $e',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
