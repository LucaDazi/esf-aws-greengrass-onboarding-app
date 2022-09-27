import 'package:flutter/material.dart';

class DriverForm extends StatefulWidget {
  const DriverForm({super.key});

  @override
  State<DriverForm> createState() => _DriverFormState();
}

class _DriverFormState extends State<DriverForm> {
  final _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Driver IP address in the correct form';
                  }
                  return null;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
