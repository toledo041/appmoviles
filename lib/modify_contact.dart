import 'package:example_flutter/my_home_page.dart';
import 'package:flutter/material.dart';
import 'package:example_flutter/text_box.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ModifyContact extends StatefulWidget {
  final Client _client;
  ModifyContact(this._client);
  @override
  State<StatefulWidget> createState() => _ModifyContact();
}

class _ModifyContact extends State<ModifyContact> {
  TextEditingController controllerName = new TextEditingController();
  TextEditingController controllerSurname = new TextEditingController();
  TextEditingController controllerPhone = new TextEditingController();
  String idCliente = "";

  Future actualizar() async {
    try {
      var url = Uri.http("10.235.242.107:8080", '/flutter_login/actualizacontacto.php',
          {'q': '{http}'});
      var response = await http.post(url, body: {
        "name": controllerName.text,
        "surname": controllerSurname.text,
        "phone": controllerPhone.text,
        "id": idCliente //int.parse(idCliente)
      });
      var data = response.body; //json.decode(response.body);
      print("actualizo?  " + data.toString());
      if (data.toString() == "exito") {
        /*Fluttertoast.showToast(
        msg: 'Se modificó correctamente',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage("Listado de contactos"), //const()
        ),
      );*/
        Navigator.of(context).pop();
        setState(() {});
      } else {
        Fluttertoast.showToast(
          backgroundColor: Color.fromARGB(255, 240, 229, 228),
          textColor: Colors.white,
          msg: 'Hubo un problema al actualizar la información',
          toastLength: Toast.LENGTH_SHORT,
        );
        Navigator.of(context).pop();
        setState(() {});
      }
    } catch (e) {
      Fluttertoast.showToast(
        backgroundColor: Color.fromARGB(255, 240, 229, 228),
        textColor: Colors.white,
        msg: 'Hubo un problema al actualizar la información',
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.of(context).pop();
      setState(() {});
    }
  }

  @override
  void initState() {
    Client c = widget._client;
    controllerName = new TextEditingController(text: c.name);
    controllerSurname = new TextEditingController(text: c.surname);
    controllerPhone = new TextEditingController(text: c.phone);
    idCliente = c.id;
    super.initState();
    print('Id contacto ${idCliente}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modificar Contacto"),
      ),
      body: ListView(
        children: [
          TextBox(controllerName, "Nombre"),
          TextBox(controllerSurname, "Apellido"),
          TextBox(controllerPhone, "Telefono"),
          ElevatedButton(
              onPressed: () {
                String name = controllerName.text;
                String surname = controllerSurname.text;
                String phone = controllerPhone.text;

                if (name.isNotEmpty && surname.isNotEmpty && phone.isNotEmpty) {
                  actualizar();
                  /*Navigator.pop(context,
                      new Client(name: name, surname: surname, phone: phone));*/
                }
              },
              child: Text("Guardar Contacto")),
        ],
      ),
    );
  }
}
