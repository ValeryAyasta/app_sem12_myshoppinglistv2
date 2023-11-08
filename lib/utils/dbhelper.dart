import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:app_sem12_myshoppinglistv2/models/list_items.dart';
import 'package:app_sem12_myshoppinglistv2/models/shopping_list.dart';

//creo la clase DbHelper
class DbHelper{
  //creo una constante para la versión de la BD
  final int version = 1;

  //creo un objeto de la clase Database
  //esta clase es de sqflite
  Database? db;

  //codigo para que siempre solo se abra 1 instancia de la BD --> la misma

  static final DbHelper dbHelper = DbHelper.internal();
  DbHelper.internal();

  factory DbHelper(){
    return dbHelper;
  }


  //Ahora creo la clase "openDb"
  Future<Database> openDb() async{
    //y aqui hacemos una pregunta fundamental
    //no existe la BD?
    if (db == null){
      //si es Verd., creamos la BD y sus tablas
      //vamos a implementar este codigo
      db = await openDatabase(join(await getDatabasesPath(),
          'shoppingv1.db'),
          onCreate: (database, version){
            database.execute('CREATE TABLE lists(id INTEGER PRIMARY KEY, name TEXT, priority INTEGER)');

            //creo la 2da tabla
            database.execute('CREATE TABLE items(id INTEGER PRIMARY KEY, idList INTEGER,'
                'name TEXT, quantity TEXT, note TEXT, FOREIGN KEY(idList) REFERENCES lists(id))');
          }, version: version);
    }
    //no tiene else
    return db!; //--> Siempre se devuelve la BD
  }

  Future testDB() async{
    //llamo a openDb
    db = await openDb();

    //inserto valores en las tablas
    await db!.execute('INSERT INTO lists VALUES(0, "Monitores", 1)');
    await db!.execute('INSERT INTO lists VALUES(1, "Impresoras", 3)');
    await db!.execute('INSERT INTO items VALUES(0, 0, "Monitor LG", "6 Unds", "De 21 pulgs.")');

    //Mostramos los valores (usamos el método rawQuery)
    //Pasamos los valores a una lista
    List list = await db!.rawQuery('SELECT * FROM lists');
    List item = await db!.rawQuery('SELECT * FROM items');

    //Mostramos los valores en "consola"
    print(list[0]);
    print(list[1]);
    print(item[0]);
  }

  //metodo paara hacer insert en la tabla lists
  Future<int> insertList(ShoppingList list) async{
    int id = await this.db!.insert(
        'lists', list.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace); //es super IMPORTANTE

    return id;
  }

  //metodo paara hacer insert en la tabla items
  Future<int> insertItem(ListItem item) async{
    int id = await this.db!.insert(
        'items', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace); //es super IMPORTANTE

    return id;
  }

  //metodo para listar los registros de la tabla lists
  Future<List<ShoppingList>> getLists() async{
    final List<Map<String, dynamic>> maps = await db!.query('lists');

    return List.generate(maps.length, (i){
      return ShoppingList(
        maps[i] ['id'],
        maps[i] ['name'],
        maps[i] ['priority'],
      );
    });
  }
}