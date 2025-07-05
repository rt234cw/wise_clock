import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wise_clock/color_scheme/color_code.dart';
import 'btm_nav_item.dart';
import 'menu.dart';
import 'rive_utils.dart';

class LandingView extends StatefulWidget {
  final Widget child;
  const LandingView({super.key, required this.child});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> with SingleTickerProviderStateMixin {
  bool lightMode = true;
  late final Animation<double> animation;
  late final AnimationController _animationController;

  Menu selectedBottonNav = bottomNavItems.first;

  late final DateTime todayDate;

  String get todayDateString {
    const List<String> weekdays = ['一', '二', '三', '四', '五', '六', '日'];
    return "${todayDate.month}月${todayDate.day}日 星期${weekdays[todayDate.weekday - 1]}";
  }

  @override
  void initState() {
    super.initState();

    todayDate = DateTime.now();

    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100))
      ..addListener(
        () {
          setState(() {});
        },
      );
    animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn));
  }

  void updateSelectedBtmNav(Menu menu) {
    if (selectedBottonNav != menu) {
      setState(() {
        selectedBottonNav = menu;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF1F5F9), // 更深的藍黑色

        // gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [
        //     Color(0xFFFFFFFF),
        //     Color(0xFFF8FAFC),
        //   ],
        // ),
      ),
      child: Scaffold(
        // backgroundColor: Color(0xFFF2F6FF),
        backgroundColor: Colors.transparent,
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: false,
          // backgroundColor: Color(0xFFF2F6FF),
          backgroundColor: Colors.transparent,
          // surfaceTintColor: Color(0xFFF2F6FF),
          surfaceTintColor: Colors.transparent,
          // shadowColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Text(todayDateString),
          titleSpacing: 24,
          titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: ColorCode.primaryColor,
                fontWeight: FontWeight.w600,
              ),
        ),
        bottomNavigationBar: Transform.translate(
          offset: Offset(0, 100 * animation.value),
          child: SafeArea(
            child: _floattingBtmNavBar(context),
          ),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.child,
        )),
      ),
    );
  }

  Widget _floattingBtmNavBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, top: 12, right: 12, bottom: 12),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFF17203A).withValues(alpha: 0.8),
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF17203A).withValues(alpha: 0.3),
            offset: const Offset(0, 20),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ...List.generate(
            bottomNavItems.length,
            (index) {
              Menu navBar = bottomNavItems[index];
              return BtmNavItem(
                navBar: navBar,
                press: () {
                  if (selectedBottonNav == navBar) return;

                  RiveUtils.chnageSMIBoolState(navBar.rive.status!);
                  updateSelectedBtmNav(navBar);
                  context.go(navBar.route);
                },
                riveOnInit: (artboard) {
                  navBar.rive.status = RiveUtils.getRiveInput(artboard, stateMachineName: navBar.rive.stateMachineName);
                },
                selectedNav: selectedBottonNav,
              );
            },
          ),
        ],
      ),
    );
  }
}
