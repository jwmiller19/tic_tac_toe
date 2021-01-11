require_relative 'tic_tac_toe_node'

class SuperComputerPlayer < ComputerPlayer
  def move(game, mark)
    move_tree = TicTacToeNode.new(game.board, mark).children

    # Pick a winning move if it exists
    move_tree.each do |child|
      if child.winning_node?(mark)
        return child.prev_move_pos
      end
    end

    # If there are no winning moves, pick any non-losing move (force draw)
    move_tree.each do |child|
      return child.prev_move_pos unless child.losing_node?(mark)
    end

    raise "Something went wrong! Could not find a move that causes a win or draw."
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Play the brilliant computer!"
  hp = HumanPlayer.new("Jeff")
  cp = SuperComputerPlayer.new

  TicTacToe.new(hp, cp).run
end
