import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class Sessionview extends StatefulWidget {
  const Sessionview({super.key});
  @override
  _SessionviewState createState() => _SessionviewState();
}

class _SessionviewState extends State<Sessionview> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController correoControl = TextEditingController();
  final TextEditingController claveControl = TextEditingController();

  void _iniciar() {
    if (_formKey.currentState!.validate()) {
      // Simular la verificación de los datos quemados
      if (correoControl.text == 'jhandrychimbo@gmail.com' &&
          claveControl.text == '123456789') {
        // Redirige a la siguiente pantalla
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/mapa',
          (Route<dynamic> route) => false,
        );
      } else {
        // Mostrar error si los datos son incorrectos
        final SnackBar msg = SnackBar(
          content: const Text("Correo o clave incorrectos"),
        );
        ScaffoldMessenger.of(context).showSnackBar(msg);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/fondoInicio.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: SingleChildScrollView(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
                            Colors.white.withOpacity(0.1),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const Text(
                              "Map Trip",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Inicio de Sesión",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: correoControl,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Debe ingresar un correo";
                                }
                                if (!isEmail(value)) {
                                  return "Debe ingresar un correo válido";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: "Correo",
                                prefixIcon: Icon(Icons.email),
                                prefixIconColor: Colors.white,
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              obscureText: true,
                              controller: claveControl,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Debe ingresar una clave";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: "Clave",
                                prefixIcon: Icon(Icons.lock),
                                prefixIconColor: Colors.white,
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _iniciar,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.white.withOpacity(0.5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                side: const BorderSide(color: Colors.white),
                              ),
                              child: const Text(
                                "Iniciar Sesión",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
