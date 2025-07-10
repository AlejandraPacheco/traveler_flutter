import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/recomendacion_provider.dart';
import '../../application/providers/auth_provider.dart';
import 'detalle_recomendacion_screen.dart';

class ExplorarRecomendacionesScreen extends ConsumerStatefulWidget {
  const ExplorarRecomendacionesScreen({super.key});

  @override
  ConsumerState<ExplorarRecomendacionesScreen> createState() =>
      _ExplorarRecomendacionesScreenState();
}

class _ExplorarRecomendacionesScreenState
    extends ConsumerState<ExplorarRecomendacionesScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Invalida y recarga datos cada vez que entra a esta pantalla
    ref.invalidate(recomendacionesPublicasProvider);
    ref.invalidate(favoritosUsuarioProvider);
  }

  @override
  Widget build(BuildContext context) {
    final recomendacionesAsync = ref.watch(recomendacionesPublicasProvider);
    final favoritosAsync = ref.watch(favoritosUsuarioProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Explorar recomendaciones')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF64B6FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: recomendacionesAsync.when(
          data: (recomendaciones) {
            if (recomendaciones.isEmpty) {
              return const Center(
                child: Text(
                  'No hay recomendaciones disponibles.',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            }

            return favoritosAsync.when(
              data: (favoritos) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: recomendaciones.length,
                  itemBuilder: (context, index) {
                    final rec = recomendaciones[index];
                    final yaEsFavorito = favoritos.contains(rec.id);

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 0,
                      ),
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
                        trailing: IconButton(
                          icon: Icon(
                            yaEsFavorito
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: yaEsFavorito ? Colors.red : Colors.grey[700],
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetalleRecomendacionScreen(
                                recomendacion: rec,
                              ),
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
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
          error: (e, _) => Center(
            child: Text(
              'Error: $e',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
