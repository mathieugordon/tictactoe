class Match < ActiveRecord::Base
  has_many :moves
  belongs_to :player_x, class_name: "User"
  belongs_to :player_o, class_name: "User"

  # game data

  def board
    [0,1,2,3,4,5,6,7,8]
  end

  def winning_combinations
    [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
  end

  # basic gameplay

  # def print_board
  #   populated_board = Array.new(9) { "-" }
  #   moves.each { |move| populated_board[move.cell] = move.marker }
  #   populated_board.each_slice(3) { |slice| puts slice.join(" ") }
  # end

  # def play(player, cell)
  #   Move.create(match_id: self.id, player_id: player.id, cell: cell, marker: marker(player))
  # end

  # AI

  def ai
    play(next_player, auto_move(next_player))
  end

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

  def finished?
    won? || drawn?
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

  def set_result!
    if won?
      self.update(complete?: true, winner: last_player.id, loser: next_player.id)
    else
      self.update(complete?: true)
    end
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