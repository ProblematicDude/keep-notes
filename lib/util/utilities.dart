import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

enum IconColorStatus { noColor, pickedColor, uiColor }

MaterialColor createMaterialColor(Color color) {
  final strengths = <double>[0.05];
  final swatch = <int, Color>{};
  final r = color.red;
  final g = color.green;
  final b = color.blue;

  for (var i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (final strength in strengths) {
    final ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

Color getRandomColor() => Color(Random().nextInt(0xffffffff));

class Utilities {
  static late SharedPreferences prefs;
  static const passLength = 4;
  static const aboutMePic = 'me.png';
  static const appName = 'KeepNotes';

  static late FlutterSecureStorage storage;

  static Future<void> onModalHideTap(BuildContext context, Note note,
      Timer autoSaver, final Function() saveNote) async {
    final status =
        Provider.of<LockChecker>(context, listen: false).password.isNotEmpty;
    if (!status) {
      await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) => MyAlertDialog(
          title: Text(Language.of(context).message),
          content: Text(Language.of(context).setPasswordFirst),
        ),
      );
    } else {
      autoSaver.cancel();
      saveNote();
      final wantedRoute = getRoute(note.state);
      await Utilities.onHideTap(context, note);
      Navigator.of(context).popUntil(
        (route) => route.settings.name == wantedRoute,
      );
    }
  }

  static Future<void> onModalArchiveTap(BuildContext context, Note note,
      Timer autoSaver, final Function() saveNote) async {
    autoSaver.cancel();
    saveNote();
    final wantedRoute = getRoute(note.state);
    await Utilities.onArchiveTap(context, note);
    Navigator.of(context).popUntil(ModalRoute.withName(wantedRoute));
  }

  static Future<void> onModalUnArchiveTap(BuildContext context, Note note,
      Timer autoSaver, final Function() saveNote) async {
    autoSaver.cancel();
    saveNote();
    final wantedRoute = getRoute(note.state);
    await Utilities.onUnArchiveTap(context, note);
    Navigator.of(context).popUntil(
      (route) => route.settings.name == wantedRoute,
    );
  }

  static Future<void> onModalTrashTap(BuildContext context, Note note,
      Timer autoSaver, final Function() saveNote) async {
    autoSaver.cancel();
    saveNote();
    final wantedRoute = getRoute(note.state);
    await Utilities.onTrashTap(context, note);
    Navigator.of(context).popUntil(
      (route) => route.settings.name == wantedRoute,
    );
  }

  static Future<void> onModalCopyToClipboardTap(BuildContext context, Note note,
      Timer autoSaver, final Function() saveNote) async {
    autoSaver.cancel();
    saveNote();
    Navigator.of(context).pop();
    await Clipboard.setData(
      ClipboardData(text: note.title),
    );
    await Clipboard.setData(
      ClipboardData(text: note.content),
    ).then(
      (value) => Utilities.showSnackbar(context, Language.of(context).done,
          snackBarBehavior: SnackBarBehavior.floating),
    );
  }

  static Future<void> resetPassword(BuildContext context,
      {bool deleteAllNotes = false}) async {
    if (deleteAllNotes) {
      await Provider.of<NotesHelper>(context, listen: false).deleteAllHidden();
    } else {
      Utilities.showSnackbar(context, Language.of(context).done);
      unawaited(Provider.of<NotesHelper>(context, listen: false)
          .recryptEverything(
              Provider.of<LockChecker>(context, listen: false).password)
          .then((value) {
        if (value) {
          Utilities.showSnackbar(
              context, Language.of(context).setPassAndHideAgain);
        }
      }));
    }
    Utilities.showSnackbar(
      context,
      Language.of(context).passwordReset,
    );
    await Provider.of<LockChecker>(context, listen: false)
        .resetConfig(shouldResetBio: true);
    await navigate('', context, AppRoutes.homeScreen);
  }

  static Future<bool> launchUrl(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      return launch(url);
    } else {
      Utilities.getSnackBar(context, 'Unable to lanuch email app;');
      return false;
    }
  }

  static final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'nikhildevelops@gmail.com',
      queryParameters: {'subject': 'Suggestion/Issues for/in the app'});

  static String navChecker(NoteState state) {
    if (state == NoteState.archived) {
      return AppRoutes.archiveScreen;
    } else if (state == NoteState.hidden) {
      return AppRoutes.hiddenScreen;
    } else if (state == NoteState.deleted) {
      return AppRoutes.trashScreen;
    } else {
      return AppRoutes.homeScreen;
    }
  }

  static Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      final result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  static SnackBarAction resetAction(BuildContext context) => SnackBarAction(
        label: Language.of(context).reset,
        onPressed: () async {
          final status = await showDialog<bool>(
                barrierDismissible: false,
                context: context,
                builder: (context) => Center(
                  child: SingleChildScrollView(
                    child: MyAlertDialog(
                      title: Text(Language.of(context).message),
                      content: Text(
                          Language.of(context).deleteAllNotesResetPassword),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Text(Language.of(context).alertDialogOp1),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop(false);
                          },
                          child: Text(Language.of(context).alertDialogOp2),
                        ),
                      ],
                    ),
                  ),
                ),
              ) ??
              false;
          if (status) {
            await resetPassword(context, deleteAllNotes: true);
          }
        },
      );

  static void showSnackbar(BuildContext context, String data,
      {Duration duration = const Duration(seconds: 1),
      SnackBarBehavior? snackBarBehavior}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      Utilities.getSnackBar(context, data, snackBarBehavior: snackBarBehavior),
    );
  }

  static SnackBar getSnackBar(BuildContext context, String data,
          {Duration duration = const Duration(seconds: 1),
          SnackBarAction? action,
          SnackBarBehavior? snackBarBehavior}) =>
      SnackBar(
        key: UniqueKey(),
        content: Text(
          data,
        ),
        action: action,
        duration: duration,
        behavior: snackBarBehavior ?? Theme.of(context).snackBarTheme.behavior,
      );

  static Widget hideAction(BuildContext context, Note note) {
    return SlidableAction(
      icon: TablerIcons.ghost,
      label: Language.of(context).hide,
      backgroundColor: Colors.transparent,
      foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
      onPressed: (_) => onHideTap(context, note),
    );
  }

  static Future<void> onHideTap(BuildContext context, Note note) async {
    final status =
        Provider.of<LockChecker>(context, listen: false).password.isNotEmpty;
    if (!status) {
      await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) => MyAlertDialog(
          title: Text(Language.of(context).message),
          content: Text(Language.of(context).setPasswordFirst),
        ),
      );
    } else {
      final value =
          await Provider.of<NotesHelper>(context, listen: false).hide(note);
      if (!value) {
        Utilities.showSnackbar(
          context,
          Language.of(context).error,
        );
      }
    }
  }

  static Widget deleteAction(BuildContext context, Note note,
          {bool shouldAsk = true}) =>
      SlidableAction(
        icon: Icons.delete_forever_outlined,
        label: Language.of(context).delete,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
        onPressed: (_) => onDeleteTap(context, note, deleteDirectly: shouldAsk),
      );

  static Future<void> onDeleteTap(BuildContext context, Note note,
      {bool deleteDirectly = true}) async {
    var choice = true;
    if (!deleteDirectly) {
      choice = await showDialog<bool>(
            barrierDismissible: false,
            context: context,
            builder: (_) => MyAlertDialog(
              title: Text(Language.of(context).message),
              content: Text(Language.of(context).deleteNotePermanently),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(Language.of(context).alertDialogOp1),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(Language.of(context).alertDialogOp2),
                )
              ],
            ),
          ) ??
          false;
    }
    if (choice) {
      final value =
          await Provider.of<NotesHelper>(context, listen: false).delete(note);
      if (!value) {
        Utilities.showSnackbar(
          context,
          Language.of(context).error,
        );
      }
    }
  }

  static Widget trashAction(BuildContext context, Note note) {
    return SlidableAction(
      icon: Icons.delete_outline,
      label: Language.of(context).trash,
      backgroundColor: Colors.transparent,
      foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
      onPressed: (_) => onTrashTap(context, note),
    );
  }

  static Future<void> onTrashTap(BuildContext context, Note note) async {
    final value =
        await Provider.of<NotesHelper>(context, listen: false).trash(note);
    if (!value) {
      Utilities.showSnackbar(
        context,
        Language.of(context).error,
      );
    }
  }

  static Widget copyAction(BuildContext context, Note note) => SlidableAction(
        icon: TablerIcons.copy,
        label: Language.of(context).copy,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
        onPressed: (_) => onCopyTap(context, note),
      );

  static Future<void> onCopyTap(BuildContext context, Note note) async {
    final value =
        await Provider.of<NotesHelper>(context, listen: false).copy(note);
    if (!value) {
      Utilities.showSnackbar(
        context,
        Language.of(context).error,
      );
    }
  }

  static Widget archiveAction(BuildContext context, Note note) =>
      SlidableAction(
        icon: Icons.archive_outlined,
        label: Language.of(context).archive,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
        onPressed: (_) => onArchiveTap(context, note),
      );

  static Future<void> onArchiveTap(BuildContext context, Note note) async {
    final value =
        await Provider.of<NotesHelper>(context, listen: false).archive(note);
    if (!value) {
      Utilities.showSnackbar(
        context,
        Language.of(context).error,
      );
    }
  }

  static Widget unHideAction(BuildContext context, Note note) => SlidableAction(
        icon: Icons.drive_file_move_outline,
        label: Language.of(context).unhide,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
        onPressed: (_) => onUnHideTap(context, note),
      );

  static Future<void> onUnHideTap(BuildContext context, Note note) async {
    final value =
        await Provider.of<NotesHelper>(context, listen: false).unhide(note);
    if (!value) {
      Utilities.showSnackbar(
        context,
        Language.of(context).error,
      );
    }
  }

  static Widget unArchiveAction(BuildContext context, Note note) =>
      SlidableAction(
        icon: Icons.unarchive_outlined,
        label: Language.of(context).unarchive,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
        onPressed: (_) => onUnArchiveTap(context, note),
      );

  static Future<void> onUnArchiveTap(BuildContext context, Note note) async {
    final value =
        await Provider.of<NotesHelper>(context, listen: false).unarchive(note);
    if (!value) {
      Utilities.showSnackbar(
        context,
        Language.of(context).error,
      );
    }
  }

  static Widget restoreAction(BuildContext context, Note note) =>
      SlidableAction(
        icon: Icons.restore_from_trash_outlined,
        label: Language.of(context).restore,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
        onPressed: (_) => onRestoreTap(context, note),
      );

  static Future<void> onRestoreTap(BuildContext context, Note note) async {
    final value =
        await Provider.of<NotesHelper>(context, listen: false).undelete(note);
    if (!value) {
      Utilities.showSnackbar(
        context,
        Language.of(context).error,
      );
    }
  }

  static Future<void> onDeleteAllTap(BuildContext context) async {
    final value =
        await Provider.of<NotesHelper>(context, listen: false).emptyTrash();
    if (!value) {
      Utilities.showSnackbar(
        context,
        Language.of(context).error,
      );
    }
  }

  static Future<void> addStringToSF(String key, String value) async {
    try {
      await prefs.setString(key, value);
    } on Exception catch (_) {}
  }

  static Future<void> addBoolToSF(String key, {required bool value}) async {
    try {
      await prefs.setBool(key, value);
    } on Exception catch (_) {}
  }

  static Future<void> addIntToSF(String key, int value) async {
    try {
      await prefs.setInt(key, value);
    } on Exception catch (_) {}
  }

  static Future<void> addDoubleToSF(String key, double value) async {
    try {
      await prefs.setDouble(key, value);
    } on Exception catch (_) {}
  }

  static String? getStringFromSF(String key) {
    try {
      return prefs.getString(key);
    } on Exception catch (_) {}
  }

  static bool? getBoolFromSF(String key) {
    try {
      return prefs.getBool(key);
    } on Exception catch (_) {}
  }

  static int? getIntFromSF(String key) {
    try {
      return prefs.getInt(key);
    } on Exception catch (_) {}
  }

  static double? getDoubleFromSF(String key) {
    try {
      return prefs.getDouble(key);
    } on Exception catch (_) {}
  }

  static Future<void> removeValueFromSF(String key) async {
    try {
      await prefs.remove(key);
    } on Exception catch (_) {}
  }

  static bool checkKeyInSF(String key) {
    try {
      return prefs.containsKey(key);
    } on Exception catch (_) {
      return false;
    }
  }

  static void initialize(BuildContext context) {
    final curUser = Provider.of<Auth>(context, listen: false).auth.currentUser;
    encryption = Encrypt(curUser!.uid);
    Provider.of<LockChecker>(context, listen: false).password =
        encryption.decryptStr(Utilities.getStringFromSF('password')) ?? '';
    FirebaseDatabaseHelper(curUser.uid);
  }
}