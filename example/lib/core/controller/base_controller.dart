// ignore_for_file: depend_on_referenced_packages

enum EditMode {
  create,
  read,
  update,
  delete;

  bool get canEdit => this == EditMode.create || this == EditMode.update;
}

abstract class BaseController {
  BaseController() {
    // Printt.white('Create Controller: $runtimeType');
  }

  Future<void> onInitData();
  Future<void> onDispose() async {
    // Printt.white('Delete Controller: $runtimeType');
  }
}
