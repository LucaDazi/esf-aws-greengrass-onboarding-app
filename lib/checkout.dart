import 'dart:html';

import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _currentStep = 0;

  _stepState(int step) {
    if (_currentStep > step) {
      return StepState.complete;
    } else {
      return StepState.editing;
    }
  }

  _steps() => [
        Step(
          title: const Text('Create Security Stack'),
          content: const _CreateSecurityStackWidget(),
          state: _stepState(0),
          isActive: _currentStep == 0,
        ),
        Step(
          title: const Text('Card Details'),
          content: const _CardForm(),
          state: _stepState(1),
          isActive: _currentStep == 1,
        ),
        Step(
          title: const Text('Overview'),
          content: const _Overview(),
          state: _stepState(2),
        )
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Greengrass Provisioning Wizard'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Settings'),
                    ),
                    body: const Center(
                        child: Text(
                      'This is the settings page',
                      style: TextStyle(fontSize: 24),
                    )),
                  );
                },
              ));
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Stepper(
        controlsBuilder: (BuildContext context, ControlsDetails controls) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: <Widget>[
                if (_currentStep > 0)
                  ElevatedButton(
                    onPressed: controls.onStepContinue,
                    child: const Text('NEXT'),
                  ),
                if (_currentStep != 0)
                  TextButton(
                    onPressed: controls.onStepCancel,
                    child: const Text(
                      'BACK',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
              ],
            ),
          );
        },
        onStepTapped: (step) => setState(() => _currentStep = step),
        onStepContinue: () {
          setState(() {
            if (_currentStep < _steps().length - 1) {
              _currentStep += 1;
            } else {
              _currentStep = 0;
            }
          });
        },
        onStepCancel: () {
          setState(() {
            if (_currentStep > 0) {
              _currentStep -= 1;
            } else {
              _currentStep = 0;
            }
          });
        },
        currentStep: _currentStep,
        steps: _steps(),
      ),
    );
  }
}

class _CreateSecurityStackWidget extends StatelessWidget {
  const _CreateSecurityStackWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FloatingActionButton(onPressed: () {}),
      ],
    );
  }
}

class _CardForm extends StatelessWidget {
  const _CardForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Card number',
          ),
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Expiry date',
          ),
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'CVV',
          ),
        ),
      ],
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Center(child: Text('Thank you for your order!')),
      ],
    );
  }
}
