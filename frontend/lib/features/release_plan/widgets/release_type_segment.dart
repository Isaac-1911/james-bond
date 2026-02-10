import 'package:flutter/material.dart';
import 'package:frontend/models/release_plan.dart';

class ReleaseTypeSegment extends StatelessWidget {
  final ReleaseType selected;
  final ValueChanged<ReleaseType> onChanged;

  const ReleaseTypeSegment({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildItem(
              label: 'Publikasi',
              type: ReleaseType.publikasi,
            ),
            _buildItem(
              label: 'BRS',
              type: ReleaseType.brs,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({
    required String label,
    required ReleaseType type,
  }) {
    final isActive = selected == type;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(type),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFF007AFF)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
