import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:i_billing/asset/path/app_resources.dart';


enum MyEnum{
  first(name: "Birinchi"), second(name: "Ikkinchi"), third(name:"Uchinchi"), fourth(name: "To'rtinchi");
  final String name;
  const MyEnum({required this.name});
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  ValueNotifier<bool> isMenuOpen = ValueNotifier(false);
  String selectedText = "Birinchi";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => isMenuOpen.value = false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Dropdown va Portalni o'rganamiz"),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ValueListenableBuilder(
              valueListenable: isMenuOpen,
              builder: (context, value, child) => PortalTarget(
                visible: isMenuOpen.value,
                anchor: const Aligned(
                  follower: Alignment.topCenter,
                  target: Alignment.bottomCenter,
                ),
                portalFollower: Material(
                  elevation: 8,
                  child: IntrinsicWidth(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...MyEnum.values
                            .map((e) => GestureDetector(
                                  onTap: () {
                                    isMenuOpen.value = false;
                                    selectedText = e.name;
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.95,
                                    color: AppColors.dark,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                                    child: Row(
                                      children: [
                                        Text(e.name),
                                        const Spacer(),
                                        SvgPicture.asset(
                                          AppResources.svgRadio,
                                          colorFilter: ColorFilter.mode(
                                              e.name.contains(selectedText) ? AppColors.green : AppColors.grey4D,
                                              BlendMode.srcIn),
                                        )
                                      ],
                                    ),
                                  ),
                                ))
                            .toList()
                      ],
                    ),
                  ),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: AppColors.greyF1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => isMenuOpen.value = !isMenuOpen.value,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(selectedText),
                            const Spacer(),
                            SvgPicture.asset(AppResources.svgArrow, width: 24, height: 24)
                          ],
                        ),
                      )),
                ),
              ),
            ),
            DropdownMenu(
              dropdownMenuEntries: MyEnum.values
                  .map(
                    (e) => DropdownMenuEntry(
                        value: e,
                        label: e.name,
                        trailingIcon: SvgPicture.asset(
                          AppResources.svgRadio,
                          colorFilter: ColorFilter.mode(
                              e.name.contains(selectedText) ? AppColors.green : AppColors.grey4D, BlendMode.srcIn),
                        )),
                  )
                  .toList(),
              width: MediaQuery.of(context).size.width * 0.95,
              hintText: "Select",
              initialSelection: MyEnum.first,
              trailingIcon: SvgPicture.asset(AppResources.svgArrow, width: 24, height: 24),
              onSelected: (value) => setState(() {
                selectedText = value!.name;
              }),
              menuStyle: MenuStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                elevation: MaterialStateProperty.all(0),
              ),
              inputDecorationTheme: InputDecorationTheme(
                  isDense: false,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  constraints: const BoxConstraints(maxHeight: 44),
                  contentPadding: const EdgeInsets.only(top: 5, left: 8)),
            ),
          ],
        )),
      ),
    );
  }
}
