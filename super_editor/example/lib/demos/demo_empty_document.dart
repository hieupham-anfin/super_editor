import 'dart:io';

import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';
import 'package:super_editor_markdown/super_editor_markdown.dart';

/// An empty document.
///
/// This demo allows us to verify conditions related to empty content:
///  - the layout doesn't throw errors when content is empty
///  - the layout doesn't contract to zero when content is empty
///  - tapping anywhere will place the caret when there's no content
///
/// This demo can also be used to quickly hack experiments and tests.
class EmptyDocumentDemo extends StatefulWidget {
  @override
  _EmptyDocumentDemoState createState() => _EmptyDocumentDemoState();
}

class _EmptyDocumentDemoState extends State<EmptyDocumentDemo> {
  late Document _doc;
  late DocumentEditor _docEditor;
  late DocumentComposer _composer;
  late CommonEditorOperations _ops;
  late GlobalKey _layoutKey;

  String _markdown = '';

  @override
  void initState() {
    super.initState();
    _doc = _createDocument1();
    _docEditor = DocumentEditor(document: _doc as MutableDocument);
    _composer = DocumentComposer();
    _ops = CommonEditorOperations(
      editor: _docEditor,
      composer: _composer,
      documentLayoutResolver: () => _layoutKey.currentState as DocumentLayout,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SuperEditor(
              editor: _docEditor,
              composer: _composer,
              gestureMode: Platform.isAndroid
                  ? DocumentGestureMode.android
                  : DocumentGestureMode.iOS,
              inputSource: DocumentInputSource.ime,
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Stack(
            children: [
              SuperIgnorePointer(
                shouldIgnorePointer: false,
                child: SingleColumnDocumentLayout(
                  presenter: SingleColumnLayoutPresenter(
                    document: deserializeMarkdownToDocument(_markdown),
                    componentBuilders: defaultComponentBuilders,
                    pipeline: [
                      SingleColumnStylesheetStyler(stylesheet: defaultStylesheet),
                    ],
                  ),
                  componentBuilders: defaultComponentBuilders,
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: TextButton(
                  onPressed: () {
                    _markdown = serializeDocumentToMarkdown(_doc);
                    setState(() {});
                  },
                  child: Text('Parse'),
                ),
              ),
            ],
          ),
          MultiListenableBuilder(
            listenables: <Listenable>{
              _doc,
              _composer.selectionNotifier,
            },
            builder: (_) {
              final selection = _composer.selection;

              if (selection == null) {
                return const SizedBox();
              }

              return KeyboardEditingToolbar(
                document: _doc,
                composer: _composer,
                commonOps: _ops,
              );
            },
          ),
        ],
      ),
    );
  }
}

Document _createDocument1() {
  return MutableDocument(
    nodes: [
      ParagraphNode(id: "1", text: AttributedText(text: "")),
    ],
  );
}
