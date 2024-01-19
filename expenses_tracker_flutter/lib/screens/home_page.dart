//import 'dart:ffi';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:expenses_tracker/controller/expense_manager.dart';
import 'package:expenses_tracker/model/expenses_model.dart';
import 'package:expenses_tracker/model/total_price_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MainPage extends StatelessWidget {
  late ExpenseManager _expenseManager;
  MainPage({Key? key}) : super(key: key) {
    this._expenseManager = ExpenseManager();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MainPageState(this._expenseManager, title: 'Expense tracker'),
    );
  }
}

class MainPageState extends StatefulWidget {
  late String title;
  late ExpenseManager _expenseManager;
  MainPageState(ExpenseManager expenseManager, {Key? key, required String title}) : super(key: key) {
    this.title = title;
    this._expenseManager = expenseManager;
  }
  
  @override
  State<MainPageState> createState() => _MainPageState(_expenseManager);
}

class _MainPageState extends State<MainPageState> {
  late ExpenseManager _expenseManager;

  _MainPageState(ExpenseManager expenseManager) {
    this._expenseManager = expenseManager;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem<int>(
                value: 0,
                child: Text("Expense stats"),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text("Settings"),
              ),
            ];
          }, onSelected: (value) {
            if (value == 0) {
              print("Expense stats.");
            } else if (value == 1) {
              print("Settings");
            }
          })
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                Row(
                  children: [
                    FutureBuilder(future:  _expenseManager.moneySpentMonth, builder: _constructTotalMoneySpentThisMonth),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                Container(
                  height: 200,
                  width: 500,
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent), borderRadius: BorderRadius.all(Radius.circular(20),)),
                  child: FutureBuilder(future:  _expenseManager.totalPriceList, builder: _constructExpensesChart),
                ),
                Row(
                  children: [
                    Text("Add new expense"),
                    FloatingActionButton(
                      onPressed: () {
                       // HomePageController hpc = HomePageController();
                        _expenseManager.createExpense();
                      },
                      tooltip: "Add expense",
                      child: const Icon(Icons.add),
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                Divider(
                  height: 20,
                  thickness: 5,
                  indent: 20,
                  endIndent: 20,
                  color: Colors.blueAccent,
                ),
                Text("Expense list"),
                Container(
                  height: 200,
                  width: 300,
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent), borderRadius: BorderRadius.all(Radius.circular(20),)),
                  child: FutureBuilder(future:  _expenseManager.expenseList, builder: _constructExpenseList),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // create list of expense from response received from web service
  Widget _constructExpenseList(BuildContext context, AsyncSnapshot<List<Expense>> snapshot) {

    if(snapshot.hasData != true) {
      return Text('Fetching data');
    }
    return ListView.builder(
               itemCount: snapshot.data!.length,
               itemBuilder: (context, index) {
                 return ListTile(title: Text("Expense: ${snapshot.data![index].name}"),
                                 onTap: () {
                                   print("Show ${snapshot.data![index].name} details");
                                 },);
             },
           );
  }

  // create text showing total money spent this month
  Widget _constructTotalMoneySpentThisMonth(BuildContext context, AsyncSnapshot<double> snapshot) {

    if(snapshot.hasData != true) {
      return Text('Fetching total money spent this month');
    }
    return Text("Total spent: ${snapshot.data!}");
  }

  // create chart based on expenses category and expense price
  Widget _constructExpensesChart(BuildContext context, AsyncSnapshot<List<TotalPrice>> snapshot) {

    if(snapshot.hasData != true) {
      return Text('Fetching data from server');
    }
    return SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(text: 'Total money per category'),
              // Enable legend
              legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries<TotalPrice, String>>[
                ColumnSeries<TotalPrice, String>(
                    dataSource: snapshot.data!,
                    xValueMapper: (TotalPrice totalPrice, _) => totalPrice.name,
                    yValueMapper: (TotalPrice totalPrice, _) => totalPrice.total,
                    name: 'Price/Category',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true))
              ]);
  }


}
