enum WhiteBoardToolType {
  Pencil("PENCIL"),
  WText("TEXT"),
  Eraser("ERASER"),
  SHAPES("SHAPES"),
  POINTER("POINTER");

  const WhiteBoardToolType(this.text);
  final String text;
}

enum SelectedWhiteBoardTool {
  Pencil("PENCIL"),
  Text("TEXT"),
  Eraser("ERASER"),
  Pointer("POINTER"),
  Rectangle("RECTANGLE"),
  Circle("CIRCLE"),
  Triangle("TRIANGLE"),
  Line("LINE"),
  Earser("EARSER");

  const SelectedWhiteBoardTool(this.text);
  final String text;
}
