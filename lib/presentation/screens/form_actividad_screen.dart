import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/actividad.dart';
import '../../application/services/database_service.dart';

class FormularioActividadScreen extends ConsumerStatefulWidget {
  final int viajeId;
  const FormularioActividadScreen({super.key, required this.viajeId});

  @override
  ConsumerState<FormularioActividadScreen> createState() =>
      _FormularioActividadScreenState();
}

class _FormularioActividadScreenState
    extends ConsumerState<FormularioActividadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tipoCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();
  final _puntuacionCtrl = TextEditingController();
  final _fotoLocalCtrl = TextEditingController();
  final _ubicacionUrlCtrl = TextEditingController();

  Future<void> _guardarActividad() async {
    if (_formKey.currentState!.validate()) {
      final service = ref.read(databaseServiceProvider);
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

      await service.insertarActividad(nuevaActividad);
      if (context.mounted) Navigator.pop(context, true);
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
                validator: (v) =>
                    v!.isEmpty ? 'Este campo es obligatorio' : null,
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
                  if (value!.isEmpty) return null;
                  final n = int.tryParse(value);
                  if (n == null || n < 1 || n > 5)
                    return 'Ingrese un número entre 1 y 5';
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
