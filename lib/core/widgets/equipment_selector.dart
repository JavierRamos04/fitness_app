import 'package:flutter/material.dart';

import '../database/app_database.dart';

/// Chips para marcar qué equipo se tiene. Se usa en el onboarding y en Perfil.
class EquipmentSelector extends StatelessWidget {
  const EquipmentSelector({
    super.key,
    required this.options,
    required this.selectedCodes,
    required this.onChanged,
    this.enabled = true,
  });

  final List<EquipmentData> options;
  final Set<String> selectedCodes;
  final ValueChanged<Set<String>> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final item in options)
          FilterChip(
            label: Text(item.name),
            selected: selectedCodes.contains(item.code),
            onSelected: enabled
                ? (isSelected) {
                    final updated = {...selectedCodes};

                    if (isSelected) {
                      updated.add(item.code);
                    } else {
                      updated.remove(item.code);
                    }

                    onChanged(updated);
                  }
                : null,
          ),
      ],
    );
  }
}
