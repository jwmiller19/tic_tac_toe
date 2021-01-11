require_relative 'tic_tac_toe'

class TicTacToeNode
  attr_reader :board, :next_mover_mark, :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark =  next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  # overload to show children boards clearer, making debugging easier
  def inspect
    row_strings = board.rows.map(&:to_s)
    "\n@next_mover_mark: #{next_mover_mark}\n@board:\n#{row_strings.join("\n")}\n"
  end

  def losing_node?(evaluator)
    winner = board.winner

    # check for nil first so we can return false if it's a tie
    return false if board.over? && (winner.nil? || winner == evaluator)
    return true if board.over? && winner != evaluator

    if next_mover_mark == evaluator
      children.all? { |child| child.losing_node?(evaluator) }
    else
      children.any? { |child| child.losing_node?(evaluator) }
    end
  end

  def winning_node?(evaluator)
    winner = board.winner

    # check for nil first so we can return false if it's a tie
    return false if board.over? && (winner.nil? || winner != evaluator)
    return true if board.over? && winner == evaluator

    if next_mover_mark == evaluator
      children.any? { |child| child.winning_node?(evaluator) }
    else
      children.all? { |child| child.winning_node?(evaluator) }
    end
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    nodes = []
    rows = board.rows

    rows.each_index do |row|
      rows.each_index do |col|
        pos = [row, col]
        next unless board.empty?(pos)

        @prev_move_pos = pos
        next_node = TicTacToeNode.new(board.dup, alternate_mark, prev_move_pos)
        next_node.board[pos] = next_mover_mark

        nodes << next_node
      end
    end

    nodes
  end

  def alternate_mark
    if next_mover_mark == :x
      :o
    else
      :x
    end
  end
end
