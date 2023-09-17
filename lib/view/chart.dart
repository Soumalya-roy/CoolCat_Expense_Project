import 'package:flutter/material.dart';
import 'package:internship1/view/chartbar.dart';
import 'package:internship1/view/expensemodel.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<ExpenseModel> recentExpense;
  Chart(this.recentExpense);

  List<Map<String, Object>> get groupedTransactionValues {
    print("My recent expense ${this.recentExpense}");
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;
      print("length ${recentExpense.length}");
      for (var i = 0; i < recentExpense.length; i++) {
        if (recentExpense[i].dt.day == weekDay.day &&
            recentExpense[i].dt.month == weekDay.month &&
            recentExpense[i].dt.year == weekDay.year) {
          totalSum += recentExpense[i].amount;
          print("money = ${totalSum}");
        }
      }
      return {
        "day": DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + double.parse(item['amount'].toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data['day'].toString(),
                double.parse(data['amount'].toString()),
                totalSpending == 0.0
                    ? 0.0
                    : (data['amount'] as double) / totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
