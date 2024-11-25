// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_tentativa_1/widgets/date.pick.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import '../database/db_helper.dart';

// Classe de serve de modelo para a tarefa na hora de passar para o banco
class Task {
  final String title;
  final String description;

  Task({required this.title, required this.description});
}

class CreateTaskScreen extends StatefulWidget {
  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  //intanciando o DBHelper
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  //criando os controladores para os TextField
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final oi = TextEditingController();

//função para fazer a criação da Tarefa e criar ela nobanco de dados
  void _saveTask() {
    //variaveis para pegar a String dos controladores
    final String title = _titleController.text;
    final String description = _descriptionController.text;
    final String data = oi.text;

    //Verifica se todos os campos foram preenchidos
    if (title.isEmpty || description.isEmpty || data.isEmpty) {
      // Exibe uma mensagem de erro caso algum campo esteja vazio
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    // Cria uma nova tarefa baseado no modelo
    final newTask = Task(title: title, description: description);

    //try para tentar chamar a função de insert no banco e salvar a tarefa
    try {
      _databaseHelper.criarTarefa(title, description, data);
    } catch (e) {
      SnackBar(content: Text('erro ao salvar tarefa'));
    }

    // Limpa os campos de texto após salvar
    _titleController.clear();
    _descriptionController.clear();

    // Exibe uma mensagem de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tarefa criada com sucesso!')),
    );

    // Fecha a tela após salvar a tarefa
    Navigator.of(context).pop(newTask);
  }

  @override
  // limpa as variaveis de controladores da memória
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(251, 216, 220, 1),
        automaticallyImplyLeading:
            false, // Desativa o comportamento automático de ícone de oltar do appbar
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //cria o icone de voltar do appbar
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 40,
                weight: 500,
              ),
              onPressed: () {
                // faz a ação de voltar para a tela HOME
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
      //troca a cor de fundo do corpo da tela
      backgroundColor: Color.fromRGBO(251, 216, 220, 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //TextField para o título
            TextField(
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              controller: _titleController,
              //estilo do textField
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                hintText: 'Título',
                hintStyle: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
                //começa a trocar todas as bordas possiveis
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 4, // Espessura da borda quando habilitado
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.white, // Cor da borda quando em foco
                    width: 4, // Espessura da borda em foco
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 4, // Espessura da borda quando desabilitado
                  ),
                ),
              ),
            ),
            SizedBox(height: 4),
            //expanded para deixar o textField de descrição do tamanho da tela
            Expanded(
              //Textfield de descrição
              child: TextField(
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                controller: _descriptionController,
                textAlignVertical: TextAlignVertical.top,
                expands: true,
                maxLines: null,
                minLines: null,
                //estilo do textField
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  hintText: 'Descrição',
                  hintStyle: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Roboto',
                    color: Colors.black,
                  ),
                  //Começa a trocar todas as ordas possiveis
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 4, // Espessura da borda quando habilitado
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Colors.white, // Cor da borda quando em foco
                      width: 4, // Espessura da borda em foco
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 4, // Espessura da borda quando desabilitado
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 4),
            //chama o widget perssonalizado de data passando o controlador
            DatePickerField(datecontroll: oi),

            //botão para salval a tarefa
            ElevatedButton(
                //onpressed para chamar a função de salvar a tarefa
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    SizedBox(width: 15),
                    Text('Salvar Tarefa',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
