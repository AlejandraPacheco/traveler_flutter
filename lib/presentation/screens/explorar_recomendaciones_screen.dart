import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/recomendacion_provider.dart';

class ExplorarRecomendacionesScreen extends ConsumerWidget {
  const ExplorarRecomendacionesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recomendacionesAsync = ref.watch(recomendacionesPublicasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Explorar recomendaciones')),
      body: recomendacionesAsync.when(
        data: (recomendaciones) {
          if (recomendaciones.isEmpty) {
            return const Center(
              child: Text('No hay recomendaciones disponibles.'),
            );
          }

          return ListView.builder(
            itemCount: recomendaciones.length,
            itemBuilder: (context, index) {
              final rec = recomendaciones[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text('${rec.lugarRecomendado} - ${rec.tipo}'),
                  subtitle: Text(
                    '${rec.ciudad}, ${rec.pais}\n${rec.comentario ?? ''}',
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.red),
                    onPressed: () {
                      // TODO: Guardar como favorito
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Añadido a favoritos (por implementar)',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
