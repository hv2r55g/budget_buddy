import 'package:flutter/material.dart';


class WeeklyButton extends StatefulWidget {
  const WeeklyButton({Key? key}) : super(key: key);

  @override
  _WeeklyButtonState createState() => _WeeklyButtonState();
}

class _WeeklyButtonState extends State<WeeklyButton> {

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
      child: Text('Weekly'),
    );
  }
}