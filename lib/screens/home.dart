// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_tentativa_1/screens/Config.dart';
import '../database/db_helper.dart';
import '../widgets/todo-item.dart';
import 'Create.dart';
import 'Edit.dart';

final DatabaseHelper _databaseHelper = DatabaseHelper();

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // cria um list de tarefas como promessa para montar a tela
  String searchQuery = '';
  late Future<List<ToDo>> tarefas = Future.value([]);
  late TextEditingController _controller;

  @override

  //estado inicial onde vai ser carregado as tarefas do banco
  void initState() {
    _controller = TextEditingController(); // Inicializa o controller
    super.initState();
    carregarTarefas(); // Chama o método para carregar as tarefas
  }

  //função que chama o get tarefas do DB helper
  void carregarTarefas() {
    setState(() {
      tarefas = _databaseHelper
          .getTarefas(); // Atualiza o estado com os dados do banco
    });
  }

  void _pesquisatarefas() async {
    final result =
        await _databaseHelper.getTarefasProucura(searchTerm: searchQuery);
    setState(() {
      tarefas = Future.value(
          result); // Garante que tarefas seja um Future<List<ToDo>>
    });
  }

  void _onSearch(String searchText) {
    setState(() {
      searchQuery = searchText; // Atualiza o termo de pesquisa
    });
    _pesquisatarefas(); // Carrega as tarefas com o filtro de busca
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //constroi o app bar separado
      appBar: _biuldAppBar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: Column(
              children: [
                searchBox(_onSearch), // Adicionar a pesquisa
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  //aqui monta as tarefas na tela
                  //vasculha a lista de tarefas
                  child: FutureBuilder<List<ToDo>>(
                    future: tarefas,
                    builder: (context, snapshot) {
                      //tela de carregamento enquanto proucura as tarefas
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      //mensagem de erro se der algo de errado proucurando as tarefas
                      if (snapshot.hasError) {
                        return Center(
                            child: Text(
                                "Erro ao carregar tarefas: ${snapshot.error}"));
                      }
                      //mensagem de não encontrar tarefas
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text("Nenhuma tarefa encontrada"));
                      }
                      //adiciona as tarefas na lista criada
                      List<ToDo> tarefasList = snapshot.data!;

                      // Utilizando ListView.builder para construir as tarefas
                      return ListView.builder(
                        itemCount: tarefasList.length,
                        itemBuilder: (context, index) {
                          //usa o widget perssonalizado para cada tarefa
                          return TodoItem(
                            todo: tarefasList[index],
                            onTodoChange: _handleToDoChange,
                            onDeleteItem: _deleteToDoItem,
                            onEditItem: _editToDoItem,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          //montando o potão de adicionar nova tarefa
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20, right: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(242, 143, 153, 1),
                      padding: const EdgeInsets.all(0),
                      elevation: 10,
                      minimumSize: const Size(60, 60),
                    ),
                    onPressed: () async {
                      // Navega para a tela de criação de tarefas
                      final newTask = await Navigator.push<Task>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateTaskScreen(),
                        ),
                      );
                      if (newTask != null) {
                        carregarTarefas(); // Recarrega as tarefas ao voltar
                      }
                    },
                    child: const Text(
                      '+',
                      style: TextStyle(
                          fontSize: 40,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//metodo para trocar a marcação de tarefa feita
  void _handleToDoChange(ToDo todo) {
    setState(() {
      //troca o isDone da tarefa no banco
      _databaseHelper.checkTarefa(todo);
      //altera a tarefa dinamicamente para o usuário
      todo.isDone = !todo.isDone;
    });
  }

//metodo para fazer a exclusão da tarefa
  void _deleteToDoItem(ToDo todo) {
    setState(() {
      //chama um showdialog para o usuario confirmar se deseja excluir
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Confirmação de exclusão'),
          content: const Text('Deseja confirmar a exclusão da tarefa?'),
          actions: <Widget>[
            TextButton(
              //se o usuario cancelar so fecha o dialog
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => {
                //se clicar em confirmar chama a função do DBhelper para fazer a exclusão no anco
                Navigator.pop(context, 'Confirmar'),
                _databaseHelper.deleteTarefa(todo),
                setState(() {
                  //remove a tarefa da lista para o usuário er oque foi feito
                  tarefas = tarefas.then((tarefasList) {
                    tarefasList.remove(todo);
                    return tarefasList;
                  });
                })
              },
              child: const Text('Confirmar'),
            ),
          ],
        ),
      );
    });
  }

  //metodo para chamar a tela de edição chamando a tarefa desejada
  void _editToDoItem(ToDo todo) async {
    await Navigator.push<Task>(
        context,
        MaterialPageRoute(
          //chama a tela de edção de tarefas e passa o o bjeto referente a tarefa selecionada
          builder: (context) => EditTaskScreen(
            todo: todo,
          ),
        ));
    carregarTarefas();
  }

  Widget searchBox(Function(String) onSearch) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(251, 216, 220, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _controller, // Passa o controller aqui
        onChanged: (text) {
          onSearch(text); // Chama a função onSearch toda vez que o texto mudar
        },
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: Color.fromARGB(255, 0, 0, 0),
            size: 25,
          ),
          prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 30),
          border: InputBorder.none,
          hintText: 'buscar',
        ),
      ),
    );
  }

  AppBar _biuldAppBar() {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      title: Row(
        children: [
          //cria o icone para a tela de configurações
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
            child: Icon(
              Icons.menu,
              color: Color.fromARGB(255, 0, 0, 0),
              size: 30,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
          const Text(
            'To-do List',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 32,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
