import 'package:flutter/material.dart';

import '../../../core/services/set_input_rules.dart';
import '../../../core/utils/decimal_parser.dart';
import '../../../core/utils/number_format.dart';

/// Valores corregidos de una serie ya registrada.
class EditedSet {
  const EditedSet({required this.repetitions, required this.weightKg});

  /// Repeticiones o, en ejercicios por tiempo, segundos.
  final int repetitions;

  /// `null` si se hizo con el peso corporal.
  final double? weightKg;
}

/// Diálogo para corregir una serie ya registrada. Devuelve `null` si se
/// cancela. Usa las mismas reglas de validación que al registrar una serie.
class EditSetDialog extends StatefulWidget {
  const EditSetDialog({
    super.key,
    required this.setNumber,
    required this.initialRepetitions,
    required this.initialWeightKg,
    required this.timed,
    required this.noEquipment,
  });

  final int setNumber;
  final int initialRepetitions;
  final double? initialWeightKg;
  final bool timed;
  final bool noEquipment;

  @override
  State<EditSetDialog> createState() => _EditSetDialogState();
}

class _EditSetDialogState extends State<EditSetDialog> {
  late final TextEditingController _repetitionsController;
  late final TextEditingController _weightController;

  String? _error;

  @override
  void initState() {
    super.initState();

    _repetitionsController = TextEditingController(
      text: '${widget.initialRepetitions}',
    );

    final weight = widget.initialWeightKg;

    _weightController = TextEditingController(
      text: weight == null || weight <= 0 ? '' : formatNumber(weight),
    );
  }

  @override
  void dispose() {
    _repetitionsController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _submit() {
    final weightText = widget.timed ? '' : _weightController.text.trim();

    final error = SetInputRules.validate(
      repetitionsText: _repetitionsController.text,
      weightText: weightText,
      timed: widget.timed,
    );

    if (error != null) {
      setState(() {
        _error = error;
      });
      return;
    }

    Navigator.of(context).pop(
      EditedSet(
        repetitions: int.parse(_repetitionsController.text.trim()),
        weightKg: weightText.isEmpty ? null : parseDecimal(weightText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Corregir serie ${widget.setNumber}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _repetitionsController,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: SetInputRules.repetitionsLabel(timed: widget.timed),
                hintText: SetInputRules.repetitionsHint(timed: widget.timed),
              ),
              onChanged: (_) {
                if (_error != null) {
                  setState(() {
                    _error = null;
                  });
                }
              },
            ),
            if (!widget.timed) ...[
              const SizedBox(height: 14),
              TextField(
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: SetInputRules.weightLabel(
                    noEquipment: widget.noEquipment,
                  ),
                  hintText: SetInputRules.weightHint(
                    noEquipment: widget.noEquipment,
                  ),
                ),
                onChanged: (_) {
                  if (_error != null) {
                    setState(() {
                      _error = null;
                    });
                  }
                },
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Guardar')),
      ],
    );
  }
}
