import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spk_uptd/components/responsive.dart';
import 'package:spk_uptd/controllers/AppControllers.dart';
import 'package:spk_uptd/screens/dashboard/dashboardScreen.dart';
import 'signin/signinScreen.dart';
import 'signup/signupScreen.dart';
import 'profil/profilScreen.dart';
import 'about/aboutScreen.dart';
import 'kelola/kelolaScreen.dart';
import 'magang/magangScreen.dart';
import 'c45/c45Screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<AppControllers>().scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Stack(
          children: [
            Consumer<AppControllers>(builder: (context, setmain, child) {
              return setmain.getuserActive.isEmpty
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      color: Color.fromARGB(255, 31, 35, 48),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 8,
                          ),
                          Consumer<AppControllers>(
                            builder: (context, appAuthController, child) {
                              Widget selectedScreen;
                              switch (appAuthController.getAuthChoices) {
                                case 0:
                                  selectedScreen = Center(
                                    child: SigninScreen(),
                                  );
                                  break;
                                case 1:
                                  selectedScreen = Center(
                                    child: SignupScreen(),
                                  );
                                  break;
                                default:
                                  selectedScreen = Center(
                                    child: SigninScreen(),
                                  );
                              }

                              return selectedScreen;
                            },
                          ),
                        ],
                      ),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (Responsive.isDesktop(context))
                          Expanded(
                            child: SideMenu(),
                          ),
                        Expanded(
                          flex: 5,
                          child: Consumer<AppControllers>(
                            builder: (context, appControllers, child) {
                              Widget selectedScreen;

                              switch (appControllers.menuChoices) {
                                case 0:
                                  selectedScreen = DashboardScreen();
                                  break;
                                case 1:
                                  selectedScreen = KelolaScreen();
                                  break;
                                case 2:
                                  selectedScreen = MagangScreen();
                                  break;
                                case 3:
                                  selectedScreen = C45Screen();
                                  break;
                                case 4:
                                  selectedScreen = ProfilScreen();
                                  break;
                                case 5:
                                  selectedScreen = AboutScreen();
                                  break;
                                default:
                                  selectedScreen = DashboardScreen();
                              }
                              return selectedScreen;
                            },
                          ),
                        ),
                      ],
                    );
            }),
          ],
        ),
      ),
    );
  }
}

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var myListProvider = Provider.of<AppControllers>(context, listen: false);
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(2, 255, 255, 255),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Image.asset(
                      myListProvider.userActive[8].toString(),
                      width: 100,
                      height: 100,
                    ),
                    IconButton(
                      icon: Icon(Icons.settings),
                      iconSize: 30,
                      onPressed: () {
                        // myListProvider.setmenuchoice(4);
                        // Tindakan yang ingin Anda lakukan saat ikon pengaturan diklik
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(myListProvider.userActive[1].toString().toUpperCase()),
              ],
            ),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashbord.svg",
            press: () {
              myListProvider.setmenuchoice(0);
            },
          ),
          myListProvider.userActive[3].toString() == "admin"
              ? DrawerListTile(
                  title: "Kelola Pengguna",
                  svgSrc: "assets/icons/menu_profile.svg",
                  press: () {
                    myListProvider.setmenuchoice(1);
                  },
                )
              : SizedBox(),
          DrawerListTile(
            title: "Klien Magang",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {
              myListProvider.setmenuchoice(2);
            },
          ),
          myListProvider.userActive[3].toString() == "admin" ||
                  myListProvider.userActive[3].toString() == "staff"
              ? DrawerListTile(
                  title: "C45",
                  svgSrc: "assets/icons/menu_notification.svg",
                  press: () {
                    myListProvider.setmenuchoice(3);
                  },
                )
              : SizedBox(),
          DrawerListTile(
            title: "Tentang",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {
              myListProvider.setmenuchoice(5);
            },
          ),
          DrawerListTile(
            title: "Keluar",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {
              myListProvider.keluar();
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
