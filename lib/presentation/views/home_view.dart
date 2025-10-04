import 'package:flutter/material.dart';
import 'settings_view.dart';
import 'ippt_tab_widget.dart';
import 'counter_tab_widget.dart';

class HomeView extends StatelessWidget {
  // final AppController appController;

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          elevation: 0,
          title: const Text('NS Buddy'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => SettingsView()));
              },
              icon: const Icon(Icons.settings),
              tooltip: 'Settings',
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.fitness_center), text: 'IPPT'),
              Tab(icon: Icon(Icons.add_circle_outline), text: 'Counter'),
            ],
          ),
        ),
        body: TabBarView(children: [IPPTTabWidget(), CounterTabWidget()]),
      ),
    );
  }
}
