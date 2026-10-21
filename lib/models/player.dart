/// The two players. Player 1 sits at the bottom, Player 2 at the top.
enum Player {
  one('Player 1'),
  two('Player 2');

  const Player(this.defaultName);

  final String defaultName;

  Player get opponent => this == Player.one ? Player.two : Player.one;
}
