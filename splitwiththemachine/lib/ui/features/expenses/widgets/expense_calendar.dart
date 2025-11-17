import 'package:flutter/material.dart';
import 'package:splitwiththemachine/ui/core/widgets/generic_app_bar.dart';
import 'package:splitwiththemachine/ui/core/widgets/generic_sized_box.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class ExpenseCalendar extends StatefulWidget {
  const ExpenseCalendar({
    super.key,
    required this.initialDate,
  });

  final DateTime initialDate;

  @override
  State<ExpenseCalendar> createState() => _ExpenseCalendarState();
}

class _ExpenseCalendarState extends State<ExpenseCalendar> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialDate;
    _selectedDay = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GenericAppBar(title: "Select a date"),
      body: StretchingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        child: CustomScrollView(
          slivers: [
            // Calendar
            SliverToBoxAdapter(
              child: GenericSizedBox(
                child: FractionallySizedBox(
                  widthFactor: 0.9, // 90% of screen width
                  child: TableCalendar(
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
                      todayTextStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      todayDecoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        shape: BoxShape.rectangle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            /// Space after the calendar
            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            /// Selected date text
            SliverToBoxAdapter(
              child: Text(
                "Selected: ${DateFormat('EEEE, MMMM d').format(_selectedDay)}",
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),

            /// Button
            SliverToBoxAdapter(
              child: Align(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  label: const Text("Confirm Date"),
                  onPressed: () {
                    Navigator.pop(context, _selectedDay);
                  },
                ),
              ),
            ),

            /// Always leave bottom space so user can scroll comfortably
            const SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        ),
      ),
    );
  }
}
