import 'package:flutter/material.dart';
import '../database/db_helper.dart'; // Importa a classe para acesso ao banco de dados
import 'package:intl/intl.dart'; // Importa a biblioteca para formatação de datas
import 'package:intl/date_symbol_data_local.dart'; // Necessário para customizar a formatação de data

// Define um formato de data globalmente (pode ser melhor colocado em outro local)
DateFormat dateFormat = DateFormat("dd/MM/yyyy");

class TodoItem extends StatelessWidget {
  // Variável que representa a tarefa a ser exibida.
  final ToDo todo;

  // Funções de callback para atualizar o estado da tarefa.
  final Function onTodoChange;
  final Function onDeleteItem;
  final Function onEditItem;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onDeleteItem,
    required this.onEditItem,
    required this.onTodoChange,
  });

  @override
  Widget build(BuildContext context) {
    // Inicializa a formatação de data para o idioma local.
    initializeDateFormatting();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        // Ao tocar no ListTile, chama a função onTodoChange, provavelmente para marcar como concluído.
        onTap: () {
          onTodoChange(todo);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tileColor: const Color.fromRGBO(251, 216, 220, 1),
        contentPadding: const EdgeInsets.symmetric(
            vertical: 4, horizontal: 15), // Padding reduzido para melhor layout
        leading: Icon(
          // Icone de check para tarefas concluídas, ou check box vazio caso contrário.
          todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: const Color.fromARGB(255, 89, 89, 250),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título da tarefa, com risco caso esteja concluída.
            Text(
              todo.title,
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: todo.isDone ? TextDecoration.lineThrough : null),
            ),
            const SizedBox(height: 5),
            // Descrição da tarefa, com risco caso esteja concluída.
            Text(
              todo.description,
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  decoration: todo.isDone ? TextDecoration.lineThrough : null),
            ),
            SizedBox(height: 12),
            // Data da tarefa, alinhada à esquerda, com risco caso esteja concluída.
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                DateFormat('dd MMMM yyyy', 'pt_BR').format(todo.Data),
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    decoration:
                        todo.isDone ? TextDecoration.lineThrough : null),
              ),
            ),
          ],
        ),
        titleAlignment: ListTileTitleAlignment.top,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icone para editar a tarefa.
            GestureDetector(
              onTap: () {
                onEditItem(todo);
              },
              child: const Icon(Icons.edit),
            ),
            const SizedBox(width: 8),
            // Icone para deletar a tarefa.
            GestureDetector(
              onTap: () {
                onDeleteItem(todo);
              },
              child: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
