class Match < ActiveRecord::Base
  has_many :moves
  belongs_to :player_x, class_name: "User"
  belongs_to :player_o, class_name: "User"
  belongs_to :winning_player, class_name: "User"
  belongs_to :losing_player, class_name: "User"

  # game data

  def board
    [0,1,2,3,4,5,6,7,8]
  end

  def winning_combinations
    [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
  end

  # tags

  def next_player_with_arrow(player)
    player == next_player && !complete? ? "⬅ next player" : ""
  end

  def player_result_with_arrow(player)
    if player == winning_player then "⬅ winner"
    elsif player == losing_player then "⬅ loser"
    else ""
    end
  end

  def player_result_tag(player)
    if player == winning_player then "good"
    elsif player == losing_player then "bad"
    else "neutral"
    end
  end

  def short_description(player)
    if complete?
      if won? then "won by #{winning_player.name}!"
      elsif drawn? then "draw"
      end
    else
      if player == next_player then "your turn"
      elsif player != next_player then "#{next_player}'s turn"
      end
    end
  end

  def long_description(player)
    if complete?
      if won? then "Game over - won by #{winning_player.name}!"
      elsif drawn? then "Game over - draw!"
      end
    else
      if player == next_player then "Game in progress - your turn!"
      elsif player != next_player then "Game in progress - #{next_player}'s turn!"
      end
    end
  end

  # basic gameplay

  # def pb
  #   populated_board = Array.new(9) { "-" }
  #   moves.each { |move| populated_board[move.cell] = move.marker }
  #   populated_board.each_slice(3) { |slice| puts slice.join(" ") }
  # end

  # def p(player, cell)
  #   Move.create(match_id: self.id, player_id: player.id, cell: cell, marker: marker(player))
  # end

  # AI

  # def ai
  #   p(next_player, auto_move(next_player))
  # end

  def auto_move(player)
    winning_move(player) || blocking_move(player) || progressive_move(player) || random_move
  end

  def winning_move(player)
    possible_cell(player, 2)
  end

  def blocking_move(player)
    possible_cell(opposite_player(player), 2)
  end

  def progressive_move(player)
    possible_cell(player, 1)
  end

  def random_move
    remaining_moves.shuffle.first
  end

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

  # check game

  def analyze!
    if won?
      self.update(complete?: true, winning_player_id: last_player.id, losing_player_id: next_player.id)
    elsif drawn?
      self.update(complete?: true)
    elsif computer_move?
      Move.create(match_id: self.id, player_id: next_player.id, cell: auto_move(next_player), marker: marker(next_player))
    end
  end

  def won?
    won_by?(player_x) || won_by?(player_o)
  end

  def won_by?(player)
    winning_combinations.any? do |combination|
      combination.all? do |cell|
        occupied_and_matches?(cell, player)
      end
    end
  end

  def drawn?
    moves.count == 9
  end

  def computer_move?
    next_player.role == "computer"
  end

  # last and next methods

  def last_move
    moves.last
  end

  def last_player
    return false if last_move.nil?
    last_move.player
  end

  def next_player
    if last_player == false then
      player_x
    else
      last_player == player_x ? player_o : player_x
    end
  end

  def opposite_player(player)
    player == player_x ? player_o : player_x
  end

  def marker(player)
    player == player_x ? "X" : "O"
  end

  def opposite_marker(marker)
    marker == "X" ? "O" : "X"
  end

  # move checking

  def occupied_and_matches?(cell, player)
    occupied?(cell) && matches?(cell, player)
  end

  def occupied?(cell)
    moves.where(cell: cell).any?
  end

  def empty?(cell)
    moves.where(cell: cell).empty?
  end

  def matches?(cell, player)
    moves.where(cell: cell).first.marker == marker(player)
  end

end