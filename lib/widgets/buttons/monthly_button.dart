import 'package:flutter/material.dart';


class MonthlyButton extends StatefulWidget {
  const MonthlyButton({Key? key}) : super(key: key);

  @override
  _MonthlyButtonState createState() => _MonthlyButtonState();
}

class _MonthlyButtonState extends State<MonthlyButton> {

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
      child: Text('Monthly'),
    );
  }
}