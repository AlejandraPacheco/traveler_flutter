import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/recomendacion_provider.dart';
import 'form_recomendacion_screen.dart';
import 'detalle_recomendacion_screen.dart';

class RecomendacionesScreen extends ConsumerStatefulWidget {
  const RecomendacionesScreen({super.key});

  @override
  ConsumerState<RecomendacionesScreen> createState() =>
      _RecomendacionesScreenState();
}

class _RecomendacionesScreenState extends ConsumerState<RecomendacionesScreen> {
  @override
  void initState() {
    super.initState();
    // Fuerza actualización de las recomendaciones cada vez que se entra
    Future.microtask(() => ref.invalidate(recomendacionesUsuarioProvider));
  }

  @override
  Widget build(BuildContext context) {
    final recomendacionesAsync = ref.watch(recomendacionesUsuarioProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Recomendaciones')),
      body: recomendacionesAsync.when(
        data: (recomendaciones) {
          if (recomendaciones.isEmpty) {
            return const Center(child: Text('Aún no hay recomendaciones.'));
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
                  trailing: rec.puntuacion != null
                      ? Chip(label: Text('⭐ ${rec.puntuacion}'))
                      : null,
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error al cargar: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormRecomendacionScreen()),
          ).then((_) => ref.invalidate(recomendacionesUsuarioProvider));
        },
        icon: const Icon(Icons.add),
        label: const Text('Añadir recomendación'),
      ),
    );
  }
}
