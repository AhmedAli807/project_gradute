import 'package:flutter/material.dart';
import 'package:project_gradute/controller/authentication/login/sign_out_provider.dart';
import 'package:project_gradute/views/Login/login_view.dart';
import 'package:project_gradute/views/home/home_view.dart';
import 'package:project_gradute/views/map_fire/widgets/map_view_body.dart';
import 'package:provider/provider.dart';

import '../../../utils/color_assets.dart';
import '../../../utils/font_style.dart';
import '../../factory_map/factory_map_view.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: ColorAssets.secondaryColor,
            ),
            child: Center(
              child: Text(
                'Welcome ,sir',
                style: TextStyle(color: ColorAssets.kColor),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: ColorAssets.kColor,
            ),
            title: const Text(
              'Home',
              style: Styles.textStyle14,
            ),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomeView()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.factory,
              color: ColorAssets.kColor,
            ),
            title: const Text(
              'Recycle map',
              style: Styles.textStyle14,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FactoryMapView()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.local_fire_department,
              color: ColorAssets.kColor,
            ),
            title: const Text(
              'Fire map',
              style: Styles.textStyle14,
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MapViewBody()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.volunteer_activism,
              color: ColorAssets.kColor,
            ),
            title: const Text(
              'Volunteer',
              style: Styles.textStyle14,
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginView()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: ColorAssets.kColor,
            ),
            title: const Text(
              'Settings',
              style: Styles.textStyle14,
            ),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context)=>const MapViewBody()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: ColorAssets.kColor,
            ),
            title: const Text(
              'Logout',
              style: Styles.textStyle14,
            ),
            onTap: () {
              Provider.of<SignOutProvider>(context, listen: false)
                  .signOutProvider();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginView()));
            },
          ),
        ],
      ),
    );
  }
}
