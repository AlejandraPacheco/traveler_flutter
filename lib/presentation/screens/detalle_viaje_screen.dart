import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/actividad_provider.dart';
import '../../model/viaje.dart';
import '../../model/actividad.dart';
import 'form_viaje_screen.dart';
import 'form_actividad_screen.dart';

class DetalleViajeScreen extends ConsumerWidget {
  final Viaje viaje;
  const DetalleViajeScreen({super.key, required this.viaje});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actividadesAsync = ref.watch(actividadListProvider(viaje.id!));

    Future<void> _editarViaje() async {
      final actualizado = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FormularioViajeScreen(viaje: viaje)),
      );
      if (actualizado == true && context.mounted) {
        Navigator.pop(context, true);
      }
    }

    Future<void> _nuevaActividad() async {
      final creado = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FormularioActividadScreen(viajeId: viaje.id!),
        ),
      );
      if (creado == true) {
        ref.refresh(actividadListProvider(viaje.id!));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${viaje.ciudad}, ${viaje.pais}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editarViaje,
            tooltip: 'Editar viaje',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Card(
                color: Colors.white.withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _dato('🌍 Región', viaje.region ?? "No especificado"),
                      _dato('📅 Fecha inicio', viaje.fechaInicio),
                      _dato('📅 Fecha fin', viaje.fechaFin),
                      _dato(
                        '✈️ Transporte',
                        viaje.transporte ?? "No especificado",
                      ),
                      _dato(
                        '🏨 Alojamiento',
                        viaje.alojamiento ?? "No especificado",
                      ),
                      _dato('📝 Notas', viaje.notasPersonales ?? "Sin notas"),
                      _dato('☁️ Clima', viaje.clima ?? "No especificado"),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _nuevaActividad,
                icon: const Icon(Icons.add),
                label: const Text(
                  'Añadir actividad',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '🗺️ Actividades realizadas:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: actividadesAsync.when(
                data: (actividades) => actividades.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay actividades aún.',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        itemCount: actividades.length,
                        itemBuilder: (context, index) {
                          final act = actividades[index];
                          return Card(
                            color: Colors.white.withOpacity(0.95),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(
                                act.tipo,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(act.descripcion ?? ''),
                              trailing: act.puntuacion != null
                                  ? Text('⭐ ${act.puntuacion}')
                                  : null,
                            ),
                          );
                        },
                      ),
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
          ],
        ),
      ),
    );
  }

  Widget _dato(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text('$titulo: $valor', style: const TextStyle(fontSize: 16)),
    );
  }
}
