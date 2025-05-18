import 'rive_model.dart';

class Menu {
  final String title;
  final RiveModel rive;
  final String route;

  const Menu({required this.title, required this.rive, required this.route});
}

List<Menu> bottomNavItems = [
  Menu(
    title: "Home",
    rive: RiveModel(src: "assets/RiveAssets/icons.riv", artboard: "HOME", stateMachineName: "HOME_interactivity"),
    route: "/",
  ),
  Menu(
    title: "Timer",
    rive: RiveModel(src: "assets/RiveAssets/icons.riv", artboard: "TIMER", stateMachineName: "TIMER_Interactivity"),
    route: "/history",
  ),
];
