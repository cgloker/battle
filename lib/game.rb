class Game

  @instance = nil

  attr_reader :player_one, :player_two, :turns

  def initialize(player_one, player_two)
    @player_one = player_one
    @player_two = player_two
    @turns = {attacker: player_one, attacked: player_two}
    self.class.instance = self
  end

  def self.instance
    @instance
  end

  def self.instance=(something)
    @instance = something
  end

  def attack
    turns[:attacked].deduct_points
  end

  def switch_turn
    if turns[:attacker] == player_one
      @turns = {attacker: player_two, attacked: player_one}
    else
      @turns = {attacker: player_one, attacked: player_two}
    end
  end

  def game_over?
    player_one.points <= 0 || player_two.points <= 0
  end

end
