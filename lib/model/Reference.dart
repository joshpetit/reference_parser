class Reference {
  String reference;
  final String book;
  final int chapter;
  final int start_verse;
  final int end_verse;
  bool is_valid;

  Reference(this.book, [this.chapter, this.start_verse, this.end_verse]) {
    reference = book;
    if (chapter != null) {
      reference += ' ${chapter}';
      if (start_verse != null) {
        reference += ':${start_verse}';
        if (end_verse != null) {
          reference += '-$end_verse';
        }
      }
    }
    is_valid = validate();
  }

  bool validate() {
    return true;
  }
}
