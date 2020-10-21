# rubocop: disable Layout/LineLength
require '../enumerable.rb'

describe Enumerable do
  let(:arr) { [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }
  let(:range) { Range.new(5, 15) }
  let(:words) { %w[ant bear cat] }
  let(:my_proc) { proc { |num| num * 2 } }
  let(:search) { proc { |memo, word| memo.length > word.length ? memo : word } }
  let(:my_words) { %w[dog doooooor rod blade] }

  describe '#my_each' do
    it 'iterates over each element of a given array' do
      expect(arr.my_each { |x| puts x }).to eql(arr.each { |x| puts x })
    end

    it 'iterates the given block within the given range' do
      expect(range.my_each { |x| puts x }).to eql(range.each { |x| puts x })
    end

    it 'checks if method is part of the module' do
      expect((arr.my_each).is_a?(Enumerable)).to be(true)
    end
  end

  describe '#my_each_with_index' do
    it 'returns each item with its index' do
      expect(words.my_each_with_index { |item, index| puts "#{item} : #{index}" }).to eql(words.each_with_index { |item, index| puts "#{item} : #{index}" })
    end

    it 'checks if method is part of the module' do
      expect(arr.my_each_with_index.is_a?(Enumerable)).to be(true)
    end
  end

  describe '#my_select' do
    it 'checks if it returns an array of only even numbers' do
      expect(arr.my_select(&:even?)).to contain_exactly(2, 4, 6, 8, 10)
    end

    it 'checks if method is part of the module' do
      expect((arr.my_select).is_a?(Enumerable)).to be(true)
    end
  end

  describe '#my_all?' do
    it 'checks if all elements passed comply with a condition' do
      expect(words.my_all? { |word| word.length >= 3 }).to be(true)
    end

    it 'checks if the method returns true with an empty array' do
      expect([].my_all?).to be(true)
    end
  end

  describe '#my_any?' do
    it 'checks if at least one item complies with the a condition' do
      expect(words.my_any? { |word| word.length >= 4 }).to be(true)
    end

    it 'checks if method returns false with an empty array' do
      expect([].my_any?).to be(false)
    end
  end

  describe '#my_none?' do
    it 'checks if none element complies with the given condition' do
      expect(words.my_none? { |word| word.length > 4 }).to be(true)
    end

    it 'if an element is present in an array' do
      expect(!arr.my_none?(11)).to eql(false)
    end
  end

  describe '#my_count' do
    it 'counts the elements on an array' do
      expect(arr.my_count).to eql(arr.length)
    end

    it 'counts the elements that satisfy a condition' do
      expect(arr.my_count(&:even?)).to eql(5)
    end
  end

  describe '#my_map' do
    it 'performs a given math operation on each element of the array' do
      expect(arr.my_map(my_proc)).to eql([2, 4, 6, 8, 10, 12, 14, 16, 18, 20])
    end

    it 'takes a range and perform an operation on each element in that range' do
      expect(range.my_map(my_proc)).to eql([10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30])
    end
  end

  describe '#my_inject' do
    it 'performs an indicated operation with all the elements in a range' do
      expect(range.my_inject(:+)).to eql(110)
    end

    it 'returns an item accordingly to the passed proc' do
      expect(my_words.my_inject(&search)).to eql('doooooor')
    end
  end
end
# rubocop: enable Layout/LineLength
