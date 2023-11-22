import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myactivityapp/screens/ajouter_activity.dart';
import 'package:myactivityapp/screens/home_screen.dart';
import 'package:myactivityapp/screens/profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 0;
  final List<Widget> screens = [
    HomeScreen(),
    AjoutActivity(),
    ProfilePage(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomeScreen();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          setState(() {
            currentScreen = AjoutActivity();
            currentTab = 1;
          });

        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currentScreen = HomeScreen();
                          currentTab = 0;
                        });

                      },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_activity_sharp,
                        color: currentTab == 0? Colors.blue :Colors.grey,
                      ),
                      Text(
                        'Activité',
                            style: TextStyle(
                              color: currentTab == 0? Colors.blue :Colors.grey,
                            )
                      ),
                    ],
                  ),
                  ),

                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = ProfilePage();
                        currentTab = 1;
                      });

                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color: currentTab == 1? Colors.blue :Colors.grey,
                        ),
                        Text(
                            'Profile',
                            style: TextStyle(
                              color: currentTab == 1? Colors.blue :Colors.grey,
                            )
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
