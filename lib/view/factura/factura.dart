import 'package:flutter/material.dart';
import 'package:sfeflutter/view/login/login.dart';
import 'package:sfeflutter/view/components/background.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sfeflutter/view/clientes/clientes.dart';
import 'package:sfeflutter/view/productos/productos.dart';

class FacturaScreen extends StatefulWidget {
  @override
  _FacturaPageState createState() => _FacturaPageState();
}

class _FacturaPageState extends State<FacturaScreen> {
  final TextEditingController serie = new TextEditingController();
  final TextEditingController number = new TextEditingController();
  final TextEditingController cliente = new TextEditingController();
  final TextEditingController fecha = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenidos", style: TextStyle(color: Colors.white)),
      ),
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: const Text(
                "FACTURA",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2661FA),
                    fontSize: 36),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: serie,
                decoration: InputDecoration(labelText: "Serie"),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: number,
                decoration: InputDecoration(labelText: "N° Documento"),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: cliente,
                decoration: InputDecoration(labelText: "Cliente"),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: fecha,
                decoration: InputDecoration(labelText: "Fecha de Emision"),
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: ElevatedButton(
                onPressed: serie.text == "" ||
                        number.text == "" ||
                        cliente.text == "" ||
                        fecha.text == ""
                    ? null
                    : () {
                        newregister(
                            serie.text, number.text, cliente.text, fecha.text);
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  fixedSize: Size(size.width * 0.5, 50.0),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  side: const BorderSide(color: Colors.transparent),
                  elevation: 12,
                  shape: const StadiumBorder(),
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  width: size.width * 0.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80.0),
                      gradient: const LinearGradient(colors: [
                        Color.fromARGB(255, 255, 136, 34),
                        Color.fromARGB(255, 255, 190, 78)
                      ])),
                  padding: const EdgeInsets.all(0),
                  child: const Text(
                    "REGISTER",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('name'),
              accountEmail: Text('email'),
              // decoration: new BoxDecoration(
              //   image: new DecorationImage(
              //     fit: BoxFit.fill,
              //    // image: AssetImage('img/estiramiento.jpg'),
              //   )
              // ),
            ),
            ListTile(
              leading: Icon(
                Icons.analytics_outlined,
                size: 30,
                color: Colors.blue,
              ),
              title: const Text(
                'Facturas',
                style: TextStyle(fontSize: 16, color: Color(0XFF2661FA)),
              ),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => FacturaScreen()),
                    (Route<dynamic> route) => false);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.dashboard_customize_outlined,
                size: 30,
                color: Colors.blue,
              ),
              title: const Text(
                'Clientes',
                style: TextStyle(fontSize: 16, color: Color(0XFF2661FA)),
              ),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => ClientesScreen()),
                    (Route<dynamic> route) => false);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.production_quantity_limits,
                size: 30,
                color: Colors.blue,
              ),
              title: const Text(
                'Productos',
                style: TextStyle(fontSize: 16, color: Color(0XFF2661FA)),
              ),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => ProductosScreen()),
                    (Route<dynamic> route) => false);
              },
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen()),
                    (Route<dynamic> route) => false);
              },
              icon: Icon(
                Icons.logout,
                color: Colors.blue,
              ), //icon data for elevated button
              label: Text(
                "Log Out",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade50,
                side: const BorderSide(color: Colors.transparent),
                elevation: 0,
              ), //label text
            ),
          ],
        ),
      ),
    );
  }

  newregister(String name, number, String email, password) async {
    Map data = {
      'name': name,
      'email': email,
      'password': password,
    };

    var jsonResponse = null;

    var response = await http.post(
      Uri.parse("http://10.0.2.2:8000/api/register"),
      body: data,
    );

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (jsonResponse != null) {
        /*setState(() {
          _isLoading = false;
        });*/
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
            (Route<dynamic> route) => false);
      }
    } else {
      print(response.body);
    }
  }
}
