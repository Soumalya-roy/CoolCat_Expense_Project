import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internship1/view/chart.dart';
import 'package:intl/intl.dart';
import 'package:internship1/view/expensemodel.dart';

class MyExpense extends StatefulWidget {
  const MyExpense({super.key});

  @override
  State<MyExpense> createState() => _MyExpenseState();
}

class _MyExpenseState extends State<MyExpense> {
  bool is_search = false;

  var exp_title = TextEditingController();

  var exp_amount = TextEditingController();
  List<ExpenseModel> expenseList = [];

  List<ExpenseModel> expenseSearch = [];
  var SearchController = TextEditingController();

  DateTime? _date;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    _dateString() {
      if (_date == null) {
        return "No Date Choosen";
      } else {
        return "${_date?.day} - ${_date?.month} - ${_date?.year}";
      }
    }

    Widget dateButton(update_state) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(_dateString()),
          SizedBox(
            width: 30,
          ),
          ElevatedButton(
            child: const Text("Choose date 🗓️"),
            onPressed: () async {
              final DateTime? dateTime = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(3000),
              );
              if (dateTime != null) {
                update_state(() {
                  _date = dateTime!;
                });
              }
            },
          )
        ],
      );
    }

    void saveExpense() {
      var title = exp_title.text;
      //amt_text();
      double amount = double.parse(exp_amount.text);

      DateTime ddmmyyyy = _date!;
      ExpenseModel model = ExpenseModel(title, amount, ddmmyyyy);
      expenseList.add(model);
      print('added ${expenseList[expenseList.length - 1].title}');
      setState(() {});
    }

    void deleteExpense(int index) {
      expenseList.removeAt(index);
      setState(() {});
    }

    Widget expenseTile(int index) {
      return ListView(
        shrinkWrap: true,
        children: [
          ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.teal,
                child: Text(
                  "₹ ${expenseList[index].amount}",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              trailing: IconButton(
                  onPressed: () {
                    deleteExpense(index);
                  },
                  icon: Icon(
                    Icons.delete,
                    size: 20,
                    color: Colors.red,
                  )),
              title: Text(expenseList[index].title),
              subtitle: (expenseList[index].dt == null)
                  ? Text("No Date Choosen")
                  : Text(
                      "${expenseList[index].dt.day} - ${expenseList[index].dt.month} - ${expenseList[index].dt.year}")),
        ],
      );
    }

    Widget searchCard(int index) {
      return ListView(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.teal,
            child: Text(
              "₹ ${expenseSearch[index].amount}",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
              trailing: IconButton(
                  onPressed: () {
                    deleteExpense(index);
                  },
                  icon: Icon(
                    Icons.delete,
                    size: 20,
                    color: Colors.red,
                  )),
              title: Text(expenseSearch[index].title),
              subtitle: (expenseList[index].dt == null)
                  ? Text("No Date Choosen")
                  : Text(
                      "${expenseList[index].dt.day} - ${expenseList[index].dt.month} - ${expenseList[index].dt.year}")),
        ],
      );
    }

    void searchExpense(var val) {
      ExpenseModel i;
      for (i in expenseList) {
        if (i.title.contains(val)) {
          expenseSearch.add(i);
        }
      }
      setState(() {});
    }

    Widget search(TextEditingController controller) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.white,
          child: TextField(
            controller: controller,
            onChanged: (value) async {
              print('${value}');
              searchExpense(value);
            },
            style: TextStyle(
                color: Colors.white70,
                fontSize: 20,
                fontWeight: FontWeight.w600),
            decoration: InputDecoration(
                hintText: "input title",
                hintStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.black))),
          ),
        ),
      );
    }

    Widget customTextbox(TextEditingController controller, String hint) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          keyboardType:
              (hint == "Amount") ? TextInputType.number : TextInputType.text,
          onChanged: (value) async {
            print('${value}');
          },
          style: TextStyle(
              color: Colors.deepPurple,
              fontSize: 20,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.deepPurple))),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.brown,
            title: (is_search == false)
                ? Text(
                    'My Expense Tracker',
                    style: TextStyle(),
                  )
                : search(SearchController),
            actions: [
              (is_search == false)
                  ? IconButton(
                      icon: Icon(Icons.search, color: Colors.blue),
                      onPressed: () {
                        is_search = true;
                        setState(() {});
                      })
                  : IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        is_search = false;
                        setState(() {});
                      })
            ]),
        body: expenseList.length == 0
            ? Column(
                children: [
                  Chart(expenseList),
                  Center(
                    child: Text("No Expense added!!"),
                  ),
                ],
              )
            : Column(
                children: [
                  Chart(expenseList),
                  SingleChildScrollView(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: (is_search == false)
                            ? expenseList.length
                            : expenseSearch.length,
                        itemBuilder: (context, index) => (is_search == false)
                            ? expenseTile(index)
                            : searchCard(index)),
                  ),
                ],
              ),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.brown,
          onPressed: () {
            showModalBottomSheet(
                context: context,
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                builder: (context) => StatefulBuilder(
                      builder: (context, setState) => ClipRRect(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20)),
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text("Add Expense",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600)),
                                trailing: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: CircleAvatar(
                                      backgroundColor: Colors.brown,
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                    )),
                              ),
                              customTextbox(exp_title, "Title"),
                              customTextbox(exp_amount, "Amount"),
                              dateButton(setState),
                              SizedBox(
                                height: 30,
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.brown)),
                                  onPressed: () {
                                    saveExpense();
                                    Navigator.pop(context);
                                  },
                                  child: Text('Save',
                                      style: TextStyle(
                                        color: Colors.white,
                                      )))
                            ],
                          ),
                        ),
                      ),
                    ));
          },
          label: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ));
  }
}
