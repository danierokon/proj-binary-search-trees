class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end

  def to_s
    "node value = #{@data}, left child = #{@left == nil ? "no child found" : @left.data}, right child = #{@right == nil ? "no child found": @right.data}"
  end
end

class Tree
  attr_accessor :root, :sorted

  def initialize(array)
    @sorted = array.sort.uniq
    @root = build_tree(@sorted)
  end

  def build_tree(array)
    return nil if array.empty?

    mid = (array.length)/2
    Node.new(array[mid], build_tree(array[0...mid]), build_tree(array[mid+1..-1]))
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value)
    insert_rec(@root, value)
  end

  def insert_rec(node = @root, value)
    return node = Node.new(value) if node == nil
    node.left = insert_rec(node.left, value) if value < node.data
    node.right = insert_rec(node.right, value) if value > node.data
    return node
  end

  def min_node(node)
    min = node
    min_parent = nil
    # track min_parent while finding min, delete min from parent before returning min
    while node.left != nil
      min_parent = min
      min = node.left
      node = node.left
    end
    min_parent.left = nil
    min
  end

  def delete(value)
    delete_rec(@root, value)
  end

  def delete_rec(node = @root, value)
    return node if node == nil

    node.left = delete_rec(node.left, value) if value < node.data
    node.right = delete_rec(node.right, value) if value > node.data
    if node.data == value
      return node.right if node.left == nil

      return node.left if node.right == nil

      # keep trying to find the minimum value on the right tree when node has 2 children, then delete min node
      min = min_node(node.right)
      # copy data from min node
      node.data = min.data
    end
    node
  end

  def find(value)
    find_rec(@root, value)
  end

  def find_rec(node = @root, value)
    return nil if node == nil
    return node if node.data == value

    if value < node.data
      node = find_rec(node.left, value)
    elsif value > node.data
      node = find_rec(node.right, value)
    end

    node
  end

  def level_order
    queue = [@root]
    result = []
    until queue.empty?
      curr = queue.shift
      yield(curr.data) if block_given?
      result << curr.data
      queue << curr.left unless curr.left.nil?
      queue << curr.right unless curr.right.nil?
    end
    return result unless block_given?
  end

  def inorder(node = @root, array = [], &block)
    # L O R
    return if node == nil

    inorder(node.left, array, &block)
    block_given? ? yield(node.data) : array << node.data
    inorder(node.right, array, &block)

    array unless block_given?
  end

  def preorder(node = @root, array = [], &block)
    # O L R
    return if node == nil

    block_given? ? yield(node.data) : array << node.data
    preorder(node.left, array, &block)
    preorder(node.right, array, &block)

    array unless block_given?
  end

  def postorder(node = @root, array = [], &block)
    # O L R
    return if node == nil

    postorder(node.left, array, &block)
    postorder(node.right, array, &block)
    block_given? ? yield(node.data) : array << node.data

    array unless block_given?
  end

  # start at target node, find longest path downward, return max height
  def height(value, node = find(value))
    return -1 if node.nil?

    left_height = height(value, node.left)
    right_height = height(value, node.right)
    height = [left_height, right_height].max + 1
    return height
  end

# start at root, stop at target, +1 depth (from 0) for every recur called
  def depth(value, curr = @root)
    return nil unless find(value)
    return 0 if curr.data == value

    target = depth(value, curr.left) if value < curr.data
    target = depth(value, curr.right) if value > curr.data
    depth = target + 1
    return depth
  end

  def balanced?
    balance = false
    left_height = height(@root.left.data, @root.left)
    right_height = height(@root.right.data, @root.right)
    balance = true if (left_height - right_height).abs <= 1
    balance
  end

  def rebalance
    array = self.inorder
    self.sorted = array.sort.uniq
    self.root = build_tree(array)
  end

end

# test code
# arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
# tree = Tree.new(arr)
array = Array.new(15){rand(1..100)}
a_tree = Tree.new(array)
p a_tree.balanced?
p a_tree.level_order
p a_tree.preorder
p a_tree.postorder
p a_tree.inorder
6.times {a_tree.insert(rand(101..200))}
p a_tree.balanced?
# a_tree.pretty_print
a_tree.rebalance
p a_tree.balanced?
p a_tree.level_order
p a_tree.preorder
p a_tree.postorder
p a_tree.inorder