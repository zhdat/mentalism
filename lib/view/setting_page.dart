import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mentalism/model/time_model.dart';
import 'package:mentalism/view/onboarding_page.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  final Function(String) onUIStyleChanged;
  final String selectedUI;

  const SettingPage({
    Key? key,
    required this.onUIStyleChanged,
    required this.selectedUI,
  }) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _myBox = Hive.box("Data");

  void _writeData(int index, String text) {
    _myBox.put(index, text);
  }

  String? _validateInput(String? value) {
    // Custom validation logic
    if (value == null || value.isEmpty) {
      return 'Please enter a value.';
    }

    int parsedValue;
    try {
      parsedValue = int.parse(value);
      if (parsedValue < 0 || parsedValue > 99) {
        return 'Please enter a value between 0 and 99.';
      }
    } catch (e) {
      return 'Please enter a valid number.';
    }

    return null; // Input is valid
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Validation passed, perform the desired action
      String text = _controller.text;
      _writeData(0, text);

      // Additional logic if needed
    }
  }

  void _navigateToTutorial() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OnBoardingScreen(
          onUIStyleChanged: (String) {
            'Apple';
          },
          selectedUI: 'Apple',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimeModel>(
      builder: (context, value, child) => _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.selectedUI == 'Apple'
          ? Colors.black
          : const Color.fromARGB(255, 21, 3, 1),
      appBar: _buildAppBar(context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              _buildTextFormField(),
              const SizedBox(height: 20), // Add some space
              _buildSubmitButton(),
              const SizedBox(height: 60), // Add some space
              _buildDropdownButton(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
          onPressed: _navigateToTutorial,
          icon: const Icon(Icons.help),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
        ),
      ],
    );
  }

  TextFormField _buildTextFormField() {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      controller: _controller,
      validator: _validateInput,
      decoration: InputDecoration(
        labelText: "Entrer une valeur",
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.grey[850],
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  ElevatedButton _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        _submitForm();
        String text = _controller.text;
        _writeData(0, text);
      },
      child: const Text('Envoyer la valeur'),
    );
  }

  DropdownButton<String> _buildDropdownButton() {
    return DropdownButton<String>(
      style: const TextStyle(color: Colors.white),
      dropdownColor: Colors.grey[850],
      value: widget.selectedUI,
      items: ['Apple', 'Android']
          .map(
            (ui) => DropdownMenuItem(
              value: ui,
              child: Text(ui),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          widget.onUIStyleChanged(value!); // Call the callback
        });
      },
    );
  }

}
