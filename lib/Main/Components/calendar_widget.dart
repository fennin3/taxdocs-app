import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';
import 'package:taxdocs/Provider/app_state.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({
    Key? key,
    required this.size,
    required this.onSelected
  }) : super(key: key);

  final Size size;
  final Function(DateTime) onSelected;

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<appState>(context, listen: true);
    DateTime? selectedDate;
    void _onPressed({
      required BuildContext context,
    }) async {

      showMonthPicker(
        context: context,
        firstDate: DateTime(2022),
        lastDate: DateTime(DateTime.now().year, DateTime.now().month),
        initialDate: selectedDate ?? DateTime.now(),
        locale: const Locale("en"),
      ).then((date) {
        if (date != null) {
          print(date);
            selectedDate = date;
            onSelected(selectedDate!);
        }
      });
    }
    return InkWell(
      onTap: () =>_onPressed(context: context),
      child: Image.asset(
        "assets/img/calendar.png",
        width: size.height < 900 ? 20 : size.height * 0.0195,
        height: size.height < 900 ? 20 : size.height * 0.0195,
      ),
    );
  }
}

// final DateTime _date = DateTime.now();
// void showPicker(context){
//   showDatePicker(
//       context: context, initialDate: _date, firstDate: DateTime(2022), lastDate: _date).then((value) => print(value));
// }



  // final selected = await showMonthYearPicker(
  //   context: context,
  //   initialDate: DateTime.now(),
  //   firstDate: DateTime(2022),
  //   lastDate: DateTime.now(),
  // );
  // final selected = await showDatePicker(
  //   context: context,
  //   initialDate: _selected ?? DateTime.now(),
  //   firstDate: DateTime(2019),
  //   lastDate: DateTime(2022),
  //   locale: localeObj,
  // );
  // if (selected != null) {
  //
  // }}