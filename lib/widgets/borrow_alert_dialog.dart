import 'package:bookhub/components/auth_manager.dart';
import 'package:bookhub/scripts/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_books_api/google_books_api.dart';
import 'package:provider/provider.dart';

class BorrowAlertDialog extends StatefulWidget {
  final Book book;

  const BorrowAlertDialog({
    super.key,
    required this.book,
  });

  @override
  State<BorrowAlertDialog> createState() => _BorrowAlertDialogState();
}

class _BorrowAlertDialogState extends State<BorrowAlertDialog> {
  int sliderValue = 0;
  int maxSliderValue = 30;

  List<String> list = <String>['DAY', 'WEEK', 'MONTH'];
  String dropdownValue = 'DAY';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Borrow Book"),
      content: SizedBox(
        height: 200,
        child: Column(
          children: [
            const Text('How long do you want to borrow this item?'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 30,
                ),
                Text("$sliderValue"),
                DropdownButton<String>(
                    value: dropdownValue,
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        dropdownValue = value!;
                        sliderValue = 0;
                        switch (value) {
                          case 'DAYS':
                            maxSliderValue = 30;
                            break;
                          case 'WEEKS':
                            maxSliderValue = 4;
                            break;
                          case 'MONTH':
                            maxSliderValue = 12;
                            break;
                        }
                      });
                    })
              ],
            ),
            Slider(
              value: double.parse(sliderValue.toString()),
              onChanged: (double value) {
                setState(() {
                  sliderValue = value.toInt();
                });
              },
              min: 0,
              max: maxSliderValue.toDouble(),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              var userId = context.read<AuthManager>().user!.id!;
              DatabaseConnector.borrowBook(
                  userId, widget.book, sliderValue, dropdownValue);

              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const ConfirmBorrow();
                  });
            },
            child: const Text("Request for borrow"))
      ],
    );
  }
}

class ConfirmBorrow extends StatelessWidget {
  const ConfirmBorrow({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Borrow Request"),
      content: const Text(
          "Your request has been sent to the admin. Please go to the library to get the book."),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Confirm"))
      ],
    );
  }
}
