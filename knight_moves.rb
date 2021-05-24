# frozen_string_literal: true

# Importing the unit test library
require 'test/unit/assertions'
include Test::Unit::Assertions

# Represents the tree of possible moves for a knight
class KnightMovesTree
  attr_accessor :root, :already_played

  def initialize(start_posn)
    @width = 8
    @height = 8
    @root = Node.new(start_posn)
  end

  # Node -> [Array-of Nodes]
  # Consumes a parent node and returns an array of the children nodes
  def children_creation(parent_node)
    start_posn = parent_node.posn
    input_parent = parent_node.parent + [parent_node.posn]
    moves_creation(start_posn).map { |posn| Node.new(posn, input_parent) }
  end

  # Posn -> [Array-of Posns]
  # Consumes a posn and returns an array of the children posn
  def moves_creation(start_posn)
    x = start_posn[0]
    y = start_posn[1]
    posn_array = [[x + 1, y + 2], [x + 2, y + 1], [x - 1, y - 2], [x - 2, y - 1],
                  [x - 1, y + 2], [x - 2, y + 1], [x + 1, y - 2], [x + 2, y - 1]]
    posn_array.select { |posn| check_if_valid(posn) }
  end

  # Posn -> Boolean
  # Consumes a posn and determine if it is within the area of the game board
  def check_if_valid(posn)
    posn[0].between?(0, @width - 1) && posn[1].between?(0, @height - 1)
  end

  # Posn -> [Array-of Posns]
  # Consume the stop position and create a tree level by level until a node is equal to the stop point.
  # Returns an Array of posn indicating the necessary moves to reach the stop posn.
  def build_tree(stop_posn)
    start_node = @root
    queue = [start_node]
    until queue.empty?
      current_node = queue.first
      current_node_children = children_creation(current_node)
      current_node.children = current_node_children
      queue += current_node_children
      return current_node.parent + [current_node.posn] if current_node.posn == stop_posn

      queue.shift
    end
  end
end

# Represents a node in the knight moves tree
class Node
  attr_accessor :posn, :parent, :children

  def initialize(posn, parent = [], children = [])
    @posn = posn
    @parent = parent
    @children = children
  end
end

# Posn Posn -> [Array-of Posn]
# Consumes a posn representing the start position of the knight and another posn representing the end position of the
# knight. returns the shortest sequence to travel from start posn to end posn.
def knight_moves(start_posn, stop_posn)
  result_array = knight_moves_aux(start_posn, stop_posn)
  puts "you made it in #{result_array.length} moves! here's your path:"
  result_array.each { |i| p i }
end

# Aux function for unit test purpose
def knight_moves_aux(start_posn, stop_posn)
  new_tree = KnightMovesTree.new(start_posn)
  new_tree.build_tree(stop_posn)
end

# Unit tests
assert_equal knight_moves_aux([0, 0], [1, 2]), [[0, 0], [1, 2]]
assert_equal knight_moves_aux([0, 0], [3, 3]), [[0, 0], [1, 2], [3, 3]]
assert_equal knight_moves_aux([3, 3], [0, 0]), [[3, 3], [2, 1], [0, 0]]
assert_equal knight_moves_aux([3, 3], [4, 3]), [[3, 3], [4, 5], [2, 4], [4, 3]]

knight_moves([0, 0], [6, 7])
