 String generateChatId({required String id1, required String id2}) {
    List<String> ids = [id1, id2];
    ids.sort();
    return ids.join('_');
  }