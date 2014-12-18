class Match < ActiveRecord::Base
  has_many :moves
  belongs_to :player_x, class_name: "User"
  belongs_to :player_o, class_name: "User"
  belongs_to :winning_player, class_name: "User"
  belongs_to :losing_player, class_name: "User"

  # game data

  def board() [0,1,2,3,4,5,6,7,8] end
  def winning_combinations() [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]] end

  # check game

  def check_and_update!
    if won?
      self.update(status: "won", winning_player_id: last_player.id, losing_player_id: next_player.id)
    elsif drawn?
      self.update(status: "drawn")
    elsif next_player_is_computer?
      Move.create(match_id: self.id, player_id: next_player.id, cell: auto_move(next_player), marker: marker(next_player))
      check_and_update!
    end
  end

  def won? () won_by?(player_x) || won_by?(player_o) end
  def drawn?() moves.count == 9 end
  def next_player_is_computer?() next_player.role?(:computer) end

  def won_by?(player)
    winning_combinations.any? do |combination|
      combination.all? do |cell|
        occupied_and_matches?(cell, player)
      end
    end
  end

  def occupied_and_matches?(cell, player) occupied?(cell) && matches?(cell, player) end
  def occupied?(cell) moves.where(cell: cell).any? end
  def empty?(cell) moves.where(cell: cell).empty? end
  def matches?(cell, player) moves.where(cell: cell).first.marker == marker(player) end

  # helper methods

  def last_move() moves.last end
  def last_player() if last_move.nil? then false else last_move.player end end
  def next_player() last_player == false || last_player == player_o ? player_x : player_o end
  def opponent(player) player == player_x ? player_o : player_x end
  def marker(player) player == player_x ? "X" : "O" end

  # AI

  def auto_move(player)
    winning_move(player) || blocking_move(player) || progressive_move(player) || random_move
  end

  def winning_move(player) possible_cell(player, 2) end
  def blocking_move(player) possible_cell(opponent(player), 2) end
  def progressive_move(player) possible_cell(player, 1) end
  def random_move() remaining_moves.shuffle.first end

  def remaining_moves
    board.delete_if do |cell|
      occupied?(cell)
    end
  end

  def possible_cell(player, count)
    return false if possible_column(player, count).nil?
    possible_column(player, count).detect do |cell|
      empty?(cell)
    end
  end

  def possible_column(player, count)
    winning_combinations.detect do |combination|
      times_in_combination(combination, player) == count
    end
  end

  def times_in_combination(combination, player)
    combination.count do |cell|
      occupied_and_matches?(cell, player)
    end
  end

  # output methods

  def next_player?(player) player == next_player end
  def winning_player?(player) player == winning_player end

  def short_description(player)
    case status
    when "in progress" then next_player?(player) ? "your turn" : "waiting for opponent"
    when "won" then winning_player?(player) ? "won" : "lost"
    when "drawn" then "draw"
    end
  end

  def long_description(player)
    case status
    when "in progress" then next_player?(player) ? "Your turn!" : "Waiting for opponent!"
    when "won" then winning_player?(player) ? "Game over - won!" : "Game over - lost!"
    when "drawn" then "Game over - draw!"
    end
  end

  def player_indicator(player)
    case status
    when "in progress" then next_player?(player) ? "⬅ next player" : ""
    when "won" then winning_player?(player) ? "⬅ winner" : "⬅ loser"
    end
  end

  def player_tag(player)
    case status
    when "won" then winning_player?(player) ? "good" : "bad"
    when "drawn" then "neutral"
    end
  end

end