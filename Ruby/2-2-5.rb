# PCCB 2-2-5
# -*- coding: utf-8 -*-

module Solver
  def Solver.solve(lengths)
    while lengths.cardinality >= 2
      min1 = lengths.pop
      min2 = lengths.pop
      lengths.push(min1.data + min2.data)
    end
    lengths.cardinality == 1 ? lengths.pop.data : 0
  end

  class Heap
    def initialize
      @elements = [nil]
    end

    def push(data)
      @elements << Element.new(data)
      bubble_up!
    end

    def pop
      node = @elements[1]
      bubble_down!
      node
    end

    def each
      block_given? or enum_for(:each)
      cloned = Marshal.load(Marshal.dump(self))
      while cloned.cardinality > 0
        yield cloned.pop
      end
    end

    def cardinality
      @elements.size - 1
    end

    def to_s
      @elements[1...@elements.size].join(',')
    end

    private

    def bubble_down!
      if self.cardinality > 1
        @elements[1] = @elements.last
        offset = 1
        left   = 2 * offset
        right  = 2 * offset + 1 <= @elements.size - 1 ? 2 * offset + 1 : nil

        while offset * 2 < @elements.size - 1
          if right && @elements[left] > @elements[right]
            smaller = right
          else
            smaller = left
          end

          if offset != 1 && @elements[offset] <= @elements[smaller]
            break
          end

          @elements[offset], @elements[smaller] = @elements[smaller], @elements[offset]
          offset = smaller
          left   = 2 * offset
          right  = 2 * offset + 1 < @elements.size - 1 ? 2 * offset + 1 : nil
        end
      end
      @elements.pop
    end

    def bubble_up!
      offset = @elements.size - 1
      parent = offset / 2

      while parent > 0 && @elements[parent] > @elements[offset]
        @elements[offset], @elements[parent] = @elements[parent], @elements[offset]
        offset = parent; parent /= 2
      end
    end

    def [](index)
      @elements[index + 1]
    end

    def []=(index, data)
      @elements[index + 1] = data
    end

    class Element
      include Comparable
      attr_reader :data

      def initialize(data=nil)
        @data = data
      end

      def <=>(other)
        self.data <=> other.data
      end

      def to_s
        self.data.to_s
      end
    end
  end
end

lengths = Solver::Heap.new

ARGV.each_with_index do |arg, index|
  begin
    length = Integer(arg)
    raise RangeError, "fence length must be greater than 0." if length <= 0
    lengths.push(length)
  rescue Exception => e
    puts e.to_s
    exit
  end
end

puts "result: %d" % Solver::solve(lengths)
