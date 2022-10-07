import 'package:flutter_test/flutter_test.dart';
import 'package:super_editor/src/parser/parser.dart';
import 'package:super_editor/super_editor.dart';

final _testDoc = MutableDocument(nodes: [
  ParagraphNode(
    id: DocumentEditor.createNodeId(),
    text: AttributedText(
      text: 'Ready-made solutions 📦',
    ),
  ),
  ListItemNode.unordered(
    id: DocumentEditor.createNodeId(),
    text: AttributedText(
      text:
          'SuperEditor is a ready-made, configurable document editing experience.',
      spans: AttributedSpans(attributions: [
        SpanMarker(
          attribution: boldAttribution,
          offset: 0,
          markerType: SpanMarkerType.start,
        ),
        SpanMarker(
          attribution: boldAttribution,
          offset: 10,
          markerType: SpanMarkerType.end,
        ),
      ]),
    ),
  ),
  ListItemNode.ordered(
    id: DocumentEditor.createNodeId(),
    text: AttributedText(
      text: 'SuperTextField is a ready-made, configurable text field.',
    ),
  ),
]);

void main() {
  test('', () async {
    final list = _testDoc.toJson();
    print(list);
    final nodes = DocumentParser.fromJson(list);
    print('@@@@@');
    print(nodes[0] is ParagraphNode);
    print(nodes[1] is ListItemNode);
    print(nodes[2] is ListItemNode);
  });
}
