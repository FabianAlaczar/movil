import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_web_auth/flutter_web_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  static const clientId = '1298845828559147038'; // Reemplaza con tu Client ID
  static const clientSecret =
      '1298845828559147038'; // Reemplaza con tu Client Secret
  static const redirectUri =
      'Mi-Project-Rofa://oauth/callback'; // Reemplaza con tu Redirect URI

  void _login() {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    String username = _usernameController.text;
    String password = _passwordController.text;

    // Usuario estático
    if (username == 'Fabian Alcazar' && password == '12345678') {
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Usuario o contraseña incorrectos';
      });
    }
  }

  Future<void> _loginWithDiscord() async {
    final url =
        'https://discord.com/api/oauth2/authorize?client_id=$clientId&redirect_uri=$redirectUri&response_type=code&scope=identify%20email';

    try {
      final result = await FlutterWebAuth.authenticate(
          url: url, callbackUrlScheme: "YOUR_CALLBACK_SCHEME");
      final code = Uri.parse(result).queryParameters['code'];

      final response = await http.post(
        Uri.parse('https://discord.com/api/oauth2/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'client_id': clientId,
          'client_secret': clientSecret,
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': redirectUri,
        },
      );

      if (response.statusCode == 200) {
        final tokenData = json.decode(response.body);
        // Maneja el token y muestra el mensaje de éxito
        setState(() {
          _errorMessage = 'Inicio de sesión con Discord exitoso';
        });
        // Navega a HomeScreen después de un inicio de sesión exitoso
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _errorMessage = 'Error al iniciar sesión con Discord';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al iniciar sesión con Discord';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenido',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 50),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Usuario',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      ElevatedButton(
                        onPressed: _login,
                        child: Text('Iniciar Sesión'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.deepPurple,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: _loginWithDiscord,
                        icon: Icon(Icons.discord, color: Colors.white),
                        label: Text('Iniciar Sesión con Discord'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
