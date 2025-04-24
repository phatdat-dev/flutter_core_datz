import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_core_datz/flutter_core_datz.dart";
import "package:flutter_form_builder/flutter_form_builder.dart";
import "package:get_it/get_it.dart";

import "../../../../app/app_constants.dart";
import "../../../generated/assets.gen.dart";
import "../../authentication/login/controller/login_controller.dart";
import "../controller/user_controller.dart";

@RoutePage()
class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  final controller = GetIt.instance<UserController>();

  Map<String, dynamic>? request;

  @override
  void initState() {
    super.initState();
    request = controller.state.value?.toJson();
  }

  InputDecoration _hideInputDecoration({String? hintText}) {
    final border = UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).highlightColor));
    return InputDecoration(
      filled: false,
      border: border,
      enabledBorder: border,
      focusedBorder: border,
      disabledBorder: border,
      hintText: hintText,
      constraints: const BoxConstraints(maxHeight: 35.0), //LINK - :213
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            controller.state.builder(
              (context, user) => ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              Container(
                                height: 200.0 + kToolbarHeight,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(fit: BoxFit.cover, image: NetworkImage("https://picsum.photos/1500/800")),
                                ),
                              ),
                              Positioned(
                                top: 100.0 + kToolbarHeight,
                                child: Container(
                                  height: 190.0,
                                  width: 190.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: HelperWidget.imageProviderFrom(Assets.images.logo.logo512x512.path),
                                    ),
                                    color: Colors.white,
                                    border: Border.all(color: Theme.of(context).colorScheme.surface, width: 6.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 100),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                user?.resPartner?.name ?? "",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(width: 5.0),
                              Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingContent),
                            child: Column(
                              children: [
                                buildInfomation(),
                                if (GetIt.instance<UserController>().state.value != null)
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final result = await showDialog<bool>(
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                title: const Text("Xác nhận xóa tài khoản"),
                                                content: const Text(
                                                  "Tài khoản của bạn sẽ bị xóa vĩnh viễn trong vòng 30 ngày nếu không sử dụng. Bạn có chắc chắn muốn xóa tài khoản?",
                                                ),
                                                actions: [
                                                  TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("Hủy")),
                                                  FilledButton(
                                                    onPressed: () {
                                                      LoginController.onLogout();
                                                      // Navigator.of(context).pop(true);
                                                    },
                                                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                                                    child: const Text("Xóa tài khoản"),
                                                  ),
                                                ],
                                              ),
                                        );
                                        if (result == true) {}
                                      },
                                      child: const Text("Xóa tài khoản", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: kToolbarHeight,
              left: 10,
              child: Material(
                color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
                shape: const CircleBorder(),
                child: const BackButton(),
              ),
            ),
          ],
        ),
        // bottomNavigationBar: ActionBottomMenu(
        //   popupMenuButtonMore: PopupMenuButtonMore(
        //     onSelected: (value) {},
        //     itemBuilder: (context) => [],
        //   ),
        //   fastActionWidgets: [
        //     Expanded(
        //       child: CustomActionButton(
        //         iconRight: Icons.save_outlined,
        //         color: Colors.green,
        //         title: "Cập nhật",
        //         onTap: () {},
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }

  Widget buildInfomation() {
    final data = [
      {
        "label": "UserName",
        "fieldName": "user_name",
        "icon": const Icon(Icons.person_outline, color: Colors.green),
        "format": "text",
        "enable": false,
      },
      {
        "label": "Tên",
        "fieldName": "res_partner.name",
        "icon": const Icon(Icons.person_outline, color: Colors.amber),
        "format": "text",
        "enable": false,
      },
      {
        "label": "Email",
        "fieldName": "res_partner.email",
        "icon": const Icon(Icons.mail_outline, color: Colors.cyan),
        "format": "email",
        "enable": false,
      },
      {
        "label": "Điện thoại",
        "fieldName": "res_partner.mobile",
        "icon": const Icon(Icons.phone_outlined, color: Colors.brown),
        "format": "number",
        "enable": false,
      },
      {
        "label": "Năm sinh",
        "fieldName": "res_partner.yob",
        "icon": const Icon(Icons.calendar_month_outlined, color: Colors.blue),
        "format": "number",
        "enable": false,
      },
      {
        "label": "Giới tính",
        "fieldName": "res_partner.gender",
        "icon": const Icon(Icons.transgender_outlined, color: Colors.pink),
        "format": "number",
        "enable": false,
      },
      // {
      //   "label": "Mật khẩu củ",
      //   "fieldName": "PasswordOld",
      //   "icon": const Icon(Icons.password_outlined, color: Colors.red),
      //   "format": "text",
      //   "enable": false,
      // },
      // {
      //   "label": "Mật khẩu mới",
      //   "fieldName": "PasswordNew",
      //   "icon": const Icon(Icons.password_outlined, color: Colors.red),
      //   "format": "text",
      //   "enable": false,
      // },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(data.length, (index) {
          final item = data[index];

          final key = item["fieldName"].toString();
          if (key.split(".").isNotEmpty) {
            final keys = key.split(".");
            if (keys.length > 1) {
              final key1 = keys[0];
              final key2 = keys[1];
              final value = request?[key1]?[key2];
              request?[key] = value;
            }
          }
          final String text = request?[key] as String? ?? "";
          TextInputType? keyboardType;
          switch (item["format"]) {
            case "number":
              keyboardType = TextInputType.number;
              break;
            case "email":
              keyboardType = TextInputType.emailAddress;
              break;
            default:
              keyboardType = TextInputType.text;
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 13.0), //LINK - :37
                  child: Row(children: [item["icon"] as Widget, const SizedBox(width: 5.0), Text("${item["label"]}: ")]),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      switch (item["format"]) {
                        case "date":
                          return FormBuilderDateTimePicker(
                            name: item["fieldName"] as String,
                            initialValue: DateTime.tryParse(text),
                            enabled: item["enable"] as bool? ?? true,
                            inputType: InputType.date,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                            decoration: _hideInputDecoration(),
                            onChanged: (newValue) {
                              request?[item["fieldName"] as String] = newValue?.toIso8601String();
                              // controller.state.value = controller.state.value?.fromJson(value!);
                            },
                          );
                        case "dropdown":
                          return FormBuilderDropdown(
                            name: item["fieldName"] as String,
                            initialValue: text.toUpperCase(), //!
                            enabled: item["enable"] as bool? ?? true,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                            decoration: _hideInputDecoration(),
                            items: (item["options"] as List<String>).map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                            onChanged: (newValue) {
                              request?[item["fieldName"] as String] = newValue?.toLowerCase();
                              // controller.state.value = controller.state.value?.fromJson(value!);
                            },
                          );
                        default:
                          return Opacity(
                            opacity: item["enable"] as bool? ?? true ? 1.0 : 0.5,
                            child: FormBuilderTextField(
                              name: item["fieldName"] as String,
                              initialValue: text,
                              keyboardType: keyboardType,
                              enabled: item["enable"] as bool? ?? true,
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                              decoration: _hideInputDecoration(),
                              onChanged: (newValue) {
                                request?[item["fieldName"] as String] = newValue;
                                // controller.state.value = controller.state.value?.fromJson(value!);
                              },
                            ),
                          );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }),
        // const SizedBox(height: 10.0),
        // SizedBox(
        //   width: double.infinity,
        //   child: ElevatedButton(
        //     onPressed: () {},
        //     child: const Text("see more about Mohsin"),
        //   ),
        // ),
      ],
    );
  }
}
