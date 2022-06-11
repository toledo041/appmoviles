import 'package:example_flutter/my_home_page.dart';
import 'package:example_flutter/text_box.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'my_home_page.dart';

class RegisterContact extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterContact();
}


class _RegisterContact extends State<RegisterContact> {
  TextEditingController controllerName = new TextEditingController();
  TextEditingController controllerSurname = new TextEditingController();
  TextEditingController controllerPhone = new TextEditingController();

Future registrar() async {
    var url =
        Uri.http("10.0.0.8:8080", '/flutter_login/registrarcontacto.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "name": controllerName.text,
      "surname": controllerSurname.text,
	  "phone": controllerPhone.text,
	  
    });
    var data = response.body; //json.decode(response.body);
    if (data.toString() == "exito") {
      Fluttertoast.showToast(
        msg: 'Se agrego correctamente',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage("Listado de contactos"),//const()
        ),
      );
    } else {
      Fluttertoast.showToast(
        backgroundColor: Color.fromARGB(255, 240, 229, 228),
        textColor: Colors.white,
        msg: 'Nombre de usuario y contraseña inválidos',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }


  @override
  void initState() {
    controllerName = new TextEditingController();
    controllerSurname = new TextEditingController();
    controllerPhone = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Registrar Contactos"),
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

                  if (name.isNotEmpty &&
                      surname.isNotEmpty &&
                      phone.isNotEmpty) {
					  registrar();
                   //Navigator.pop(context,
                     //   new Client(name: name, surname: surname, phone: phone));
                  }
                },
                child: Text("Guardar Contacto")),
          ],
        ));
  }
}
