import 'package:flutter/material.dart';


class PeriodButton extends StatefulWidget {
  const PeriodButton({Key? key}) : super(key: key);

  @override
  _PeriodButtonState createState() => _PeriodButtonState();
}

class _PeriodButtonState extends State<PeriodButton> {

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.focused))
                return Colors.red;
              return null; // Defer to the widget's default.
            }
        ),
      ),
      onPressed: () { },
      child: Text('Period'),
    );
  }
}