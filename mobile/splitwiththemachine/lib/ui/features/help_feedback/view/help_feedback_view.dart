import 'package:flutter/material.dart';
import 'package:splitwiththemachine/ui/core/widgets/generic_app_bar.dart';

import '../../../core/widgets/generic_sized_box.dart';

class HelpAndFeedbackScreen extends StatelessWidget {
  const HelpAndFeedbackScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GenericAppBar(title: title),

      body: CustomScrollView(
        slivers: [

          // ---- Main content ----
          SliverToBoxAdapter(
            child: StretchingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: GenericSizedBox(
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            const Text(
                              'SplitWithTheMachine',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 16),

                            Image.asset(
                              'assets/images/logo.png',
                              height: 100,
                            ),

                            const SizedBox(height: 8),
                            const Text('0.1', style: TextStyle(fontSize: 16)),
                            const SizedBox(height: 24),

                            // ---------- Authors button ----------
                            buildInfoButton(
                              context: context,
                              label: "Authors",
                              tooltip: "Show authors",
                              children: const [
                                Text('Alexandre Borrazás Mancebo'),
                                Text('Daniel García Figueroa'),
                                Text('Nerea Pérez Pértega'),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // ---------- License button ----------
                            buildInfoButton(
                              context: context,
                              label: "License",
                              tooltip: "Show license",
                              children: const [
                                Text(
                                    '© 2025 Alexandre Borrazás Mancebo, '
                                        'Daniel García Figueroa and '
                                        'Nerea Pérez Pértega.\n'
                                        'This program comes WITHOUT ANY WARRANTY. '
                                        'See the GNU General Public License, version'
                                        ' 3 or later for more details.'
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // ---------- Contact Button ----------
                            buildInfoButton(
                              context: context,
                              label: "Contact us",
                              tooltip: "Show contact emails",
                              children: const [
                                Text('alexandre.bmancebo@udc.es'),
                                Text('d.figueroa@udc.es'),
                                Text('nerea.ppertega@udc.es'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 50),
          ),
        ],
      ),
    );
  }

  Widget buildInfoButton({
    required BuildContext context,
    required String label,
    required String tooltip,
    required List<Widget> children,
  }) {
    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 120,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 4,
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .inversePrimary,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) =>
                  AlertDialog(
                    title: Text(label),
                    content: SingleChildScrollView(
                      child: ListBody(children: children),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      )
                    ],
                  ),
            );
          },
          child: Text(label),
        ),
      ),
    );
  }
}