import 'package:app_sem12_myshoppinglistv2/models/shopping_list.dart';
import 'package:flutter/material.dart';
import '../utils/dbhelper.dart';

class ShoppingListDialog{
  //bool isNew
  //-> false:edit
  //--> true: new

  final txtName = TextEditingController();
  final txtPriority = TextEditingController();

  Widget buildDialog(BuildContext context, ShoppingList list, bool isNew ){
    DbHelper helper = DbHelper();
    if (!isNew){
      txtName.text = list.name;
      txtPriority.text = list.priority.toString();
    }
    else{
      txtName.text = "";
      txtPriority.text = "";
    }

    return AlertDialog(

      title: Text((isNew) ? "New Shopping List" : "Edit Shopping List"),
      content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: txtName,
                decoration: const InputDecoration(
                  hintText: "Shopping list name"
                ),
              ),
              TextField(
                controller: txtPriority,
                decoration: const InputDecoration(
                  hintText: "Shopping List priority (1-3)"
                ),
              ),
              ElevatedButton(
                  onPressed: (){
                    list.name = txtName.text;
                    list.priority = (int.parse(txtPriority.text));

                    helper.insertList(list);
                    Navigator.pop(context);
                  },
                  child: const Text("Save Shopping List")
              )
            ],
          ),
      ),
    );
  }

}