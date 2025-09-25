import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tusalud/generated/l10.dart';

import '../../providers/app/select_mdoe_provider.dart';
import '../../style/app_style.dart';
import '../../utils/assets_image.dart';

class SelectModeView extends StatelessWidget {
  static const String routerName = 'selectMode';
  static const String routerPath = '/selectMode';
  const SelectModeView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).selectRole,
                  style: const TextStyle(
                    color: AppStyle.primary,
                    fontSize: 30, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  S.of(context).selectYourRole,
                  style: const TextStyle(
                    color: AppStyle.grey,
                    fontSize: 20, 
                    fontWeight: FontWeight.w500
                  ),
                ),
                if(isMobile) const SelectModeMobileView(),
                if(!isMobile) const SelectModeTabletView()
              ],
            ),
          ),
        )
      ),
    );
  }
}

class SelectModeMobileView extends StatelessWidget {
  const SelectModeMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    final SelectModeProvider selectModeProvider = Provider.of<SelectModeProvider>(context);
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SelectModeCardMobile(
            image: AssetsImages.admin(
              height: MediaQuery.of(context).size.height * 0.15
            ),
            onTap: () => selectModeProvider.goToAdmin(context),
            title: S.of(context).administration,
          ),
          SelectModeCardMobile(
            image: AssetsImages.employee(
              height: MediaQuery.of(context).size.height * 0.15
            ),
            onTap: () => selectModeProvider.goToEmployee(context),
            title: S.of(context).nurse,
          ),
          SelectModeCardMobile(
            image: AssetsImages.customer(
              height: MediaQuery.of(context).size.height * 0.15
            ),
            onTap: () => selectModeProvider.goToCustomer(context),
            title: S.of(context).supervisor,
          )
        ],
      ),
    );
  }
}

class SelectModeTabletView extends StatelessWidget {
  const SelectModeTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    final SelectModeProvider selectModeProvider = Provider.of<SelectModeProvider>(context);
    bool isDesktop = ResponsiveBreakpoints.of(context).smallerThan(DESKTOP);
    return GridView.count(
      crossAxisCount: isDesktop? 2: 3,
      shrinkWrap: true,
      children: [
        SelectModeCard(
          image: AssetsImages.admin(
            height: isDesktop? MediaQuery.of(context).size.width * .25: MediaQuery.of(context).size.width * .21
          ),
          onTap: () => selectModeProvider.goToAdmin(context),
          title: S.of(context).administration,
        ),
        SelectModeCard(
          image: AssetsImages.employee(
            height: isDesktop? MediaQuery.of(context).size.width * .25: MediaQuery.of(context).size.width * .21
          ),
          onTap: () => selectModeProvider.goToEmployee(context),
          title: S.of(context).nurse,
        ),
        SelectModeCard(
          image: AssetsImages.customer(
            height: isDesktop? MediaQuery.of(context).size.width * .25: MediaQuery.of(context).size.width * .21
          ),
          onTap: () => selectModeProvider.goToCustomer(context),
          title: S.of(context).supervisor,
        )
      ],
    );
  }
}

class SelectModeCard extends StatelessWidget {
  const SelectModeCard({super.key, required this.image, required this.onTap, required this.title});
  final Widget image;
  final Function() onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppStyle.white,
        surfaceTintColor: AppStyle.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              image,
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectModeCardMobile extends StatelessWidget {
  const SelectModeCardMobile({super.key, required this.image, required this.onTap, required this.title});
  final Widget image;
  final Function() onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppStyle.white,
        surfaceTintColor: AppStyle.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: image
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}