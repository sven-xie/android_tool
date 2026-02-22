import 'package:android_tool/page/android_log/android_log_page.dart';
import 'package:android_tool/page/common/base_page.dart';
import 'package:android_tool/page/feature_page/feature_page.dart';
import 'package:android_tool/page/flie_manager/file_manager_page.dart';
import 'package:android_tool/page/main/devices_model.dart';
import 'package:android_tool/widget/adb_setting_dialog.dart';
import 'package:android_tool/widget/text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main_view_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends BasePage<MainPage, MainViewModel> {
  @override
  initState() {
    super.initState();
    viewModel.init();
  }

  @override
  Widget contentView(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: const Color(0xFF292929),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("images/app_logo.png", width: 200, height: 200),
          const SizedBox(height: 50),
          Container(
            width: 300,
            height: 80,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                viewModel.startActiveAdb(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFF666666),
                ),
                alignment: Alignment.center,
                child: const TextView(
                  "开始激活",
                  fontSize: 24,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 300,
            height: 80,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                openBrowser();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFF666666),
                ),
                alignment: Alignment.center,
                child: const TextView(
                  "视频教程",
                  fontSize: 24,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContent(int value) {
    // if (value == 0) {
    //   return DevicesInfoPage(
    //     deviceId: viewModel.deviceId,
    //     packageName: viewModel.packageName,
    //   );
    // } else
    if (value == 1) {
      return FeaturePage(
        deviceId: viewModel.deviceId,
      );
    } else if (value == 2) {
      return FileManagerPage(viewModel.deviceId);
    } else if (value == 3) {
      return AndroidLogPage(deviceId: viewModel.deviceId);
    } else if (value == 4) {
      return AdbSettingDialog(viewModel.adbPath);
    } else {
      return Container();
    }
    ;
  }

  Widget _leftItem(String image, String name, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          openBrowser();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: index == viewModel.selectedIndex
                ? Colors.blue.withOpacity(0.32)
                : Colors.transparent,
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Row(
            children: <Widget>[
              SvgPicture.asset(
                image,
                width: 23,
                height: 23,
              ),
              const SizedBox(width: 10),
              TextView(name),
            ],
          ),
        ),
      ),
    );
  }

  Widget devicesView() {
    return InkWell(
      onTap: () {
        viewModel.devicesSelect(context);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 10),
          Selector<MainViewModel, DevicesModel?>(
            selector: (context, viewModel) => viewModel.device,
            builder: (context, device, child) {
              return Container(
                child: Text(
                  device?.itemTitle ?? "未连接设备",
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            width: 5,
          ),
          const Icon(
            Icons.arrow_drop_down,
            color: Color(0xFF666666),
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }

  Future<void> openBrowser() async {
    final Uri url = Uri.parse(
        "https://www.bilibili.com/video/BV15w4m1v7iA/?share_source=copy_web&vd_source=1e7670b6b13bc4209015ad49d7a01151");

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication, // 强制外部浏览器
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  createViewModel() {
    return MainViewModel(context);
  }
}
