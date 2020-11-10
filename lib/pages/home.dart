import 'package:flutter/material.dart';
import 'package:graphqlex/pages/profile/historical.dart';
import 'package:graphqlex/pages/profile/opportunities.dart';
import 'package:graphqlex/pages/profile/projects.dart';
import 'package:graphqlex/pages/profile/user.dart';
import 'package:graphqlex/components/speed_dial.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.cyan[800],
        floatingActionButton: SpeedDialButton(),
        appBar: AppBar(
          backgroundColor: Colors.cyan[600],
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) => Navigator.of(context)
                  .pushNamedAndRemoveUntil(
                      '/signout', (Route<dynamic> route) => false),
              itemBuilder: (BuildContext context) {
                return {'Logout'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(icon: Icon(Icons.business_center)),
              Tab(
                text: 'PERFIL',
              ),
              Tab(
                text: 'PROJETOS',
              ),
              Tab(
                text: 'HISTÓRICO',
              ),
            ],
          ),
          title: Text('Find Work'),
          centerTitle: true,
        ),
        body: TabBarView(
          children: [
            OpportunitiesPage(),
            UserPage(),
            ProjectsPage(),
            HistoricalPage(),
          ],
        ),
      ),
    );
  }
}
