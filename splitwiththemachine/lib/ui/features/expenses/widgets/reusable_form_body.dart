import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:splitwiththemachine/ui/core/widgets/generic_sized_box.dart';

class ReusableFormBody extends StatelessWidget {
  final TextEditingController descriptionController;
  final TextEditingController amountController;
  final TextEditingController dateController;
  final VoidCallback onDateTap;

  const ReusableFormBody({
    super.key,
    required this.descriptionController,
    required this.amountController,
    required this.dateController,
    required this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return StretchingOverscrollIndicator(
      axisDirection: AxisDirection.down,
      child: CustomScrollView(
        slivers: [

          _buildField(
            icon: FontAwesomeIcons.fileLines,
            field: TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ),

          _buildField(
            icon: FontAwesomeIcons.moneyBill,
            field: TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: const InputDecoration(labelText: 'Amount (\$)'),
            ),
          ),

          _buildField(
            icon: FontAwesomeIcons.calendar,
            field: TextField(
              controller: dateController,
              readOnly: true,
              enableInteractiveSelection: false,
              decoration: const InputDecoration(
                labelText: 'Date',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: onDateTap,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  /// Helpers to reduce repetition
  SliverToBoxAdapter _buildField({required IconData icon, required Widget field}) {
    return SliverToBoxAdapter(
      child: GenericSizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: _buildIconField(icon: icon, field: field),
        ),
      ),
    );
  }

  Widget _buildIconField({required IconData icon, required Widget field}) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 12),
        Expanded(child: field),
      ],
    );
  }
}
