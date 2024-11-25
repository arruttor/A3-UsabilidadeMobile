import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'screens/login.dart';
import 'model/user.dart';

// Instância global do plugin de notificações
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o timezone
  tz.initializeTimeZones();

  // Configuração inicial do plugin de notificações
  await _initializeNotifications();

  // Obtém preferências de tema
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (_) => UserModel(),
      child: MainApp(isDarkMode: isDarkMode),
    ),
  );
}

// Configuração do plugin de notificações
Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: androidSettings);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

// Torne a função `scheduleNotification` global
Future<void> scheduleNotification(
    int id, String title, String description, String date) async {
  // Converte a data String (dd/MM/yyyy) para DateTime
  final dateParts = date.split('/');
  final DateTime taskDate = DateTime(
    int.parse(dateParts[2]),
    int.parse(dateParts[1]),
    int.parse(dateParts[0]),
    9, // Define a hora para 9:00 AM
  );

  // Verifica se a data da tarefa já passou
  if (taskDate.isBefore(DateTime.now())) {
    print('A data da tarefa já passou.');
    return; // Não agenda a notificação se a data já passou
  }

  // Converte DateTime para TZDateTime
  final tz.TZDateTime scheduledDate =
      tz.TZDateTime.from(taskDate, tz.local); // Usa o timezone local

  // Configuração da notificação
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'task_channel',
    'Task Notifications',
    importance: Importance.high,
    priority: Priority.high,
    showWhen: true,
  );

  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

  // Agendar a notificação
  await flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    'Tarefa: $title',
    description,
    scheduledDate,
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode
        .exactAllowWhileIdle, // Agendamento mesmo se o aplicativo estiver inativo
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );

  print('Notificação agendada para: $scheduledDate');
}

class MainApp extends StatelessWidget {
  final bool isDarkMode;
  const MainApp({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: LoginScreen(),
    );
  }
}
