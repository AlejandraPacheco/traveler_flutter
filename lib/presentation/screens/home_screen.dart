import 'package:flutter/material.dart';
import 'package:traveler/data/database_helper.dart';
import 'package:traveler/model/viaje.dart';
import 'form_viaje_screen.dart';
import 'detalle_viaje_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbHelper = DatabaseHelper();
  List<Viaje> _viajes = [];

  @override
  void initState() {
    super.initState();
    _cargarViajes();
  }

  Future<void> _cargarViajes() async {
    final viajes = await dbHelper.obtenerViajes();
    setState(() {
      _viajes = viajes;
    });
  }

  Future<void> _abrirFormularioNuevoViaje() async {
    final creado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FormularioViajeScreen()),
    );

    if (creado == true) {
      _cargarViajes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Viajes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              onPressed: _abrirFormularioNuevoViaje,
              child: const Text('Agregar nuevo viaje'),
            ),
          ),
          Expanded(
            child: _viajes.isEmpty
                ? const Center(child: Text('No hay viajes registrados'))
                : ListView.builder(
                    itemCount: _viajes.length,
                    itemBuilder: (context, index) {
                      final viaje = _viajes[index];
                      return ListTile(
                        title: Text('${viaje.ciudad}, ${viaje.pais}'),
                        subtitle: Text(
                          'Del ${viaje.fechaInicio} al ${viaje.fechaFin}',
                        ),
                        trailing: Text(viaje.clima ?? ''),
                        onTap: () async {
                          final refrescar = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetalleViajeScreen(viaje: viaje),
                            ),
                          );
                          if (refrescar == true) {
                            _cargarViajes();
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
