import 'package:rive/rive.dart';

class RiveUtils {
  static SMIBool getRiveInput(Artboard artboard, {required String stateMachineName}) {
    StateMachineController? controller = StateMachineController.fromArtboard(artboard, stateMachineName);

    artboard.addController(controller!);

    return controller.findInput<bool>("active") as SMIBool;
  }

  static void chnageSMIBoolState(SMIBool input) {
    input.change(true);
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        input.change(false);
      },
    );
  }
}
