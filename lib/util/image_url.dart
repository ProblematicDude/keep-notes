//24-11-2021 03:19 PM

import 'package:notes/_app_packages.dart';
import 'package:notes/_internal_packages.dart';

const String imageAssets = 'assets/images/';
const String iconAssets = 'assets/icons/';
String splashImage1 = '${imageAssets}splash1.png';
const String splashImage2 = '${imageAssets}splash2.png';
const String splashImage3 = '${imageAssets}splash3.png';
const String github = '${imageAssets}github.svg';
const String me = '${imageAssets}me.svg';
const String men = '${imageAssets}men.png';
const String noNotes = '${imageAssets}noNotes.png';
const String telegram = '${imageAssets}telegram.svg';
const String women = '${imageAssets}women.png';
const String otp = '${imageAssets}otp.png';
const String githubProfile = 'https://github.com/nikhilbadyal';

const String googleIcon = '${iconAssets}google.svg';
const String facebookIcon = '${iconAssets}facebook.svg';
const String twitterIcon = '${iconAssets}twitter.svg';
const String errorSvg = '${iconAssets}error.svg';
const String lockSvg = '${iconAssets}lock.svg';
const String mailSvg = '${iconAssets}mail.svg';

typedef DoneCallBack = void Function(String text);
typedef OnTap = void Function();
typedef OnFabTap = void Function(BuildContext context, NoteState noteState);
typedef SlidableActions = Function(Note note, BuildContext context);
typedef PickerLayoutBuilder = Widget Function(
    BuildContext context, List<Color> colors, PickerItem child);
typedef PickerItem = Widget Function(Color color);
typedef PickerItemBuilder = Widget Function(Color color, OnTap changeColor,
    {required bool isCurrentColor});
typedef BackPresAction = Future<bool> Function();