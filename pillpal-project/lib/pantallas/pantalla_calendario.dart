
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pillpal/constants/colors.dart';
import 'package:table_calendar/table_calendar.dart';

import 'navigation_drawer.dart';


class PantallaCalendario extends StatefulWidget {
  const PantallaCalendario({super.key});

  @override
  _PantallaCalendarioState createState() => _PantallaCalendarioState();
}
class _PantallaCalendarioState extends State<PantallaCalendario> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calendario',
          style: TextStyle(fontSize: 25.0),
        ),
        backgroundColor: ColorsApp.toolBarColor,
      ),
      drawer: MyDrawer(),
      body: TableCalendar(

        firstDay: DateTime.utc(2023, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          // Use `selectedDayPredicate` to determine which day is currently selected.
          // If this returns true, then `day` will be marked as selected.

          // Using `isSameDay` is recommended to disregard
          // the time-part of compared DateTime objects.
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            // Call `setState()` when updating the selected day
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            // Call `setState()` when updating calendar format
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          // No need to call `setState()` here
          _focusedDay = focusedDay;
        },
      ),
      );
  }
}

