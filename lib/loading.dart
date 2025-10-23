import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:xmcs/helper/cs_loading.dart';

class XLoading extends CSLoading {
  int _loadingCount = 0;

  @override
  void show({String status = '加载中...'}) {
    _loadingCount++;
    if (_loadingCount == 1) {
      EasyLoading.show(status: status);
    }
  }

  @override
  void dismiss() {
    if (_loadingCount > 0) {
      _loadingCount--;
      if (_loadingCount == 0) {
        EasyLoading.dismiss();
      }
    }
  }

  @override
  void showSuccess(String message) {
    _loadingCount = 0;
    EasyLoading.showSuccess(message);
  }

  @override
  void showError(String message) {
    _loadingCount = 0;
    EasyLoading.showError(message);
  }

  @override
  void showInfo(String message) {
    _loadingCount = 0;
    EasyLoading.showInfo(message);
  }
}
