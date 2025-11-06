import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class ExpenseCalendar extends StatefulWidget {
  const ExpenseCalendar({
    super.key,
    required this.onDateSelected,
  });

  /// Callback que devuelve la fecha seleccionada al padre
  final ValueChanged<DateTime> onDateSelected;

  @override
  State<ExpenseCalendar> createState() => _ExpenseCalendarState();
}

class _ExpenseCalendarState extends State<ExpenseCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select a Date"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue.shade300,
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (_selectedDay != null)
            Text(
              "Selected: ${DateFormat('yyyy-MM-dd').format(_selectedDay!)}",
              style: const TextStyle(fontSize: 18),
            ),
          const Spacer(),
          ElevatedButton.icon(
            icon: const Icon(Icons.check),
            label: const Text("Confirm Date"),
            onPressed: _selectedDay == null
                ? null
                : () {
              widget.onDateSelected(_selectedDay!);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
