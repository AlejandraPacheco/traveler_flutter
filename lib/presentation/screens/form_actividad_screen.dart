import 'package:flutter/material.dart';
import 'package:traveler/data/database_helper.dart';
import 'package:traveler/model/actividad.dart';

class FormularioActividadScreen extends StatefulWidget {
  final int viajeId;

  const FormularioActividadScreen({super.key, required this.viajeId});

  @override
  State<FormularioActividadScreen> createState() =>
      _FormularioActividadScreenState();
}

class _FormularioActividadScreenState extends State<FormularioActividadScreen> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper();

  final _tipoCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();
  final _puntuacionCtrl = TextEditingController();
  final _fotoLocalCtrl = TextEditingController();
  final _ubicacionUrlCtrl = TextEditingController();

  Future<void> _guardarActividad() async {
    if (_formKey.currentState!.validate()) {
      int? puntuacion = int.tryParse(_puntuacionCtrl.text);

      final nuevaActividad = Actividad(
        viajeId: widget.viajeId,
        tipo: _tipoCtrl.text,
        descripcion: _descripcionCtrl.text.isEmpty
            ? null
            : _descripcionCtrl.text,
        puntuacion: puntuacion,
        fotoLocal: _fotoLocalCtrl.text.isEmpty ? null : _fotoLocalCtrl.text,
        ubicacionUrl: _ubicacionUrlCtrl.text.isEmpty
            ? null
            : _ubicacionUrlCtrl.text,
      );

      await dbHelper.insertarActividad(nuevaActividad);
      if (context.mounted) {
        Navigator.pop(context, true); // Regresa true para refrescar actividades
      }
    }
  }

  @override
  void dispose() {
    _tipoCtrl.dispose();
    _descripcionCtrl.dispose();
    _puntuacionCtrl.dispose();
    _fotoLocalCtrl.dispose();
    _ubicacionUrlCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Actividad')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tipoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tipo de actividad',
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              TextFormField(
                controller: _descripcionCtrl,
                decoration: const InputDecoration(
                  labelText: 'Descripción (opcional)',
                ),
                maxLines: 2,
              ),
              TextFormField(
                controller: _puntuacionCtrl,
                decoration: const InputDecoration(
                  labelText: 'Puntuación (1-5)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return null; // opcional
                  final n = int.tryParse(value);
                  if (n == null || n < 1 || n > 5) {
                    return 'Ingrese un número entre 1 y 5';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fotoLocalCtrl,
                decoration: const InputDecoration(
                  labelText: 'Ruta foto local (opcional)',
                ),
              ),
              TextFormField(
                controller: _ubicacionUrlCtrl,
                decoration: const InputDecoration(
                  labelText: 'URL ubicación (opcional)',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarActividad,
                child: const Text('Guardar actividad'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
