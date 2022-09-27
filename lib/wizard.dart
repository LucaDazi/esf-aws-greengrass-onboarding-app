/*
import 'package:dio/adapter.dart';
import 'package:dio/adapter_browser.dart';
import 'package:dio/dio.dart' as http;
*/
import 'dart:convert';
import 'dart:html';
import 'dart:io';

import 'package:esf_aws_greengrass_onboarding_app/onboarding.dart';
import 'package:flutter/material.dart';
import 'constants/constants.dart' as constants;
import 'package:http/http.dart' as http;

class OnboardingWizard extends StatefulWidget {
  const OnboardingWizard({super.key});

  @override
  State<OnboardingWizard> createState() => _OnboardingWizardState();
}

class _OnboardingWizardState extends State<OnboardingWizard> {
  bool _workingSecure = false;
  bool _workingEnroll = false;
  bool _workingConnect = false;
  bool _panelSecureGreen = false;
  bool _panelEnrollGreen = false;
  bool _panelConnectGreen = false;
  String _secure = '';
  String _enroll = '';
  String _connect = '';
  bool _showButton = true;
  bool _completed = false;

  final String _basicAuth =
      'Basic ${base64.encode(utf8.encode('admin:We!come12345'))}';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Greengrass Onboarding Wizard'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const OnboardingPage();
                }));
              },
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('background.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildPage(
                panelIcon: Icons.security,
                title: 'SECURE',
                subtitle: _secure,
                greyedOut: !_panelSecureGreen,
                working: _workingSecure,
              ),
              buildPage(
                panelIcon: Icons.memory,
                title: 'ENROLL',
                subtitle: _enroll,
                greyedOut: !_panelEnrollGreen,
                working: _workingEnroll,
              ),
              buildPage(
                panelIcon: Icons.cloud_sync,
                title: 'CONNECT',
                subtitle: _connect,
                greyedOut: !_panelConnectGreen,
                working: _workingConnect,
              ),
            ],
          ),
        ),
        floatingActionButton: _showButton
            ? FloatingActionButton.large(
                onPressed: () {
                  setState(() {
                    _workingSecure = true;
                    _panelSecureGreen = true;
                    _showButton = false;
                    _secure = constants.secureDescription;
                  });
                  steps().then((value) => {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(value)))
                      });
                },
                tooltip: 'Start wizard!',
                child: const Icon(Icons.start),
              )
            : _completed
                ? FloatingActionButton.large(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const OnboardingPage();
                      }));
                    },
                    tooltip: 'Go to Driver setup',
                    child: const Icon(Icons.device_hub),
                  )
                : null,
        floatingActionButtonLocation: _completed
            ? FloatingActionButtonLocation.endFloat
            : FloatingActionButtonLocation.centerFloat,
      );

  Widget buildPage({
    //required String urlImage,
    required IconData panelIcon,
    required String title,
    required String subtitle,
    required bool greyedOut,
    required bool working,
  }) =>
      Expanded(
        child: Center(
          child: greyedOut
              /*
              ? ColorFiltered(
                  colorFilter:
                      const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                  child: PagePanelWidget(
                    panelIcon: panelIcon,
                    title: title,
                    subtitle: subtitle,
                    working: working,
                  ),
                ) */
              ? Container(
                  foregroundDecoration: const BoxDecoration(
                    color: Colors.grey,
                    backgroundBlendMode: BlendMode.saturation,
                  ),
                  child: PagePanelWidget(
                    panelIcon: panelIcon,
                    title: title,
                    subtitle: subtitle,
                    working: working,
                  ),
                )
              : PagePanelWidget(
                  panelIcon: panelIcon,
                  title: title,
                  subtitle: subtitle,
                  working: working,
                ),
        ),
      );

  Future<String> step(int stepNumber) async {
    try {
      Location currentLocation = window.location;

      final url = Uri.https(
          currentLocation.host, '/services/greengrass/test/step$stepNumber');

      final response = await http.get(url, headers: {
        HttpHeaders.authorizationHeader: _basicAuth,
        HttpHeaders.acceptHeader: '*/*',
        HttpHeaders.accessControlAllowOriginHeader: '*'
      });

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return "error in response";
      }
    } catch (e) {
      return FlutterErrorDetails(exception: e).exceptionAsString();
    }
  }

  Future<String> steps() async {
    String result = await step(1);
    if (result.contains('Security Stack created')) {
      //if (result.contains('XMLHttpRequest error')) {
      result = "false";
      int trials = 10;
      while (!result.contains('Enorllment complete!')) {
        await Future.delayed(const Duration(seconds: 5));
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Trial number ${11 - trials}')));
        });
        trials--;
        if (trials <= 0) {
          break;
        }
        result = await step(3);
      }
      setState(() {
        _workingSecure = false;
        _workingEnroll = true;
        _panelEnrollGreen = true;
        _enroll = constants.enrollDescription;
      });
      result = await step(4);
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        _workingEnroll = false;
        _workingConnect = true;
        _panelConnectGreen = true;
        _connect = constants.connectDescription;
      });
      result = await step(5);
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        _workingConnect = false;
        //_showButton = true;
        _completed = true;
      });

      return 'Greengrass successfully provisioned!';
    }

    setState(() {
      _workingConnect = false;
      _workingEnroll = false;
      _workingSecure = false;
      _showButton = true;
      _panelConnectGreen = false;
      _panelEnrollGreen = false;
      _panelSecureGreen = false;
      _showButton = false;
      _completed = true;
    });

    return 'ERROR during provisioning!';
  }
}

class PagePanelWidget extends StatelessWidget {
  const PagePanelWidget({
    Key? key,
    required this.panelIcon,
    required this.title,
    required this.subtitle,
    required this.working,
  }) : super(key: key);

  final IconData panelIcon;
  final String title;
  final String subtitle;
  final bool working;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1000),
      /*
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('background.png'),
          fit: BoxFit.fill,
        ),
      ),*/
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 16,
              width: double.infinity,
            ),
            working
                ? const CircularProgressIndicator(
                    color: Colors.black87,
                    strokeWidth: 5,
                  )
                : Icon(
                    panelIcon,
                    color: Colors.black87,
                    size: 64,
                  ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
            ),
            //if (working) const LinearProgressIndicator(minHeight: 16),
          ]),
    );
  }
}
