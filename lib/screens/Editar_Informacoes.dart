import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/db_helper.dart';
import '../model/user.dart';

class EditInfoScreen extends StatefulWidget {
  final int metodo; // 1 = alterar e-mail, 2 = alterar senha
  //usamos a mesma tela para editar o email e a senha
  //quando a tela é chamada passa o metodo que decide se vai editar o email ou a senha
  const EditInfoScreen(this.metodo);

  @override
  _EditInfoScreenState createState() => _EditInfoScreenState();
}

class _EditInfoScreenState extends State<EditInfoScreen> {
  // Controladores para obter o texto dos campos de entrada
  final TextEditingController _fieldController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Instancia do DBHelper
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    // Define as labels com base no valor do metodo enviado na hora de chamar a tela
    String fieldLabel = widget.metodo == 1 ? 'Novo E-mail' : 'Nova Senha';
    String passwordLabel =
        widget.metodo == 1 ? 'Confirmar E-mail' : 'Confirmar Senha';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // Desativa o comportamento automático de ícone voltar
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 40,
                weight: 500,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Text(
              'Voltar',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 24),
              child: const Text(
                'Editar Informações',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 35),
              width: 218,
              height: 218,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(73),
                image: DecorationImage(
                  image: AssetImage('assets/Amazon.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  TextField(
                    controller: _fieldController,
                    decoration: InputDecoration(
                      labelText:
                          fieldLabel, // Alterado dinamicamente com base no metodo enviado
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                  SizedBox(height: 26),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: passwordLabel,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            side: BorderSide(width: 1.5, color: Colors.black),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maximumSize: MaterialStateProperty.all(Size(500, 500)),
                        backgroundColor: MaterialStateProperty.all(
                          Color.fromRGBO(246, 182, 188, 1),
                        ),
                      ),
                      onPressed: () {
                        final user =
                            Provider.of<UserModel>(context, listen: false).user;
                        if ((_fieldController.text.isEmpty &&
                            _passwordController.text.isEmpty)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Preencha todos os campos')),
                          );
                          return;
                        } else if (_fieldController.text !=
                            _passwordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('OS campos não estão iguais')),
                          );
                          return;
                        }
                        // verifica o metodo e dependando chama a função de update no banco referente
                        if (widget.metodo == 1) {
                          try {
                            _databaseHelper.UpdateEmail(
                                user, _fieldController.text);
                            Navigator.of(context).pop('certo');
                          } catch (e) {
                            Navigator.of(context).pop('falha');
                          }
                        } else {
                          try {
                            _databaseHelper.UpdateSenha(
                                user, _passwordController.text);
                            Navigator.of(context).pop('certo');
                          } catch (e) {
                            Navigator.of(context).pop('falha');
                          }
                        }
                      },
                      child: Text(
                        'Salvar',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
