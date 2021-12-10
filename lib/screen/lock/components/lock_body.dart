import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class LockBody extends StatefulWidget {
  const LockBody({
    required this.doneCallBack,
    required this.title,
    this.onFingerTap,
    final Key? key,
  }) : super(key: key);

  final DoneCallBack doneCallBack;
  final OnTap? onFingerTap;
  final String title;

  @override
  _LockBodyState createState() => _LockBodyState();
}

class _LockBodyState extends State<LockBody> {
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
    );
    super.dispose();
  }

  // TODO fix orientation keypad
  @override
  Widget build(final BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            SvgPicture.asset(
              otp,
              height: 30 * heightMultiplier,
            ),
            SizedBox(
              height: 5 * heightMultiplier,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5 * heightMultiplier),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 3 * textMultiplier,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            PinCodeBoxes(
              pinPutController: _pinPutController,
              pinPutFocusNode: _pinPutFocusNode,
              doneCallBack: widget.doneCallBack,
            ),
            /*Expanded(
              flex: 2,
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                padding: const EdgeInsets.only(left: 50, right: 50),
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ...[1, 2, 3, 4, 5, 6, 7, 8, 9].map((final e) {
                    return RoundedButton(
                      pad: shouldPad(e.toString()),
                      title: Text(
                        '$e',
                        style: const TextStyle(fontSize: keyPadNumberSize),
                      ),
                      onTap: () {
                        if (_pinPutController.text.length >= (pinCodeLen + 1)) {
                          return;
                        }

                        _pinPutController.text = '${_pinPutController.text}$e';
                      },
                    );
                  }),
                  if (Provider.of<AppConfiguration>(context).bioNotAvailable ||
                      widget.onFingerTap == null)
                    Container()
                  else
                    RoundedButton(
                      title: const Icon(Icons.fingerprint_outlined),
                      onTap: widget.onFingerTap,
                    ),
                  RoundedButton(
                    title: const Text(
                      '0',
                      style: TextStyle(fontSize: keyPadNumberSize),
                    ),
                    onTap: () {
                      if (_pinPutController.text.length >= (pinCodeLen + 1)) {
                        return;
                      }

                      _pinPutController.text = '${_pinPutController.text}0';
                    },
                  ),
                  RoundedButton(
                    title: const Text(
                      '⌫',
                      style: TextStyle(fontSize: keyPadNumberSize),
                    ),
                    onTap: () {
                      if (_pinPutController.text.isNotEmpty) {
                        _pinPutController.text = _pinPutController.text
                            .substring(0, _pinPutController.text.length - 1);
                      }
                    },
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  bool shouldPad(final String string) {
    if (string == '1' || string == '2' || string == '3') {
      return false;
    }
    return true;
  }
}
