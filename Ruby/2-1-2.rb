# -*- coding: utf-8 -*-
# PCCB 2-1-2

module Solver
  DX = [1,  1,  1,  0,  0, -1, -1, -1]
  DY = [1,  0, -1,  1, -1,  1,  0, -1]
  @result = 0

  def self.solve(map)
    for row in 0...map.row
      for column in 0...map.column
        if dfs(map, row, column)
          @result = @result.succ
        end
      end
    end
    return @result
  end

  def self.dfs(map, row, column)
    if map[row, column] == Map::LAKE
      map[row, column] = Map::WALKED
      for i in 0...DX.size
        dfs(map, row + DY[i], column + DX[i]) if valid?(row + DY[i], 0, map.row) && valid?(column + DX[i], 0, map.column)
      end
      return true
    end
    return false
  end

  def self.valid?(index, left, right)
    return left <= index && index < right
  end

  class Map
    attr_accessor :row, :column

    LAKE   = 'w'
    WALKED = '-'
    LAND   = '*'

    def initialize(map, row, column)
      validated?(map, row, column)
      @map    = map
      @row    = row
      @column = column
      prepare!
    end

    def [](row, column)
      validated   = row.is_a?(Integer) && row >= 0 && row < @row
      validated &&= column.is_a?(Integer) && column >= 0 && column < @column
      raise RangeError, "invalid access to map data" if not validated
      return @map[row][column]
    end

    def []=(row, column, data)
      validated   = row.is_a?(Integer) && row >= 0 && row < @row
      validated &&= column.is_a?(Integer) && column >= 0 && column < @column
      raise RangeError, "invalid access to map data" if not validated
      if data == Solver::Map::LAKE || data == Solver::Map::LAND || data == Solver::Map::WALKED
        @map[row][column] = data
      end
    end

    def debug
      for row in @map
        for column in row
          print column
        end
        print "\n"
      end
    end

    private

    def validated?(map, row, column)
      validated   = row.is_a?(Integer) && row >= 0
      validated &&= column.is_a?(Integer) && column >= 0
      validated &&= map.kind_of?(Enumerable) && map.all? {|array| array.kind_of?(Enumerable)}
      raise TypeError, "invalid map data type" if not validated
    end

    def prepare!
      for row in 0...@row
        @map[row] = Array.new if @map[row] == nil
        for column in 0...@column
          @map[row][column] = LAND if @map[row][column] == nil
        end
      end
    end
  end
end

$/      = "END"
map     = [[]]
rows    = 0
columns = 0

lines = STDIN.gets.rstrip.split(/\r?\n/)
lines.each_with_index do |line, row|
  if row != lines.size - 1
    rows = rows.succ
    columns = columns > line.size ? columns : line.size
    map[row] = Array.new if map[row] == nil
    line.each_char.with_index do |c, column|
      if c == Solver::Map::LAKE.upcase || c == Solver::Map::LAKE
        map[row][column] = Solver::Map::LAKE
      else
        map[row][column] = Solver::Map::LAND
      end
    end
  end
end

begin
  problem = Solver::Map.new($map, $row, $column)
  result  = Solver::solve(problem)
  puts "result: #{result}"
rescue TypeError, RangeError => e
  puts e.to_s
  exit
end