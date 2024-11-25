// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../model/user.dart'; // Importa o modelo de usuário
import '../screens/home.dart';
import '../database/db_helper.dart'; // Importa a classe para acesso ao banco de dados
import 'Cadastro.dart'; // Importa a tela de cadastro
import 'package:provider/provider.dart'; // Importa o Provider para gerenciamento de estado

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para os campos de texto, gerenciando a entrada do usuário.
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Instância da classe DatabaseHelper para interagir com o banco de dados.
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Função para navegar para a tela de cadastro.
  void _goToCadastroScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CadastroScreen()),
    );
  }

  // Função assíncrona para realizar o login do usuário.
  Future<void> _login() async {
    // Obtém o nome de usuário e senha digitados, removendo espaços em branco.
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    // Tenta logar o usuário usando o método loginUser do DatabaseHelper.
    var user = await _databaseHelper.loginUser(username, password);

    if (user != null) {
      // Se o usuário for encontrado, salva os dados do usuário no Provider.
      Provider.of<UserModel>(context, listen: false).setUser(user);

      // Mostra uma mensagem de sucesso ao usuário.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login bem-sucedido!')),
      );

      // Navega para a tela inicial, substituindo a tela de login na pilha de navegação.
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      // Se as credenciais forem incorretas, mostra uma mensagem de erro.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Credenciais incorretas.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Título da tela de login.
            Container(
              margin: EdgeInsets.only(top: 70, bottom: 24),
              child: const Text(
                'Entre com sua conta',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 32,
                    fontWeight: FontWeight.w500),
              ),
            ),
            // Imagem de logo.
            Container(
              margin: EdgeInsets.only(bottom: 35),
              width: 218,
              height: 218,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(73),
                  image: DecorationImage(
                      image: AssetImage('assets/Amazon.jpg'),
                      fit: BoxFit.cover)),
            ),
            // Campos de entrada para nome de usuário e senha.
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                  SizedBox(height: 26),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                    obscureText: true, // Oculta a senha.
                  ),
                  SizedBox(height: 20),
                  // Botão de login.
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            side: BorderSide(width: 1.5, color: Colors.black),
                            borderRadius: BorderRadius.circular(12))),
                        maximumSize: MaterialStateProperty.all(Size(500, 500)),
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(246, 182, 188, 1)),
                      ),
                      onPressed: _login, // Chama a função de login.
                      child: Text(
                        'Entrar',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            // Link para a tela de cadastro.
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Não possui uma conta? '),
                TextButton(
                  onPressed: _goToCadastroScreen, // Chama a tela de cadastro
                  child: Text('Cadastre-se'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Limpa os controladores de texto após o término da tela.
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
