import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();

  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Caminho do banco de dados
    String path = join(await getDatabasesPath(), 'login.db');

    // Abertura do banco de dados, com versão 3
    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        // Criação da tabela 'users'
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT, senha TEXT)',
        );

        // Criação da tabela 'tarefas'
        await db.execute(
          'CREATE TABLE tarefas(id INTEGER PRIMARY KEY, titulo TEXT, descricao TEXT, data TEXT, isDone INTEGER DEFAULT 0)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {},
    );
  }

  Future<int> registerUser(String username, String senha) async {
    final db = await database;
    return await db.insert('users', {'username': username, 'senha': senha});
  }

  Future<List<ToDo>> getTarefas() async {
    print('entrei aqui');
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    final db =
        await database; // Certifique-se de que a função retorna o banco de dados
    final List<Map<String, dynamic>> maps =
        await db.query('tarefas'); // Nome correto da tabela
    print(
        "Tarefas carregadas do banco: $maps"); // Debug: imprime o resultado da consulta

    // Mapeia os resultados para a lista de ToDo
    return List.generate(maps.length, (i) {
      print(
          "Criando tarefa: ${maps[i]}"); // Debug: imprime cada item ao ser convertido
      return ToDo(
        id: maps[i]['id'].toString(),
        title: maps[i]['titulo'],
        description: maps[i]['descricao'],
        Data: dateFormat
            .parse(maps[i]['data']), // Usando DateFormat para converte
        isDone: maps[i]['isDone'] == 1, // Adaptação para booleano
      );
    });
  }

  Future<List<ToDo>> getTarefasProucura({String searchTerm = ''}) async {
    print('entrei aqui');
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    final db = await database;

    // Se houver um termo de busca, filtra as tarefas
    final List<Map<String, dynamic>> maps;
    if (searchTerm.isNotEmpty) {
      // Executa uma busca com base no título ou descrição
      maps = await db.query(
        'tarefas',
        where: 'titulo LIKE ? OR descricao LIKE ?',
        whereArgs: ['%$searchTerm%', '%$searchTerm%'],
      );
    } else {
      // Se não houver busca, retorna todas as tarefas
      maps = await db.query('tarefas');
    }

    print("Tarefas carregadas do banco: $maps");

    // Mapeia os resultados para a lista de ToDo
    return List.generate(maps.length, (i) {
      print("Criando tarefa: ${maps[i]}");
      return ToDo(
        id: maps[i]['id'].toString(),
        title: maps[i]['titulo'],
        description: maps[i]['descricao'],
        Data: dateFormat.parse(maps[i]['data']),
        isDone: maps[i]['isDone'] == 1,
      );
    });
  }

  Future checkTarefa(ToDo todo) async {
    final db = await database;
    if (todo.isDone) {
      print('entrei para deixar == 1');
      await db.update('tarefas', {'isDone': 1},
          where: 'id = ?', whereArgs: [todo.id]);
    } else {
      print('entrei para deixar == 0');
      await db.update('tarefas', {'isDone': 0},
          where: 'id = ?', whereArgs: [todo.id]);
    }
  }

  Future deleteTarefa(ToDo todo) async {
    final db = await database;
    await db.delete('tarefas', where: 'id = ?', whereArgs: [todo.id]);
  }

  Future UpdateTarefa(
      ToDo todo, String title, String descricao, String data) async {
    final db = await database;
    db.update(
        'tarefas', {'titulo': title, 'descricao': descricao, 'data': data},
        where: 'id = ?', whereArgs: [todo.id]);
  }

  Future UpdateEmail(user, String email) async {
    final db = await database;
    print('chamei a funcao');
    db.update('users', {'username': email},
        where: 'id = ?', whereArgs: [user['id']]);

    print('fiz a funcao');
  }

  Future UpdateSenha(user, String senha) async {
    final db = await database;
    db.update('users', {'senha': senha},
        where: 'id = ?', whereArgs: [user['id']]);
  }

  Future<int> criarTarefa(String titulo, String descricao, String data) async {
    final db = await database;

    // Insere a tarefa no banco de dados
    final id = await db.insert(
      'tarefas',
      {'titulo': titulo, 'descricao': descricao, 'data': data},
    );

    // Agenda a notificação para a tarefa criada
    await scheduleNotification(id, titulo, descricao, data);

    // Retorna o ID da tarefa
    return id;
  }

// Função para autenticar um usuário
  Future<Map<String, dynamic>?> loginUser(String username, String senha) async {
    final db = await database; // Obtém a instância do banco de dados

    // Consulta a tabela 'users' buscando pelo username e password correspondentes
    var result = await db.query(
      'users',
      where: 'username = ? AND senha = ?',
      whereArgs: [username, senha],
    );

    // Se houver algum resultado, retorna o primeiro registro; senão, retorna null
    return result.isNotEmpty ? result.first : null;
  }
}

class ToDo {
  String id;
  String title;
  String description;
  DateTime Data;
  bool isDone;

  ToDo({
    required this.id,
    required this.title,
    required this.description,
    this.isDone = false,
    required this.Data,
  });
}
