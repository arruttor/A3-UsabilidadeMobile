import 'package:flutter/material.dart';

class DatePickerField extends StatefulWidget {
  /// Controlador de texto para gerenciar o valor da data.
  final TextEditingController datecontroll;

  /// Valor inicial opcional para a data.
  final String? data;

  const DatePickerField({
    Key? key,
    required this.datecontroll,
    this.data,
  }) : super(key: key);

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  @override
  void initState() {
    super.initState();

    // Define o valor inicial no controlador, se fornecido
    if (widget.data != null) {
      widget.datecontroll.text = widget.data!;
    }
  }

  /// Abre o seletor de data e atualiza o controlador com a data selecionada.
  Future<void> _openDatePicker() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Data inicial
      firstDate: DateTime.now(), // Data mínima
      lastDate: DateTime(2100), // Data máxima
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue, // Cor primária do seletor
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      // Formata a data para dd/mm/aaaa
      String formattedDate =
          "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}";
      setState(() {
        widget.datecontroll.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.datecontroll,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        hintText: 'Data expira',
        hintStyle: const TextStyle(
          fontSize: 24,
          fontFamily: 'Poppins',
          color: Colors.black,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 4,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 4,
          ),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today, color: Colors.black),
          onPressed: _openDatePicker,
        ),
      ),
    );
  }
}
