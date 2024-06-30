class MazeCoordinate
{
  final int column;
  final int row;

  MazeCoordinate(this.column,this.row);

  /// Sets the == operator to check if the column and row are equal.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MazeCoordinate &&
              runtimeType == other.runtimeType &&
              column == other.column &&
              row == other.row;

  @override
  int get hashCode => super.hashCode + column + row;

}