import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class HiddenNoteOptions extends StatefulWidget {
  const HiddenNoteOptions({
    required this.note,
    required this.autoSaver,
    required this.saveNote,
    final Key? key,
  }) : super(key: key);

  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  _HiddenNoteOptionsState createState() => _HiddenNoteOptionsState();
}

class _HiddenNoteOptionsState extends State<HiddenNoteOptions> {
  void saveNoteAndCancelTimer() {
    widget.autoSaver.cancel();
    widget.saveNote();
    context.navigator.popUntil(
      ModalRoute.withName(widget.note.path),
    );
  }

  @override
  Widget build(final BuildContext context) => Wrap(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_outlined),
                  onPressed: context.previousPage,
                ),
                const SizedBox(width: 16),
                Text(Language.of(context).options),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Column(
              children: [
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    ModalSheetWidget(
                      onTap: () async {
                        saveNoteAndCancelTimer();
                        unawaited(
                          Provider.of<NotesHelper>(context, listen: false)
                              .trash(widget.note),
                        );
                      },
                      icon: Icons.drive_file_move_outline,
                      label: Language.of(context).unhide,
                    ),
                    ModalSheetWidget(
                      onTap: () {
                        saveNoteAndCancelTimer();
                        unawaited(
                          ohArchiveTap(
                            context,
                            widget.note,
                          ),
                        );
                      },
                      label: Language.of(context).archive,
                      icon: Icons.archive_outlined,
                    ),
                    CopyToClipBoardModelSheetWidget(
                      widget.note,
                    ),
                    ModalSheetWidget(
                      icon: Icons.delete_outlined,
                      onTap: () {
                        saveNoteAndCancelTimer();
                        unawaited(
                          ohTrashTap(
                            context,
                            widget.note,
                          ),
                        );
                      },
                      label: Language.of(context).delete,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      );
}