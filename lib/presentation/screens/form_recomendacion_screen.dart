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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _paisCtrl,
                decoration: const InputDecoration(labelText: 'País'),
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: _ciudadCtrl,
                decoration: const InputDecoration(labelText: 'Ciudad'),
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: _regionCtrl,
                decoration: const InputDecoration(
                  labelText: 'Región (opcional)',
                ),
              ),
              TextFormField(
                controller: _lugarCtrl,
                decoration: const InputDecoration(
                  labelText: 'Lugar recomendado',
                ),
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: _tipoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tipo (comida, cultura, etc.)',
                ),
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: _comentarioCtrl,
                decoration: const InputDecoration(
                  labelText: 'Comentario (opcional)',
                ),
                maxLines: 2,
              ),
              TextFormField(
                controller: _puntuacionCtrl,
                decoration: const InputDecoration(
                  labelText: 'Puntuación (1-5)',
                ),
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
              TextFormField(
                controller: _imagenUrlCtrl,
                decoration: const InputDecoration(
                  labelText: 'URL de imagen (opcional)',
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
                onPressed: _guardarRecomendacion,
                child: const Text('Guardar recomendación'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
