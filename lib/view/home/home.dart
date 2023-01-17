import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sfeflutter/view/login/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sfeflutter/view/clientes/clientes.dart';
import 'package:sfeflutter/view/factura/factura.dart';
import 'package:sfeflutter/view/productos/productos.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SharedPreferences? sharedPreferences;
  var name = '';
  var email = '';
  var jsonResponse = null;
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    getuser();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences!.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
          (Route<dynamic> route) => false);
    }
  }

  getuser() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences!.getString("token") != null) {
      var response = await http
          .get(Uri.parse("http://10.0.2.2:8000/api/userprofile"), headers: {
        "Authorization": "Bearer ${sharedPreferences!.getString("token")}"
      });
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        print('Response body: ${response.body}');
        setState(() {
          name = jsonResponse['user']['name'];
          email = jsonResponse['user']['email'];
        });
      } else {
        setState(() {
          name = '';
          email = '';
        });
        print(response.body);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenidos", style: TextStyle(color: Colors.white)),
      ),
      body: Center(child: Text("Main Page")),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(name),
              accountEmail: Text(email),
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
                sharedPreferences!.clear();
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
            // new ListTile(
            //   title: new Text("Add data"),
            //   trailing: new Icon(Icons.fitness_center),
            //   onTap: () => Navigator.of(context).push(new MaterialPageRoute(
            //     builder: (BuildContext context) => AddData(),
            //   )),
            // ),
            // new Divider(),
            // new ListTile(
            //   title: new Text("Mostrar listado"),
            //   trailing: new Icon(Icons.help),
            //   onTap: () => Navigator.of(context).push(new MaterialPageRoute(
            //     builder: (BuildContext context) => ShowData(),
            //   )),
            // ),
          ],
        ),
      ),
    );
  }
}
