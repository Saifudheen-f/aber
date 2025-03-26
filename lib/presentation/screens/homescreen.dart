import 'package:espoir_marketing/presentation/screens/customer/week_followup.dart';
import 'package:espoir_marketing/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:espoir_marketing/core/const.dart';
import 'package:espoir_marketing/core/decoration.dart';
import 'package:espoir_marketing/presentation/screens/Task_management/screens/list_task.dart';
import 'package:espoir_marketing/presentation/screens/Notes/notes_screen.dart';
import 'package:espoir_marketing/presentation/screens/customer/add_customer.dart';
import 'package:espoir_marketing/presentation/screens/customer/list_customers.dart';
import 'package:espoir_marketing/presentation/screens/Task_management/widgets/homeicon.dart';
import 'package:espoir_marketing/presentation/widgets/drawer.dart';
import 'package:espoir_marketing/presentation/widgets/home_icon.dart';
import 'package:espoir_marketing/presentation/widgets/notification_button.dart';
import 'package:espoir_marketing/presentation/widgets/welcome_widget.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with RouteAware {
  late Future<void> _fetchDataFuture;

  @override
  void initState() {
    super.initState();
    _fetchDataFuture = _fetchData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to RouteObserver
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    setState(() {
      _fetchDataFuture = _fetchData();
    });
  }

  Future<void> _fetchData() async {
    await Future.delayed(const Duration(milliseconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: icontheme),
        actions: [
          NotificationButton(
            onpress: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => const CalendarFollowup()),
              ).then((value) {
                    setState(() {
                      _fetchDataFuture = _fetchData();
                    });
                  });
            },
          )
        ],
      ),
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: backGroundDecoration,
            ),
          ),
          Container(
            decoration: imageDecoration,
            height: double.infinity,
            child: FutureBuilder<void>(
              future: _fetchDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loading();
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading data'));
                } else {
                  return _buildContent();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 56),
          Image(
            image: AssetImage(logoImage),
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 7),
          const WelcomeCard(),
          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'view all',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(221, 149, 149, 149),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MainIcon(
                icon: Icons.person_add_sharp,
                txt: 'Add Customers',
                onpress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => const AddCustomer()),
                  );
                },
              ),
              MainIcon(
                icon: Icons.people,
                txt: 'View Customers',
                onpress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => const Listcustomer()),
                  ).then((value) {
                    setState(() {
                      _fetchDataFuture = _fetchData();
                    });
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MainIcon(
                icon: Icons.notes,
                txt: 'View Notes',
                onpress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => const NoteScreen()),
                  );
                },
              ),
              TaskIconWithCount(
                onpress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => const ListTask()),
                  ).then((value) {
                    setState(() {
                      _fetchDataFuture = _fetchData();
                    });
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
