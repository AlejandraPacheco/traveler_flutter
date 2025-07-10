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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _campoTexto(
                controller: _tipoCtrl,
                label: 'Tipo de actividad',
                icon: Icons.category,
                validator: (v) =>
                    v!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              _campoTexto(
                controller: _descripcionCtrl,
                label: 'Descripción (opcional)',
                icon: Icons.description,
                maxLines: 2,
              ),
              _campoTexto(
                controller: _puntuacionCtrl,
                label: 'Puntuación (1-5)',
                icon: Icons.star,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return null;
                  final n = int.tryParse(value);
                  if (n == null || n < 1 || n > 5) {
                    return 'Ingrese un número entre 1 y 5';
                  }
                  return null;
                },
              ),
              /* _campoTexto(
                controller: _fotoLocalCtrl,
                label: 'Ruta foto local (opcional)',
                icon: Icons.photo,
              ), */
              _campoTexto(
                controller: _ubicacionUrlCtrl,
                label: 'URL ubicación (opcional)',
                icon: Icons.location_on,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _guardarActividad,
                icon: const Icon(Icons.save),
                label: const Text('Guardar actividad'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar reutilizable para campos con estilo
  Widget _campoTexto({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    FormFieldValidator<String>? validator,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
