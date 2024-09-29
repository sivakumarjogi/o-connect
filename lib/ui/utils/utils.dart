String normalizeExitUrl(String url) {
  const String defaultUrl = 'https://www.onpassive.com';
  try {
    if (url.isEmpty) {
      return url;
    }

    final parsedUri = Uri.tryParse(url);

    if (parsedUri == null) {
      return defaultUrl;
    } else {
      if (parsedUri.authority.contains('http') || parsedUri.authority.contains('https')) {
        return defaultUrl;
      }

      if (parsedUri.toString().startsWith('https://') || parsedUri.toString().startsWith('http://')) {
        return parsedUri.toString();
      } else {
        return Uri.https(url).toString();
      }
    }
  } catch (e) {
    return defaultUrl;
  }
}
