class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data = nil, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end
end

class Tree
  attr_accessor :root

  def initialize(array, start, end_point)
    @root = build_tree(array, start, end_point)
  end

  def build_tree(array, start, end_point)
    return nil if start > end_point
    sorted = array.sort.uniq
    mid = (start + end_point)/2
    
    Node.new(sorted[mid], build_tree(sorted, start, mid-1), build_tree(sorted, mid+1, end_point))
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
end


arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
tree = Tree.new(arr, 0, arr.length-1)
tree.insert(22)
tree.pretty_print