import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../model/viaje.dart';
import '../../application/services/database_service.dart';

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
      final viaje = Viaje(
        id: widget.viaje?.id,
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
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _fechaInicio == null
                          ? 'Inicio: (no seleccionado)'
                          : 'Inicio: ${DateFormat('dd/MM/yyyy').format(_fechaInicio!)}',
                    ),
                  ),
                  TextButton(
                    onPressed: () => _seleccionarFecha(esInicio: true),
                    child: const Text('Seleccionar'),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _fechaFin == null
                          ? 'Fin: (no seleccionado)'
                          : 'Fin: ${DateFormat('dd/MM/yyyy').format(_fechaFin!)}',
                    ),
                  ),
                  TextButton(
                    onPressed: () => _seleccionarFecha(esInicio: false),
                    child: const Text('Seleccionar'),
                  ),
                ],
              ),
              TextFormField(
                controller: _transporteCtrl,
                decoration: const InputDecoration(labelText: 'Transporte'),
              ),
              TextFormField(
                controller: _alojamientoCtrl,
                decoration: const InputDecoration(labelText: 'Alojamiento'),
              ),
              TextFormField(
                controller: _notasCtrl,
                decoration: const InputDecoration(
                  labelText: 'Notas personales',
                ),
                maxLines: 2,
              ),
              TextFormField(
                controller: _climaCtrl,
                decoration: const InputDecoration(labelText: 'Clima'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarViaje,
                child: Text(esEdicion ? 'Actualizar viaje' : 'Guardar viaje'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
