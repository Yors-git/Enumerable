# rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Style/IdenticalConditionalBranches
module Enumerable
  def my_each
    each do |i|
      return to_enum(:my_each) unless block_given?

      yield i
    end
  end

  def my_each_with_index
    index = 0
    each do |i|
      return to_enum(:my_each_with_index) unless block_given?

      yield i, index
      index += 1
    end
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    new_arr = []
    my_each { |item| new_arr << item if yield item }
    new_arr
  end

  def my_all?(parameter = nil)
    if block_given?
      to_a.my_each { |items| return false if yield(items) == false }
      return true
    elsif parameter.nil?
      to_a.my_each { |items| return false if items == false || items.nil? }
    elsif !parameter.nil? && (parameter.is_a? Class)
      to_a.my_each { |item| return false unless [item.class, item.class.superclass].include?(parameter) }
    elsif !parameter.nil? && parameter.class == Regexp
      to_a.my_each { |item| return false unless parameter.match(item) }
    else
      to_a.my_each { |item| return false if item != parameter }
    end
    true
  end

  def my_any?(parameter = nil)
    if block_given?
      to_a.my_each { |items| return true if yield(items) }
      return false
    elsif parameter.nil?
      to_a.my_each { |items| return true if items }
    elsif !parameter.nil? && (parameter.is_a? Class)
      to_a.my_each { |items| return true if [items.class].include?(parameter) }
    elsif !parameter.nil? && parameter.class == Regexp
      to_a.my_each { |items| return true if parameter.match(items) }
    else
      to_a.my_each { |items| return true if items == parameter }
    end
    false
  end

  def my_none?(arg = nil, &block)
    !my_any?(arg, &block)
  end

  def my_count(parameter = nil)
    counter = 0
    if block_given?
      my_each { |items| counter += 1 if yield(items) }
    elsif parameter
      my_each { |items| counter += 1 if items == parameter }
    else
      counter = size
    end
    counter
  end

  def my_map(proc = nil)
    return to_enum(:my_map) unless block_given? || !proc.nil?

    array = []
    if proc.nil?
      to_a.my_each { |items| array << yield(items) }
    else
      to_a.my_each { |items| array << proc.call(items) }
    end
    array
  end

  def my_inject(*args)
    if args.empty? && !block_given?
      raise TypeError, "Please provide an argument"

    elsif args.size == 2
      raise TypeError, "#{args[1]} is not a symbol" unless args[1].is_a?(Symbol)

      my_each { |item| args[0] = args[0].send(args[1], item) }
      args[0]
    elsif args.size == 1 && !block_given?
      raise TypeError, "#{args[0]} is not a symbol" unless args[0].is_a?(Symbol)

      memo = first
      drop(1).my_each { |item| memo = memo.send(args[0], item) }
      memo
    else
      memo = args[0] || first
      if memo == args[0]
        my_each { |item| memo = yield(memo, item) if block_given? }
        memo
      else
        drop(1).my_each { |item| memo = yield(memo, item) if block_given? }
        memo
      end
    end
  end
end

def multiply_els(arr)
  arr.my_inject(:*)
end
# rubocop: enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Style/IdenticalConditionalBranches
