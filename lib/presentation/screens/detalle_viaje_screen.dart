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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Región: ${viaje.region ?? "No especificado"}'),
            Text('Fecha inicio: ${viaje.fechaInicio}'),
            Text('Fecha fin: ${viaje.fechaFin}'),
            Text('Transporte: ${viaje.transporte ?? "No especificado"}'),
            Text('Alojamiento: ${viaje.alojamiento ?? "No especificado"}'),
            Text('Notas: ${viaje.notasPersonales ?? "Sin notas"}'),
            Text('Clima: ${viaje.clima ?? "No especificado"}'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _nuevaActividad,
              icon: const Icon(Icons.add),
              label: const Text('Añadir actividad'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Actividades realizadas:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Expanded(
              child: actividadesAsync.when(
                data: (actividades) => actividades.isEmpty
                    ? const Center(child: Text('No hay actividades aún.'))
                    : ListView.builder(
                        itemCount: actividades.length,
                        itemBuilder: (context, index) {
                          final act = actividades[index];
                          return ListTile(
                            title: Text(act.tipo),
                            subtitle: Text(act.descripcion ?? ''),
                            trailing: act.puntuacion != null
                                ? Text('⭐ ${act.puntuacion}')
                                : null,
                          );
                        },
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: \$e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
