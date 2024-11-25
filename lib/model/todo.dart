class ToDos {
  String id;
  String title;
  String description;
  DateTime Data;
  bool isDone;

  ToDos({
    required this.id,
    required this.title,
    required this.description,
    this.isDone = false,
    required this.Data,
  });
  static List<ToDos> todoList() {
    return [
      ToDos(
          id: '01',
          title: 'Tarefa 1',
          description: 'Primeira tarefa',
          Data: DateTime(2024, 10, 14)),
      ToDos(
        id: '02',
        title: 'Tarefa 2',
        description: 'Segunda tarefa',
        Data: DateTime(2024, 10, 14),
        isDone: true,
      ),
      ToDos(
        id: '03',
        title: 'Tarefa 3',
        description: 'Terceira tarefa',
        Data: DateTime(2024, 10, 14),
        isDone: true,
      ),
    ];
  }
}
