import 'package:attributed_text/attributed_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';
import 'package:super_editor/src/default_editor/attributions.dart';
import 'package:super_editor/src/infrastructure/_logging.dart';
import 'package:super_editor/src/regex/hashtag_regular_expression.dart';

/// Creates the desired [TextStyle] given the [attributions] associated
/// with a span of text.
///
/// The [attributions] set may be empty.
typedef AttributionStyleBuilder = TextStyle Function(Set<Attribution> attributions);

extension ToSpanRange on TextRange {
  SpanRange toSpanRange() => SpanRange(start: start, end: end);
}

extension ComputeTextSpan on AttributedText {
  /// Returns a Flutter [TextSpan] that is styled based on the
  /// attributions within this [AttributedText].
  ///
  /// The given [styleBuilder] interprets the meaning of every
  /// attribution and constructs [TextStyle]s accordingly.
  TextSpan computeTextSpan(
    AttributionStyleBuilder styleBuilder, {
    void Function(String)? onSpanTap,
  }) {
    attributionsLog.fine('text length: ${text.length}');
    attributionsLog.fine('attributions used to compute spans:');
    attributionsLog.fine(spans.toString());

    if (text.isEmpty) {
      // There is no text and therefore no attributions.
      attributionsLog.fine('text is empty. Returning empty TextSpan.');
      return TextSpan(text: '', style: styleBuilder({}));
    }

    spans.markers.removeWhere((m) => m.attribution.id == hashtagAttKey);

    final matches = hashTagRegExp.allMatches(text);
    for (final match in matches) {
      spans.addAttribution(
        newAttribution: Attribution(
            hashtagAttKey, {hashtagAttKey: match.group(0)?.trim() ?? ''}),
        start: match.start,
        end: match.end - 1,
      );
    }

    final collapsedSpans = spans.collapseSpans(contentLength: text.length);
    final textSpans = collapsedSpans.map(
      (attributedSpan) {
        final att = attributedSpan.attributions
            .firstWhereOrNull((att) => att.id == hashtagAttKey);

        GestureRecognizer? recognizer;
        if (att != null && att.id == hashtagAttKey) {
          recognizer = TapGestureRecognizer()
            ..onTap = () => onSpanTap?.call(att.data[hashtagAttKey]);
        }

        return TextSpan(
          text: text.substring(attributedSpan.start, attributedSpan.end + 1),
          style: styleBuilder(attributedSpan.attributions),
          recognizer: recognizer,
        );
      },
    ).toList();

    return textSpans.length == 1
        ? textSpans.first
        : TextSpan(
            children: textSpans,
            style: styleBuilder({}),
          );
  }
}
