import 'package:app_sem12_myshoppinglistv2/ui/shopping_list_dialog.dart';
import 'package:flutter/material.dart';
import 'package:app_sem12_myshoppinglistv2/utils/dbhelper.dart';
import 'package:app_sem12_myshoppinglistv2/models/shopping_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ShowList(),
    );
  }
}

class ShowList extends StatefulWidget {
  const ShowList({super.key});

  @override
  State<ShowList> createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {
  DbHelper helper = DbHelper();
  List<ShoppingList> shoppingList = [];

  ShoppingListDialog? dialog;
  @override
  void initState(){
    dialog = ShoppingListDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showData();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping List"),
      ),
      body: ListView.builder(
          itemCount: (shoppingList.isEmpty) ? 0 : shoppingList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(shoppingList[index].name),
              leading: CircleAvatar(
                child: Text(shoppingList[index].priority.toString()),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: (){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => dialog!.buildDialog(context, shoppingList[index], false)
                  );
                },
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
              context: context,
              builder: (BuildContext context) => dialog!.buildDialog(context, ShoppingList(0, '', 0), true)
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future showData() async {
    await helper.openDb();
    shoppingList = await helper.getLists();
    setState(() {
      shoppingList = shoppingList;
    });
  }
}
