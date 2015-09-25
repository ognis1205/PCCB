# -*- coding: utf-8 -*-
# Summation

class Summation
  def initialize(*args)
    @memo = args
  end

  def binary_search(v, l, r)
    if l == r
      return l if @memo[l] == v
      return nil
    end
    m = (l + r) / 2
    if @memo[m] < v
      binary_search(v, m + 1, r)
    else
      binary_search(v, l, m)
    end
  end
end

#class Summation
#  def self.solution(sum, *args)
#    data   = args
#    (0...data.length).each do |i|
#      (i+1...data.length).each do |j|
#        (j+1...data.length).each do |k|
#          (k+1...data.length).each do |l|
#            if data[i] + data[j] + data[k] + data[l] == sum
#              print "found: #{data[i]}, #{data[j]}, #{data[k]}, #{data[l]}\n"
#            end
#          end
#        end
#      end
#    end
#  end
#end

$data = []
$sum  = 0

ARGV.each_with_index do |arg, i|
  if i == 0
    $sum = arg.to_i
  else
    $data << arg.to_i
  end
end

#Summation.solution($sum, *$data)
summation = Summation.new(*$data)
print "parameter: #{$sum}\n"
print "parameter: #{$data}\n"
print "found: #{summation.binary_search($sum, 0, $data.length - 1)}\n"
