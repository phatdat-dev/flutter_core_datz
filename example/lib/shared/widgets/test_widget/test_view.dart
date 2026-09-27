import 'package:auto_route/auto_route.dart';
import 'package:material_ui/material_ui.dart';

@RoutePage()
class TestView extends StatefulWidget {
  const TestView({super.key});

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
