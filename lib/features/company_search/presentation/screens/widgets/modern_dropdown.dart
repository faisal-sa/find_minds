import 'package:flutter/material.dart';

class ModernDropdown extends StatelessWidget {
  final String? value;
  final String label;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const ModernDropdown({
    super.key,
    required this.value,
    required this.label,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(16),
        icon: const SizedBox.shrink(), // Hide default arrow
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            Icons.work_outline_rounded,
            color: Colors.grey[500],
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          labelStyle: TextStyle(color: Colors.grey[600]),
          suffixIcon: value == null
              ? const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey,
                )
              : IconButton(
                  icon: const Icon(
                    Icons.clear_rounded,
                    color: Colors.grey,
                    size: 20,
                  ),
                  onPressed: () => onChanged(null),
                ),
        ),
        items: items
            .map(
              (s) => DropdownMenuItem(
                value: s,
                child: Text(s, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
