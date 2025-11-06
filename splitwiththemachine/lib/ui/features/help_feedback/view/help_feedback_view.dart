import 'package:flutter/material.dart';

class HelpAndFeedbackScreen extends StatelessWidget {
  const HelpAndFeedbackScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
          centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text('SplitWithTheMachine',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 16.0),
                    Image.asset('assets/images/logo.png', height: 100.0,),
                    const SizedBox(height: 16.0),
                    const Text('0.1', style: TextStyle(fontSize: 16.0)),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Authors'),
                              content: const SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('Alexandre Borrazás Mancebo'),
                                    Text('Daniel García Figueroa'),
                                    Text('Nerea Pérez Pértega')
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Close'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Authors'),
                    ),
                    const SizedBox(height: 12.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('License'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('© 2025 Alexandre Borrazás Mancebo, '
                                        'Daniel García Figueroa and '
                                        'Nerea Pérez Pértega. '
                                        'This program comes WITHOUT ANY WARRANTY. '
                                        'See the GNU General Public License, version'
                                        '3 or later for more details.'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Close'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('License'),
                    ),
                    const SizedBox(height: 12.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Send us feedback!'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('alexandre.bmancebo@udc.es'),
                                    Text('d.figueroa@udc.es'),
                                    Text('nerea.ppertega@udc.es'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Close'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Contact us'),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}