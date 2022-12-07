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
  attr_accessor :root

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
    return "No data of value #{value} found" if node == nil
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
      yield(curr) if block_given?
      result << curr.data
      queue << curr.left unless curr.left.nil?
      queue << curr.right unless curr.right.nil?
    end
    return result unless block_given?
  end
end

# test code
arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
tree = Tree.new(arr)
# tree.pretty_print
tree.insert(6444)
# tree.pretty_print
tree.insert(300)
# tree.pretty_print
# tree.delete(4)
# tree.pretty_print
# tree.delete(8)
tree.pretty_print
puts tree.find(17)
puts tree.find(6345)
p tree.level_order
tree.level_order{|data| puts data}