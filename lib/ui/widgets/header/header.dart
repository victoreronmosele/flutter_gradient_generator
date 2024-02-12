import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/ui/widgets/header/widgets/tool_bar.dart';
import 'package:flutter_gradient_generator/ui/widgets/header/widgets/banner_ad.dart';

class Header extends StatefulWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> with SingleTickerProviderStateMixin {
  late AnimationController _closeBannerAdController;
  late Animation<double> _bannerAdSizeFactor;

  @override
  void initState() {
    super.initState();

    _closeBannerAdController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _bannerAdSizeFactor = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _closeBannerAdController,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _closeBannerAdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizeTransition(
          sizeFactor: _bannerAdSizeFactor,
          child: BannerAd(
            onClose: () {
              _closeBannerAdController.forward();
            },
          ),
        ),
        ToolBar(),
      ],
    );
  }
}
