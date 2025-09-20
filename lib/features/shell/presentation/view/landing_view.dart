import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:wise_clock/generated/l10n.dart';

import '../../../../core/providers/locale_provider.dart';
import '../widget/btm_nav_item.dart';
import 'menu.dart';

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
    final bool isAppBarVisible = selectedBottonNav == bottomNavItems[0] || selectedBottonNav == bottomNavItems[2];
    final colorScheme = Theme.of(context).colorScheme;

    String appBarTitle = '';
    if (isAppBarVisible) {
      if (selectedBottonNav == bottomNavItems[0]) {
        // 如果是第一個分頁，顯示日期
        final locale = context.watch<LocaleProvider>().locale?.toString() ?? "zh_TW";
        appBarTitle = DateFormat.yMMMMEEEEd(locale).format(DateTime.now());
      } else if (selectedBottonNav == bottomNavItems[2]) {
        // 如果是第三個分頁，顯示「設定」的翻譯
        appBarTitle = S.of(context).settings;
      }
    }
    return Scaffold(
      backgroundColor: colorScheme.surface,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: isAppBarVisible ? _buildAppBar(appBarTitle, context) : null,
      bottomNavigationBar: Transform.translate(
        offset: Offset(0, 100 * animation.value),
        child: SafeArea(
          child: _floattingBtmNavBar(context),
        ),
      ),
      body: SafeArea(child: widget.child),
    );
  }

  AppBar _buildAppBar(String appTitle, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      centerTitle: false,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      title: Text(appTitle),
      titleSpacing: 10,
      titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  Widget _floattingBtmNavBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // A slightly lighter version of the surface color for the nav bar

    return Container(
      padding: const EdgeInsets.only(left: 12, top: 12, right: 12, bottom: 12),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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

                  updateSelectedBtmNav(navBar);
                  context.go(navBar.route);
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
