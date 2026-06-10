// lib/presentation/widgets/clickable_text.dart
//
// Widget that displays text with clickable URLs
//

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';

/// A widget that displays text with clickable URLs.
/// Automatically detects URLs in the text and makes them clickable.
class ClickableText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ClickableText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = style ?? theme.textTheme.bodyMedium;
    final linkStyle = defaultStyle?.copyWith(
      color: theme.colorScheme.primary,
      decoration: TextDecoration.underline,
      decorationColor: theme.colorScheme.primary,
    );

    // Regular expression to detect URLs
    final urlPattern = RegExp(
      r'https?://[^\s]+',
      caseSensitive: false,
    );

    final spans = <InlineSpan>[];
    int currentPosition = 0;

    for (final match in urlPattern.allMatches(text)) {
      // Add text before the URL
      if (match.start > currentPosition) {
        spans.add(
          TextSpan(
            text: text.substring(currentPosition, match.start),
            style: defaultStyle,
          ),
        );
      }

      // Add the clickable URL (without common trailing punctuation).
      final rawUrl = match.group(0)!;
      final cleanedUrl = _trimTrailingPunctuation(rawUrl);
      final trailingSuffix = rawUrl.substring(cleanedUrl.length);

      spans.add(
        TextSpan(
          text: cleanedUrl,
          style: linkStyle,
          recognizer: TapGestureRecognizer()
            ..onTap = () => _launchUrl(context, cleanedUrl),
        ),
      );

      if (trailingSuffix.isNotEmpty) {
        spans.add(
          TextSpan(
            text: trailingSuffix,
            style: defaultStyle,
          ),
        );
      }

      currentPosition = match.end;
    }

    // Add remaining text after the last URL
    if (currentPosition < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(currentPosition),
          style: defaultStyle,
        ),
      );
    }

    // If no URLs found, just return regular Text widget
    if (spans.isEmpty) {
      return Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    return RichText(
      text: TextSpan(children: spans),
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
    );
  }

  String _trimTrailingPunctuation(String url) {
    const trailingChars = '.,;:!?)]}"\'';
    var end = url.length;
    while (end > 0 && trailingChars.contains(url[end - 1])) {
      end--;
    }
    return url.substring(0, end);
  }

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    try {
      final url = Uri.parse(urlString);
      final launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.couldNotOpenUrl(urlString)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorOpeningUrl(e.toString())),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}

