class Node
    attr_accessor :data, :right, :left
    def initialize (data=nil, right=nil, left=nil)
        @data=data
        @right=right
        @left=@left
    end
end
class Tree
    attr_accessor :root, :array
    def initialize (array)
        @array=array.uniq.sort
        @root= build_tree(@array)
    end
    def build_tree(array)
        if array.length == 1
            Node.new(array[0])
        elsif array.length == 0
            nil
        else
            root=array[array.length/2]
            node=Node.new(root)
            left=array[0..((array.length/2)-1)]
            right=array[array.length/2+1..array.length-1]
            node.left=build_tree(left)
            node.right=build_tree(right)
            return node
        end
    end
    def insert(value, node=@root)
        if value > node.data
            if node.right != nil
                node=node.right
                insert(value, node)
            else
                node.right=Node.new(value)
            end
        elsif value < node.data
            if node.left != nil
                node=node.left
                insert(value, node)
            else
                node.left=Node.new(value)
            end
        end
    end
    def delete(value, node=@root, parent_node=nil)
        if value == node.data && parent_node != nil
            if node.right == nil && node.left == nil            # leaf node
                if parent_node.right == node
                    parent_node.right = nil
                elsif parent_node.left == node
                    parent_node.left = nil
                end
            elsif node.right == nil && node.left != nil     # left child
                if parent_node.right == node
                    parent_node.right=node.left
                elsif parent_node.left == node
                    parent_node.left == node.left
                end
            elsif node.right != nil && node.left == nil     #right child
                if parent_node.right == node
                    parent_node.right=node.right
                elsif parent_node.left == node
                    parent_node.left == node.right
                end
            else                                            #both children
                sup_node=node.right
                while sup_node.left != nil
                    sup_node=sup_node.left
                end
                delete(sup_node.data)
                sup_node.left=node.left
                sup_node.right=node.right
                if parent_node.right.data == value
                    parent_node.right=sup_node
                elsif parent_node.left.data == value
                    parent_node.left=sup_node
                end
            end
        elsif value > node.data
            parent_node = node
            node = node.right
            delete(value, node, parent_node)
        elsif value < node.data
            parent_node = node
            node = node.left
            delete(value, node, parent_node)
        end
    end
    def find(value, node=@root)
        if value > node.data
            node=node.right
            find(value, node)
        elsif value < node.data
            node=node.left
            find(value, node)
        elsif value == node.data
            return node
        end
    end
    def level_order
        node=@root
        arr=[]
        queue=[node]
        while !node.nil?
            queue.push(node.left) if node.left != nil
            queue.push(node.right) if node.right != nil
            arr.push(node.data)
            queue.shift
            node=queue[0]
        end
        return arr
    end
    def preorder(node=@root)
        arr=[]
        arr.push(node.data)
        (preorder(node.left)).each {|element| arr.push(element)} if node.left != nil
        (preorder(node.right)).each {|element|arr.push(element)} if node.right != nil
        return arr
    end
    def inorder(node=@root)
        arr=[]
        (inorder(node.left)).each {|element| arr.push(element)} if node.left != nil
        arr.push(node.data)
        (inorder(node.right)).each {|element|arr.push(element)} if node.right != nil
        return arr
    end
    def postorder(node=@root)
        arr=[]
        (postorder(node.left)).each {|element| arr.push(element)} if node.left != nil
        (postorder(node.right)).each {|element|arr.push(element)} if node.right != nil
        arr.push(node.data)
        return arr
    end
    def height(node=@root)
        h=0
        if node !=nil && (node.right != nil || node.left != nil)
            arr=inorder(node)
            if arr.length>0
                if arr.length/2 <= arr.index(node.data)
                    node=node.left
                    h=h+height(node)
                else
                    node=node.right
                    h=h+height(node)
                end
                h+=1
            end
        end
        return h
    end
    def depth(node)
        d=0
        temp_node=@root
        while node != temp_node
            if node.data < temp_node.data
                temp_node = temp_node.left
            else
                temp_node = temp_node.right
            end
            d+=1
        end
        return d      
    end
    def balanced?(node=@root)
        if height(node) != 0
            if ((height(node.left) - height(node.right))*(height(node.left) - height(node.right))) <= 2
                if balanced?(node.left)
                    balanced?(node.right)
                else
                    return false
                end
            else
                return false
            end
        else
            return true
        end
    end
    def rebalance
        @array = level_order.uniq.sort
        @root = build_tree(@array)
    end
end
t=Tree.new(Array.new(15) {rand(1..100)})
t.balanced?
t.preorder
t.inorder
t.postorder
t.level_order
t.insert(210)
t.insert(220)
t.insert(240)
t.balanced?
t.rebalance
t.balanced?
t.preorder
t.inorder
t.postorder
t.level_order
