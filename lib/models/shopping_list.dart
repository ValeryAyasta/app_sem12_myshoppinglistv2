class ShoppingList{
  int id;
  String name;
  int priority;

  ShoppingList(this.id, this.name, this.priority);

  //vamos a crear el metodo toMap, para hacer el mapeo de la clase a la tabla
  Map<String, dynamic> toMap(){
    return{
      'id': (id == 0)? null : id,
      'name': name,
      'priority': priority
    };
  }
}