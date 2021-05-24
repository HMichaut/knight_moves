# Importing the unit test library
require "test/unit/assertions"
include Test::Unit::Assertions

class GameBoard
  attr_reader :width, :height

  def initialize(width, height)
    @width = width
    @height = height
  end
end

class KnightMovesTree
  attr_accessor :root, :already_played

  def initialize(start_posn)
    @game_board = GameBoard.new(8, 8)
    @already_played = [start_posn]
    @root = build_tree(start_posn)
  end

  # Posn -> Tree
  # Consumes a start posn and returns a Tree.
  def build_tree(start_posn, previous_posn = [])
    return Node.new(start_posn, previous_posn, nil) if previous_posn.length >= 6

    x = start_posn[0]
    y = start_posn[1]
    posn_array = [[x + 1, y + 2], [x + 2, y + 1], [x - 1, y - 2], [x - 2, y - 1], [x - 1, y + 2], [x - 2, y + 1], [x + 1, y - 2], [x + 2, y - 1]]
    posn_array = posn_array.select { |i| i[0].between?(0, @game_board.width - 1) && i[1].between?(0, @game_board.height - 1) }
    posn_array = posn_array.reject { |i| previous_posn.include?(i) }
    @already_played += posn_array
    node_array = nil
    node_array = posn_array.map { |i| build_tree(i, previous_posn + [start_posn]) } unless posn_array.empty?

    Node.new(start_posn, previous_posn, node_array)
  end

    # traverse the Tree in width and returns an array with the path
    def level_order_traversal(stop_posn, start_node = @root)
      queue = []
      queue.push(start_node)
      until queue.empty?
        current_node = queue.first
        queue += current_node.children unless current_node.children.nil?

        return current_node.parent + [current_node.posn] if current_node.posn == stop_posn

        queue.shift
      end
      Puts "Error"
    end
end

class Node
  attr_accessor :posn, :parent, :children

  def initialize(posn, parent = nil, children = nil)
    @posn = posn
    @parent = parent
    @children = children
  end
end

# Posn Posn -> [Array-of Posn]
# Consumes a posn representing the start position of the knight and another posn representing the end position of the
# knight. returns the shortest sequence to travel from start posn to end posn.
def knight_moves(start_posn, stop_posn)
  new_tree = KnightMovesTree.new(start_posn)
  new_tree.level_order_traversal(stop_posn)
end

# Unit tests
assert_equal knight_moves([0, 0], [1, 2]), [[0, 0], [1, 2]]
assert_equal knight_moves([0, 0], [3, 3]), [[0, 0], [1, 2], [3, 3]]
assert_equal knight_moves([3, 3], [0, 0]), [[3, 3], [2, 1], [0, 0]]
assert_equal knight_moves([3, 3], [4, 3]), [[3, 3], [4, 5], [2, 4], [4, 3]]
assert_equal (KnightMovesTree.new([3, 3]).already_played - (0..7).to_a.repeated_permutation(2).to_a), []

p knight_moves([0, 0], [6, 7])