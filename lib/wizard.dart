import 'package:esf_aws_greengrass_onboarding_app/onboarding.dart';
import 'package:flutter/material.dart';
import 'constants/constants.dart' as constants;

class OnboardingWizard extends StatefulWidget {
  const OnboardingWizard({super.key});

  @override
  State<OnboardingWizard> createState() => _OnboardingWizardState();
}

class _OnboardingWizardState extends State<OnboardingWizard> {
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
                subtitle: constants.SECURE_DESCRIPTION,
                greyedOut: false,
                working: false,
              ),
              buildPage(
                panelIcon: Icons.memory,
                title: 'ENROLL',
                subtitle: constants.ENROLL_DESCRIPTION,
                greyedOut: false,
                working: false,
              ),
              buildPage(
                panelIcon: Icons.cloud_sync,
                title: 'CONNECT',
                subtitle: constants.CONNECT_DESCRIPTION,
                greyedOut: true,
                working: false,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.large(
          onPressed: () {},
          tooltip: 'Start wizard!',
          child: const Icon(Icons.start),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
            const SizedBox(height: 16),
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
