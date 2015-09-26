# -*- coding: utf-8 -*-
# PCCB 1-6-1

class Solver
  def initialize(a)
    if a.kind_of?(Array) && a.all? {|x| x.is_a? Integer} then @a = a else @a = [] end
    @a.sort! {|x, y| y <=> x}
  end

  def solve
    for i in 0...@a.size
      for j in (i+1)...@a.size
        for k in (j+1)...@a.size
          if @a[i] < @a[j] + @a[k]
            puts "answer: #{@a[i] + @a[j] + @a[k]}"
            return
          end
        end
      end
    end
    puts "no answer found"
  end

  def debug
    puts @a
  end
end

$a = []
ARGV.each do |arg|
  $a << arg.to_i
end

solver = Solver.new($a)
solver.solve