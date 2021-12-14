import '../../../models/dashboard_tile_item.model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/controllers.dart';
import '../../theme/text_theme.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'Home',
          style: AppTextStyle(
            color: context.theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const _RiderStatusSwitch(),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: controller.dashboardItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _DashboardTile(item: controller.dashboardItems[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiderStatusSwitch extends StatefulWidget {
  const _RiderStatusSwitch({Key? key}) : super(key: key);

  @override
  _RiderStatusSwitchState createState() => _RiderStatusSwitchState();
}

class _RiderStatusSwitchState extends State<_RiderStatusSwitch> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RiderController>(
      builder: (logic) {
        return SwitchListTile(
          activeColor: context.theme.colorScheme.primary,
          value: logic.rider.riderStatus as bool,
          title: const Text(
            'Rider Status',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onChanged: logic.changeRiderStatus,
        );
      },
    );
  }
}

class _DashboardTile extends StatelessWidget {
  const _DashboardTile({
    Key? key,
    required this.item,
  }) : super(key: key);
  final DashboardTileItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        child: Card(
          child: SizedBox(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  item.image,
                  fit: BoxFit.cover,
                  width: 80,
                  height: 80,
                ),
                Text(
                  item.title,
                  style: AppTextStyle(
                    fontSize: 15.0,
                    // color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: item.onTap,
      ),
    );
  }
}
