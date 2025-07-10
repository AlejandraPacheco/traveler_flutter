import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../application/providers/auth_provider.dart';
import '../../application/providers/recomendacion_provider.dart';
import '../../model/recomendacion.dart';

class FormRecomendacionScreen extends ConsumerStatefulWidget {
  const FormRecomendacionScreen({super.key});

  @override
  ConsumerState<FormRecomendacionScreen> createState() =>
      _FormRecomendacionScreenState();
}

class _FormRecomendacionScreenState
    extends ConsumerState<FormRecomendacionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _paisCtrl,
      _ciudadCtrl,
      _regionCtrl,
      _lugarCtrl,
      _tipoCtrl,
      _comentarioCtrl,
      _puntuacionCtrl,
      _imagenUrlCtrl,
      _ubicacionUrlCtrl;

  @override
  void initState() {
    super.initState();
    _paisCtrl = TextEditingController();
    _ciudadCtrl = TextEditingController();
    _regionCtrl = TextEditingController();
    _lugarCtrl = TextEditingController();
    _tipoCtrl = TextEditingController();
    _comentarioCtrl = TextEditingController();
    _puntuacionCtrl = TextEditingController();
    _imagenUrlCtrl = TextEditingController();
    _ubicacionUrlCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _paisCtrl.dispose();
    _ciudadCtrl.dispose();
    _regionCtrl.dispose();
    _lugarCtrl.dispose();
    _tipoCtrl.dispose();
    _comentarioCtrl.dispose();
    _puntuacionCtrl.dispose();
    _imagenUrlCtrl.dispose();
    _ubicacionUrlCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardarRecomendacion() async {
    if (_formKey.currentState!.validate()) {
      final userId = ref.read(currentUserIdProvider);
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: sesión no disponible')),
        );
        return;
      }

      final recomendacion = Recomendacion(
        id: '',
        userId: userId,
        pais: _paisCtrl.text.trim(),
        ciudad: _ciudadCtrl.text.trim(),
        region: _regionCtrl.text.trim().isEmpty
            ? null
            : _regionCtrl.text.trim(),
        lugarRecomendado: _lugarCtrl.text.trim(),
        tipo: _tipoCtrl.text.trim(),
        comentario: _comentarioCtrl.text.trim().isEmpty
            ? null
            : _comentarioCtrl.text,
        imagenUrl: _imagenUrlCtrl.text.trim().isEmpty
            ? null
            : _imagenUrlCtrl.text,
        puntuacion: _puntuacionCtrl.text.trim().isEmpty
            ? null
            : int.tryParse(_puntuacionCtrl.text),
        fechaPublicacion: DateTime.now(),
        ubicacionUrl: _ubicacionUrlCtrl.text.trim().isEmpty
            ? null
            : _ubicacionUrlCtrl.text,
      );

      final service = ref.read(recomendacionServiceProvider);
      await service.crearRecomendacion(recomendacion);

      if (context.mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Recomendación')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF43CEA2), Color(0xFF185A9D)],
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
                controller: _paisCtrl,
                label: 'País',
                icon: Icons.flag,
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              _campoTexto(
                controller: _ciudadCtrl,
                label: 'Ciudad',
                icon: Icons.location_city,
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              _campoTexto(
                controller: _regionCtrl,
                label: 'Región (opcional)',
                icon: Icons.map,
              ),
              _campoTexto(
                controller: _lugarCtrl,
                label: 'Lugar recomendado',
                icon: Icons.place,
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              _campoTexto(
                controller: _tipoCtrl,
                label: 'Tipo (comida, cultura, etc.)',
                icon: Icons.category,
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              _campoTexto(
                controller: _comentarioCtrl,
                label: 'Comentario (opcional)',
                icon: Icons.comment,
                maxLines: 2,
              ),
              _campoTexto(
                controller: _puntuacionCtrl,
                label: 'Puntuación (1-5)',
                icon: Icons.star,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  final n = int.tryParse(v);
                  if (n == null || n < 1 || n > 5) {
                    return 'Debe ser un número entre 1 y 5';
                  }
                  return null;
                },
              ),
              /* _campoTexto(
                controller: _imagenUrlCtrl,
                label: 'URL de imagen (opcional)',
                icon: Icons.image,
              ), */
              _campoTexto(
                controller: _ubicacionUrlCtrl,
                label: 'URL ubicación (opcional)',
                icon: Icons.map_outlined,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _guardarRecomendacion,
                icon: const Icon(Icons.save),
                label: const Text('Guardar recomendación'),
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
