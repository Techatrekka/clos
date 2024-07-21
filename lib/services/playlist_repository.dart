abstract class PlaylistRepository {
  Future<List<Map<String, String>>> fetchInitialPlaylist(String dirPath);
}

class DemoPlaylist extends PlaylistRepository {
  @override
  Future<List<Map<String, String>>> fetchInitialPlaylist(String dirPath,
      {int length = 3}) async {
    return List.generate(length, (index) => _nextSong(dirPath));
  }

  var _songIndex = 0;

  Map<String, String> _nextSong(String dirPath) {
    _songIndex = _songIndex + 1;
    return {
      'id': _songIndex.toString().padLeft(3, '0'),
      'title': 'Chapter $_songIndex',
      'album': 'SoundHelix',
      'url':
          // 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-$_songIndex.mp3',
          'file://$dirPath/$_songIndex.mp3'
    };
  }
}
