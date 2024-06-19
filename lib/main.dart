import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  // For JSON decoding

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Compute App',
      home: Scaffold(
        appBar: AppBar(
            title: Text("Math Compute App")
        ),
        body: Center(
          child: MathInputs(),
        ),
      ),
    );
  }
}

class MathInputs extends StatefulWidget {
  const MathInputs({Key? key}) : super(key: key);

  @override
  State<MathInputs> createState() => _MathInputsState();
}

class _MathInputsState extends State<MathInputs> {

  String _data = 'Fetching data...';
  final _formKey = GlobalKey<FormState>();
  String _result = '';
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // fetchData();
  }

  Future<String> fetchData(String expression, String operation) async {

    try {
      // Encode the '^' character
      String encodedExpression = expression.replaceAll('^', '%5E');

      final url = 'https://newton.vercel.app/api/v2/derive/$encodedExpression';

      // Send the GET request
      final response = await http.get(Uri.parse(url));


      // Check if the request was successful
      if (response.statusCode == 200) {
        // Decode the response body
        final responseData = jsonDecode(response.body);
        return responseData['result'] ?? 'No result';
        // setState(() {
        //   _data = data.toString();
        // });
        // Print or use the data
        // print(data);
      } else {
        // Handle error
        print('Failed to load data. Status code: ${response.statusCode}');
        // setState(() {
        //   _data = 'Failed to load data. Status code: ${response.statusCode}';
        // });
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      // Handle any exceptions
      print('Error occurred: $e');
      // setState(() {
      //   _data = 'Error occurred: $e';
      // });
      return 'Error: ${e.toString()}';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Expression',
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an expression';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _evaluateExpression,
              child: Text('Evaluate'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Result: $_result',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  void _evaluateExpression() async {
    if (_formKey.currentState?.validate() ?? false) {
      String input = _controller.text;

      // Fetch the data using the generic function
      String result = await fetchData(input, 'simplify');

      setState(() {
        _result = result;
      });
    }
  }
}

// void _evaluateExpression() {
//   if(_controller.text != validate ){
//     return Text("Field Evaulate is empty");
//   } else {
//     fetchData();
//   }
// }




// _evaluateExpression


