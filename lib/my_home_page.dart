import 'package:example_flutter/message_response.dart';
import 'package:example_flutter/modify_contact.dart';
import 'package:example_flutter/register_contact.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  final String _title;
  MyHomePage(this._title);
  @override
  State<StatefulWidget> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    consulta();
  }

  //List<Client> clients = [];
  List<Client> contactos = [];

  Future consulta() async {
    print('entra!');
    var url =
        Uri.http("10.0.0.8:8080", '/flutter_login/lista.php', {'q': '{http}'});
    var response = await http.get(url);
    var data = json.decode(response.body);
    //print(data);
    if (data != "Error") {
      contactos.clear;
      for (int i = 0; i < data.length; i++) {
        //print('hello ${data[i]['phone']}');
        contactos.add(Client(
            name: data[i]['name'],
            surname: data[i]['surname'],
            phone: data[i]['phone'],
            id: data[i]['id']));

        //print(contactos.toString());
        setState(() {}); //Con esto se redibuja el componente
      }

      //Navigator.push(
      //  context,
      //  MaterialPageRoute(
      //    builder: (context) => MyHomePage("Listado de contactos"),//const(),
      //  ),
      //);
    } else {
      Fluttertoast.showToast(
        backgroundColor: Color.fromARGB(255, 240, 229, 228),
        textColor: Colors.white,
        msg: 'No se encontro información',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  Future elimina(id) async {
    var url = Uri.http(
        "10.0.0.8:8080", '/flutter_login/borracontacto.php', {'q': '{http}'});
    var response = await http.post(url, body: {"id": id});
    var data = response.body;
    //print(data);
    if (data != "Error") {
      Fluttertoast.showToast(
        backgroundColor: Color.fromARGB(255, 240, 229, 228),
        textColor: Colors.white,
        msg: 'Registro eliminado con éxito',
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      Fluttertoast.showToast(
        backgroundColor: Color.fromARGB(255, 240, 229, 228),
        textColor: Colors.white,
        msg: 'No se pudo eliminar el registro',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
      ),
      body: ListView.builder(
        itemCount: contactos.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ModifyContact(contactos[index])))
                  .then((newContact) {
                if (newContact != null) {
                  setState(() {
                    //clients.removeAt(index);

                    //clients.insert(index, newContact);

                    messageResponse(
                        context, newContact.name + " a sido modificado...!");
                  });
                }
              });
            },
            onLongPress: () {
              removeClient(context, contactos[index]);
            },
            title: Text(contactos[index].name + " " + contactos[index].surname),
            subtitle: Text(contactos[index].phone), //(clients[index].phone
            leading: CircleAvatar(
              child: Text(contactos[index].name), //.name.substring(0, 1
            ),
            trailing: Icon(
              Icons.call,
              color: Color.fromARGB(255, 214, 67, 165),
            ),
          );
          /*setState(() {
            consulta();
          });*/
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: (_) => RegisterContact()))
              .then((newContact) {
            if (newContact != null) {
              setState(() {
                //clients.clear;
                consulta();
                /*messageResponse(
                    context, newContact.name + " a sido guardado...!");*/
              });
            }
          });
        },
        tooltip: "Agregar Contacto",
        child: Icon(Icons.add),
      ),
    );
  }

  removeClient(BuildContext context, Client client) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Eliminar Alumno"),
              content: Text("Esta seguro de eliminar a " + client.name + "?"),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      //this.clients.remove(client);
                      elimina(client.id);
                      contactos.clear();
                      consulta();
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    "Eliminar",
                    style: TextStyle(color: Colors.yellow),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancelar",
                    style: TextStyle(color: Color.fromARGB(255, 68, 159, 201)),
                  ),
                )
              ],
            ));
  }
}

class Client {
  var id;
  var name;
  var surname;
  var phone;

  Client({this.id, this.name, this.surname, this.phone});
}
