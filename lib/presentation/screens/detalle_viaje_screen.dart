import 'package:flutter/material.dart';
import 'package:traveler/model/viaje.dart';
import 'package:traveler/data/database_helper.dart';
import 'form_viaje_screen.dart';
import 'form_actividad_screen.dart';
import 'package:traveler/model/actividad.dart';

class DetalleViajeScreen extends StatefulWidget {
  final Viaje viaje;
  const DetalleViajeScreen({super.key, required this.viaje});

  @override
  State<DetalleViajeScreen> createState() => _DetalleViajeScreenState();
}

class _DetalleViajeScreenState extends State<DetalleViajeScreen> {
  final dbHelper = DatabaseHelper();

  List<Actividad> actividades = [];

  @override
  void initState() {
    super.initState();
    _cargarActividades();
  }

  Future<void> _cargarActividades() async {
    final lista = await dbHelper.obtenerActividadesPorViaje(widget.viaje.id!);
    setState(() {
      actividades = lista;
    });
  }

  Future<void> _editarViaje() async {
    final actualizado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormularioViajeScreen(viaje: widget.viaje),
      ),
    );

    if (actualizado == true) {
      if (context.mounted)
        Navigator.pop(context, true); // Refrescar lista viajes
    }
  }

  Future<void> _nuevaActividad() async {
    final creado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormularioActividadScreen(viajeId: widget.viaje.id!),
      ),
    );
    if (creado == true) {
      _cargarActividades();
    }
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.viaje;
    return Scaffold(
      appBar: AppBar(
        title: Text('${v.ciudad}, ${v.pais}'),
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
            Text('Región: ${v.region ?? "No especificado"}'),
            Text('Fecha inicio: ${v.fechaInicio}'),
            Text('Fecha fin: ${v.fechaFin}'),
            Text('Transporte: ${v.transporte ?? "No especificado"}'),
            Text('Alojamiento: ${v.alojamiento ?? "No especificado"}'),
            Text('Notas: ${v.notasPersonales ?? "Sin notas"}'),
            Text('Clima: ${v.clima ?? "No especificado"}'),
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
              child: actividades.isEmpty
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
            ),
          ],
        ),
      ),
    );
  }
}
