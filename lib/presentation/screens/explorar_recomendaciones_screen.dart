import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/recomendacion_provider.dart';
import '../../application/providers/auth_provider.dart';

class ExplorarRecomendacionesScreen extends ConsumerWidget {
  const ExplorarRecomendacionesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recomendacionesAsync = ref.watch(recomendacionesPublicasProvider);
    final favoritosAsync = ref.watch(favoritosUsuarioProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Explorar recomendaciones')),
      body: recomendacionesAsync.when(
        data: (recomendaciones) {
          if (recomendaciones.isEmpty) {
            return const Center(
              child: Text('No hay recomendaciones disponibles.'),
            );
          }

          return favoritosAsync.when(
            data: (favoritos) {
              return ListView.builder(
                itemCount: recomendaciones.length,
                itemBuilder: (context, index) {
                  final rec = recomendaciones[index];
                  final yaEsFavorito = favoritos.contains(rec.id);

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text('${rec.lugarRecomendado} - ${rec.tipo}'),
                      subtitle: Text(
                        '${rec.ciudad}, ${rec.pais}\n${rec.comentario ?? ''}',
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: Icon(
                          yaEsFavorito ? Icons.favorite : Icons.favorite_border,
                          color: yaEsFavorito ? Colors.red : null,
                        ),
                        onPressed: () async {
                          final userId = ref
                              .read(authStateProvider)
                              .value
                              ?.session
                              ?.user
                              .id;
                          if (userId != null) {
                            final service = ref.read(
                              recomendacionServiceProvider,
                            );

                            if (yaEsFavorito) {
                              await service.eliminarFavorito(userId, rec.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Eliminado de favoritos'),
                                ),
                              );
                            } else {
                              await service.guardarFavorito(userId, rec.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Guardado en favoritos'),
                                ),
                              );
                            }

                            ref.invalidate(favoritosUsuarioProvider);
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Center(child: Text('Error al cargar favoritos: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
