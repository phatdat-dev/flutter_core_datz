import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../flutter_core_datz.dart';
import 'widgets/task_animate_design_widget.dart';

class AppExceptionScreen extends StatelessWidget {
  const AppExceptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appExceptionController = GetIt.instance<AppExceptionController>();
    return GestureDetector(
      //unforcus keyboard
      onTap: () => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
      child: ListenableBuilder(
        listenable: appExceptionController,
        builder: (context, child) => Scaffold(
          //resizeToAvoidBottomInset: false,
          //backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Xem lỗi'),
            actions: const [
              Text(
                'filter here...(update later)',
                style: TextStyle(color: Colors.pink),
              ),
            ],
          ),
          body: Column(
            children: [
              Visibility(
                visible: appExceptionController.state.isNotEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: appExceptionController.onClear,
                      label: const Text('Clear', style: TextStyle(color: Colors.red)),
                      icon: const Icon(Icons.clear, color: Colors.red),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
              Expanded(
                  child: ListView.builder(
                // padding: EdgeInsets.zero,
                itemCount: appExceptionController.state.length,
                itemBuilder: (context, index) {
                  final item = appExceptionController.state[index];
                  final widget = TaskAnimateDesignWidget(
                    title: item.identifier,
                    statusTitle: item.statusCode?.toString(),
                    statusColor: Colors.red,
                    field: const {
                      "Time": 'time',
                      // "TimeProcess (milliseconds)": 'timeProcess',
                      "User": 'userName',
                      "ScreenRoute": 'route',
                      "LastAPI": 'urlApi',
                      "Device": 'infoDevice',
                      "Message": 'message',
                    },
                    data: item.toJson(),
                    imageAvatar: "https://www.plotterhpmilano.com/wp-content/uploads/2020/03/1200px-Error.svg.png",
                  );

                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) => appExceptionController.onDelete(item),
                    child: (index == 0)
                        ? Banner(
                            message: 'New',
                            location: BannerLocation.topStart,
                            child: widget,
                          )
                        : widget,
                  );
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
