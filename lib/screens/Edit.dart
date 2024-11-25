import 'package:flutter/material.dart';
import 'package:flutter_tentativa_1/widgets/date.pick.dart';
import '../database/db_helper.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

// Tela de edição de tarefas
class EditTaskScreen extends StatefulWidget {
  final ToDo todo;
  // a classe precisa do parametro da tarefa seja passado para saer oque vai ser editado
  EditTaskScreen({required this.todo}); // Recebendo a tarefa que será editada

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  //instancio o DBHELPER
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  //cria os controladores dos TextFields
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final oi = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Preencher os campos com os valores atuais da tarefa passada
    _titleController.text = widget.todo.title;
    _descriptionController.text = widget.todo.description;
  }

  // função para dar update da tarefa no banco
  void _saveTask() async {
    //cria variaveis para pegar as Strings dos controladores dos TextFields
    final String title = _titleController.text;
    final String description = _descriptionController.text;
    final String data = oi.text;
    //Verifica se todos os campos foram preenchidos
    if (title.isEmpty || description.isEmpty || data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }
    //tenta fazer o update chamando a função do DBHELPER
    try {
      await _databaseHelper.UpdateTarefa(widget.todo, title, description, data);
      // Mensagem de sucesso,
      print('Estou');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tarefa atualizada com sucesso!')),
      );
      // Fechar a tela e retornar à anterior

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Falha ao atualizar tarefa')));
    }
  }

  @override
  //limpa as variaveis controladores da memoria
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //inicializa o DateFormatting para receber a data que foi gravada e passar para o formato certo
    initializeDateFormatting();
    //define o formato que queremos na data e converte para String
    var dateString = DateFormat('dd/MM/yyyy').format(widget.todo.Data);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(251, 216, 220, 1),
        automaticallyImplyLeading:
            false, // Desativa o comportamento automático de ícone de voltar
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
                //volta para a tela home
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
      //altera a cor do background do corpo da tela
      backgroundColor: Color.fromRGBO(251, 216, 220, 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //TextField do Titulo
            TextField(
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              controller: _titleController,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                hintText: 'Título',
                hintStyle: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
                //Estilo de todas as bordas possiveis
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
            //expanded para deixar o TextField da descrição com o tamanho da tela
            Expanded(
              //textField da descrição
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
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  hintText: 'Descrição',
                  hintStyle: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Roboto',
                    color: Colors.black,
                  ),
                  ////Estilo de todas as bordas possiveis
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
            //chama o widget perssonalizado de data e passa o controlador e a data no formato corrigido
            DatePickerField(datecontroll: oi, data: dateString),
            //Botão para salvar a atarefa
            ElevatedButton(
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
