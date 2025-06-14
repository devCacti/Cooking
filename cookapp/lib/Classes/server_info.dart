//! | v | Release | . | Edition | . | Major | . | Patch |
//? v      : Version
//? Release: 0 = Alpha, 1 = Beta, 2 = RC (Release Candidate), 3 = Stable (It's considered Extreme Major)
//? Edition: 0 = Base, 5 = Half, 10 = Full
//? Major  : Any major changes to the app without changing functionality or design (Design changes are considered major)
//? Patch  : Any minor changes to the app, like bug fixes or small changes to the design

class ServerInfo {
  static const String url = 'https://devcacti.com';
  static const String version = 'Dev 1.7.1.1:001 - Marisa';
  //!static const String apiUrl = '$url/api'; //TODO: use this in the app instead of the url
  static const String apiVersion = 'v1';
  //!static const String apiFullUrl = '$apiUrl/$apiVersion'; //TODO: use this in the app instead of the url
}

// The devcacti.com is the official server for devCacti, and it should not be used for Cooking's api, instead we should use
// cooking.devCacti.com or cooking.devcacti.com, but for now we will use devcacti.com as the official server for Cooking
