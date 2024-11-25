import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Editar_Informacoes.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference(); // Carrega a preferência de tema quando a tela é inicializada
  }

  // Função para carregar a preferência de tema
  void _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ??
          false; // Carrega a preferência ou usa o padrão (false)
    });
  }

  // Função para alternar o tema e salvar a preferência
  void _toggleTheme(bool value) async {
    setState(() {
      _isDarkMode = value;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode); // Salva a preferência do tema
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // Desativa o comportamento automático de ícone de voltar no appbar
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Center(
              //titulo texto grande da tela
              child: Text(
                'Configurações',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'),
              ),
            ),
            SizedBox(height: 40),
            //botão para alterar email
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(246, 182, 188, 1),
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              //onpress para chamar a tela de edição de informações passando o parametro 1 para alterar o email
              onPressed: () async {
                //chama o navigator para trocar de tela e aguarda a resposta que ele vai dar, se é confirmação ou falha
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditInfoScreen(1)),
                );
                //verifica o retorno do navigator e cria um snacbar com a mensagem correspondente
                if (result == 'certo') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('E-mail alterado com sucesso'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                } else if (result == 'falha') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Falha ao alterar o e-mail'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: Text(
                'Alterar Email',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            //Botão de alterar Senha
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(246, 182, 188, 1),
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              //onpress para chamar a tela de edição de informações passando o parametro 1 para alterar o email
              onPressed: () async {
                //chama o navigator para trocar de tela e aguarda a resposta que ele vai dar, se é confirmação ou falha
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditInfoScreen(2)),
                );
                //verifica o retorno do navigator e cria um snacbar com a mensagem correspondente
                if (result == 'certo') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Senha alterada com sucesso'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                } else if (result == 'falha') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Falha ao alterar a senha'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: Text(
                'Alterar Senha',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),

            SizedBox(height: 20),
            //Botão de contato
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(246, 182, 188, 1),
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              //Onpressd para fazer a chamada de um navegador e acessar uma URL
              onPressed: () async {
                //Cria a variael url com o site
                final Uri url = Uri.parse('https://www.google.com');
                //try para tentar chamar um broser e abrir o site, o app fica esperando isso acontecer
                try {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao tentar abrir o navegador'),
                    ),
                  );
                }
              },
              child: Text(
                'Contato',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            //toggleButton para alterar o thema do app
            SwitchListTile(
              title: Text(
                'Modo Escuro',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              value: _isDarkMode,
              //verifica o evento onChanged e chama a função para alterar o thema
              onChanged: (bool value) {
                _toggleTheme(value);
              },
              activeColor: Colors.black,
              activeTrackColor: Color.fromRGBO(246, 182, 188, 1),
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Color.fromRGBO(246, 182, 188, 1),
            ),
          ],
        ),
      ),
    );
  }
}
