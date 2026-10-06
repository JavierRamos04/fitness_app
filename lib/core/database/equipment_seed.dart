import 'app_database.dart';

/// Equipamiento inicial. El `code` es el identificador estable (no cambiar
/// una vez publicado); el `name` es el texto que ve el usuario.
List<EquipmentCompanion> get initialEquipment {
  return [
    EquipmentCompanion.insert(code: 'dumbbells', name: 'Mancuernas'),
    EquipmentCompanion.insert(code: 'resistance_band', name: 'Banda elástica'),
    EquipmentCompanion.insert(code: 'bench', name: 'Banco'),
    EquipmentCompanion.insert(code: 'pull_up_bar', name: 'Barra de dominadas'),
    EquipmentCompanion.insert(code: 'barbell', name: 'Barra con discos'),
    EquipmentCompanion.insert(code: 'cable_machine', name: 'Polea'),
    EquipmentCompanion.insert(code: 'gym_machine', name: 'Máquina de gimnasio'),
  ];
}
