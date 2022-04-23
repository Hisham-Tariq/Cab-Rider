import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class DashboardTileItem {
  String title;
  String image;
  Callback onTap;
  DashboardTileItem(this.title, this.image, this.onTap);
}
