// ============================================================================
//                              ROLE CHIP WIDGET
// ============================================================================
// A reusable chip widget for selecting user roles (e.g., Company, Individual).
// Displays as a selectable choice chip with an icon and label.
//
// PURPOSE:
// - Provides a consistent UI for role selection in signup/registration forms
// - Shows visual feedback when a role is selected (color change, elevation)
// - Handles role selection callbacks for parent widgets
//
// BEHAVIOR:
// - Selected state: Blue border, blue icon, elevated appearance
// - Unselected state: Grey border, grey icon, flat appearance
// - On tap: Calls onSelected callback with the role value
//
// USAGE:
// - Used in signup forms to allow users to select their role
// - Parent widget manages selectedRole state and updates it via onSelected
// ============================================================================

import 'package:flutter/material.dart';

class RoleChip extends StatelessWidget {
  const RoleChip({
    super.key,
    required this.label, // Display text for the role (e.g., "Company", "Individual")
    required this.icon, // Icon to display next to the label
    required this.value, // Unique identifier for this role (used for comparison)
    required this.selectedRole, // Currently selected role value from parent
    required this.onSelected, // Callback when chip is tapped
  });
  final String label;
  final IconData icon;
  final String value;
  final String selectedRole;
  final ValueChanged<String> onSelected;

  // Computed property to determine if this chip is currently selected
  bool get isSelected => selectedRole == value;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      showCheckmark: false, // Don't show checkmark, use border/color instead
      // Icon displayed before the label
      avatar: Icon(
        icon,
        size: 22,
        // Icon color changes based on selection state
        color: isSelected ? Colors.blue : Colors.grey.shade600,
      ),
      // Role label text
      label: Text(label, style: const TextStyle(fontSize: 15)),
      // Whether this chip is currently selected
      selected: isSelected,
      // Callback when chip is tapped - passes the role value to parent
      onSelected: (_) => onSelected(value),
      // Background color when selected (light blue tint)
      selectedColor: Colors.blue.withAlpha(15),
      checkmarkColor: Colors.blue,
      // Background color when not selected
      backgroundColor: Colors.grey.shade50,
      // Elevation effect: raised when selected, flat when not
      elevation: isSelected ? 2 : 0,
      pressElevation: 4, // Elevation when pressed/tapped
      // Label text styling that changes based on selection
      labelStyle: TextStyle(
        color: isSelected ? Colors.blue.shade700 : Colors.grey.shade700,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        letterSpacing: 0.2,
      ),
      // Internal padding for the chip
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      // Rounded rectangle shape with dynamic border
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          // Border color and width change based on selection
          color: isSelected ? Colors.blue : Colors.grey.shade300,
          width: isSelected ? 2 : 1.5,
        ),
      ),
    );
  }
}
