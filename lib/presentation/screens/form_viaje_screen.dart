import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../model/viaje.dart';
import '../../application/services/database_service.dart';
import '../../application/providers/auth_provider.dart';

class FormularioViajeScreen extends ConsumerStatefulWidget {
  final Viaje? viaje;
  const FormularioViajeScreen({super.key, this.viaje});

  @override
  ConsumerState<FormularioViajeScreen> createState() =>
      _FormularioViajeScreenState();
}

class _FormularioViajeScreenState extends ConsumerState<FormularioViajeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _paisCtrl,
      _ciudadCtrl,
      _regionCtrl,
      _transporteCtrl,
      _alojamientoCtrl,
      _notasCtrl,
      _climaCtrl;

  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  @override
  void initState() {
    super.initState();
    final v = widget.viaje;
    _paisCtrl = TextEditingController(text: v?.pais ?? '');
    _ciudadCtrl = TextEditingController(text: v?.ciudad ?? '');
    _regionCtrl = TextEditingController(text: v?.region ?? '');
    _transporteCtrl = TextEditingController(text: v?.transporte ?? '');
    _alojamientoCtrl = TextEditingController(text: v?.alojamiento ?? '');
    _notasCtrl = TextEditingController(text: v?.notasPersonales ?? '');
    _climaCtrl = TextEditingController(text: v?.clima ?? '');
    _fechaInicio = v != null ? DateTime.tryParse(v.fechaInicio) : null;
    _fechaFin = v != null ? DateTime.tryParse(v.fechaFin) : null;
  }

  Future<void> _seleccionarFecha({required bool esInicio}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: esInicio
          ? (_fechaInicio ?? DateTime.now())
          : (_fechaFin ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (esInicio) {
          _fechaInicio = picked;
        } else {
          _fechaFin = picked;
        }
      });
    }
  }

  Future<void> _guardarViaje() async {
    if (_formKey.currentState!.validate() &&
        _fechaInicio != null &&
        _fechaFin != null) {
      final service = ref.read(databaseServiceProvider);
      final userId = ref.read(currentUserIdProvider);
      final viaje = Viaje(
        id: widget.viaje?.id,
        userId: userId!,
        pais: _paisCtrl.text,
        ciudad: _ciudadCtrl.text,
        region: _regionCtrl.text.isEmpty ? null : _regionCtrl.text,
        fechaInicio: DateFormat('yyyy-MM-dd').format(_fechaInicio!),
        fechaFin: DateFormat('yyyy-MM-dd').format(_fechaFin!),
        transporte: _transporteCtrl.text.isEmpty ? null : _transporteCtrl.text,
        alojamiento: _alojamientoCtrl.text.isEmpty
            ? null
            : _alojamientoCtrl.text,
        notasPersonales: _notasCtrl.text.isEmpty ? null : _notasCtrl.text,
        clima: _climaCtrl.text.isEmpty ? null : _climaCtrl.text,
        sincronizado: widget.viaje?.sincronizado ?? false,
      );

      if (widget.viaje == null) {
        await service.insertarViaje(viaje);
      } else {
        await service.actualizarViaje(viaje);
      }

      if (context.mounted) Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _paisCtrl.dispose();
    _ciudadCtrl.dispose();
    _regionCtrl.dispose();
    _transporteCtrl.dispose();
    _alojamientoCtrl.dispose();
    _notasCtrl.dispose();
    _climaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.viaje != null;

    return Scaffold(
      appBar: AppBar(title: Text(esEdicion ? 'Editar Viaje' : 'Nuevo Viaje')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _inputConEstilo(
                controller: _paisCtrl,
                label: 'País',
                icon: Icons.flag,
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              _inputConEstilo(
                controller: _ciudadCtrl,
                label: 'Ciudad',
                icon: Icons.location_city,
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              _inputConEstilo(
                controller: _regionCtrl,
                label: 'Región (opcional)',
                icon: Icons.map,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        _fechaInicio == null
                            ? 'Inicio'
                            : DateFormat('dd/MM/yyyy').format(_fechaInicio!),
                      ),
                      onPressed: () => _seleccionarFecha(esInicio: true),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.indigo.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_month),
                      label: Text(
                        _fechaFin == null
                            ? 'Fin'
                            : DateFormat('dd/MM/yyyy').format(_fechaFin!),
                      ),
                      onPressed: () => _seleccionarFecha(esInicio: false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.indigo.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _inputConEstilo(
                controller: _transporteCtrl,
                label: 'Transporte',
                icon: Icons.directions_car,
              ),
              _inputConEstilo(
                controller: _alojamientoCtrl,
                label: 'Alojamiento',
                icon: Icons.hotel,
              ),
              _inputConEstilo(
                controller: _notasCtrl,
                label: 'Notas personales',
                icon: Icons.note_alt,
                maxLines: 2,
              ),
              _inputConEstilo(
                controller: _climaCtrl,
                label: 'Clima',
                icon: Icons.cloud,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _guardarViaje,
                icon: const Icon(Icons.save),
                label: Text(esEdicion ? 'Actualizar viaje' : 'Guardar viaje'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
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

  // Helper visual para campos con estilo
  Widget _inputConEstilo({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    FormFieldValidator<String>? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        validator: validator,
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
