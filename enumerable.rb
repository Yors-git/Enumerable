module Enumerable
  def my_each
    for i in self
      return to_enum(:my_each) if !block_given? 
      yield i
    end
  end

  def my_each_with_index
    index = 0
    for i in self 
      return to_enum(:my_each_with_index) if !block_given?
      yield i, index
      index += 1
    end
  end
  def my_select
    return to_enum(:my_select) if !block_given?
    new_arr = []
    my_each {|item| new_arr <<item if yield item}
    new_arr
  end

  def my_all?(parameter = nil)
    if block_given?
      to_a.my_each { |items| return false if yield(items) == false }
      return true
    elsif parameter.nil?
      to_a.my_each { |items| return false if items == false || items.nil?}
    elsif !parameter.nil? && (parameter.is_a? Class)
      to_a.my_each { |item| return false unless [item.class, item.class.superclass].include?(parameter)}
    elsif !parameter.nil? && parameter.class == Regexp
      to_a.my_each { |item| return false unless parameter.match(item) }
    else
      to_a.my_each { |item| return false if item != parameter}
    end
    true
  end

  def my_any?(parameter = nil)
    if block_given?
      to_a.my_each { |items| return true if yield(items) }
      return false
    elsif parameter.nil?
      to_a.my_each { |items| return true if items}
    elsif !parameter.nil? && (parameter.is_a? Class)
      to_a.my_each { |items| return true if [items.class].include?(parameter)}
    elsif !parameter.nil? && parameter.class == Regexp
      to_a.my_each { |items| return true if parameter.match(items)}
    else
      to_a.my_each { |items| return true if items == parameter}
    end
    false
  end

  def my_none?(arg = nil, &block)
    !my_any?(arg, &block)
  end

end


a = [5, 3, 3, 2, 4, 8, 3, 6, 5, 0, 1, 5, 1, 4, 0, 1, 0, 4, 0, 8, 4, 8, 6, 7, 8, 4, 0, 0, 6, 1, 0, 8, 4, 0, 6, 2, 4, 6, 0, 5, 3, 0, 2, 3, 4, 8, 7, 5, 6, 8, 8, 3, 0, 8, 3, 1, 8, 4, 4, 2, 6, 6, 2, 5, 6, 4, 4, 2, 3, 2, 7, 7, 1, 8, 2, 5, 4, 8, 7, 3, 1, 0, 5, 7, 1, 5, 1, 5, 1, 5, 1, 0, 0, 8, 7, 1, 1, 1, 4, 3] 

range = Range.new(5, 50) 

words = %w[dog door rod blade]

search = proc { |memo, word| memo.length > word.length ? memo : word }

# 1 *** my_each test

# ["A","B1","c","e","dad","eeeee"].my_each { |item| puts  item.length }
# a.my_each {|item| print item}
# puts a.my_each.is_a?(Enumerator)
# block = proc { |num| num < 4 }
# print a.each(&block)

# print range.each(&block)

# puts range.my_each(&block) == range.each(&block)  #true

# 2 ***my_each_with_index

# ["any","k","a","b","c","d","e"].my_each_with_index { |item,index|
#   puts "#{item} : #{index}"}
# a.my_each_with_index {|item,index| puts "#{item} & #{index}"}
# puts a.my_each_with_index.is_a?(Enumerator)
# block = proc { |num| num < 4 }
# print a.my_each_with_index(&block)

# puts range.my_each_with_index(&block) == range.each_with_index(&block)  #true

# 3 *** my_select test

# print a.my_select { |num| num.even?}
# print a.my_select.is_a?(Enumerator)

# 4 *** my_all? test

# puts %w[ant bear cat].my_all? { |word| word.length >= 3 } #=>true
# puts %w[ant bear cat].my_all? { |word| word.length >= 4 } #=>false
# puts %w[ant bear cat].my_all?(/t/) #=>false
# puts [1, 2i, 3.14].my_all?(Numeric) #=>true
# puts [nil, true, 99].my_all? #=>false
# puts [].my_all? #=>true
# puts a.my_all?(3) #=>false
# puts [1, "hi", true, []].my_all? #=>true 

# 5 *** my_any? test

# puts %w[ant bear cat].my_any? { |word| word.length >= 3 } #=> true
# puts %w[ant bear cat].my_any? { |word| word.length >= 4 } #=> true
# puts %w[ant bear cat].my_any?(/d/)                        #=> false
# puts [nil, true, 99].my_any?(Integer)                     #=> true
# puts [nil, true, 99].my_any?                              #=> true
# puts [].my_any?                                           #=> false
# puts words.my_any?('cat')                                 #=> false
# puts [  nil, false].my_any?                               #=> false


# # 6 *** my_none? test

# puts %w{ant bear cat}.my_none? { |word| word.length == 5 } #=> true
# puts %w{ant bear cat}.my_none? { |word| word.length >= 4 } #=> false
# puts %w{ant bear cat}.my_none?(/d/)                        #=> true
# puts [1, 3.14, 42].my_none?(Float)                         #=> false
# puts [].my_none?                                           #=> true
# puts [nil].my_none?                                        #=> true
# puts [nil, false].my_none?                                 #=> true
# puts [nil, false, true].my_none?                           #=> false
# puts words.my_none?(5)                                     #=> true
# puts [3, 4, 7, 11].my_none?(4)                             #=> false


# # 7 *** my_count? test

# ary = [1, 2, 4, 2]
# puts ary.my_count               #=> 4
# puts ary.my_count(2)            #=> 2
# puts ary.my_count{ |x| x%2==0 } #=> 3
# puts range.my_count             #=> 46

# # 8 *** my_map test

# print (1..4).my_map { |i| i * i } #=> [1, 4, 9, 16]
# random_proc = proc { |num| num * 2 }
# print (1..4).my_map(random_proc) #=> [2, 4, 6, 8]
# puts a.my_map.is_a?(Enumerator) #=> true 
# my_proc = proc { |num| num > 10 }
# print a.my_map(my_proc) { |num| num < 10 }

# # 9 *** my_inject test

# #Sum some numbers
# puts (5..10).my_inject(:+)                             #=> 45
# # Same using a block and inject
# puts (5..10).my_inject { |sum, n| sum + n }            #=> 45
# # Multiply some numbers
# puts (5..10).my_inject(1, :*)                          #=> 151200
# # Same using a block
# puts (5..10).my_inject(1) { |product, n| product * n } #=> 151200

# puts range.my_inject(:*)
# puts range.my_inject(2,:*)

# search = proc { |memo, word| memo.length > word.length ? memo : word }
# words = ["dog", "doooooor", "rod", "blade"] 


# puts words.my_inject(&search)
# puts words.my_inject




# # 10 *** multiply_els test

# puts multiply_els([2,4,5])