# -*- coding: utf-8 -*-
# PCCB 2-1-3

module Solver
  DIRECTIONS = [
    {:dx =>  1, :dy =>  0},
    {:dx =>  0, :dy =>  1},
    {:dx =>  0, :dy => -1},
    {:dx => -1, :dy =>  0}
  ]

  def self.solve(map)
    bfs(map)
    current = map.goal.link
    while current != nil
      current.type = Trail::Type::SELECTED if current.type != Trail::Type::START
      current = current.link
    end
  end

  def self.bfs(map)
    map.start.cost = 0
    queue = [map.start]
    while queue.size > 0
      current = queue.shift
      for direction in Solver::DIRECTIONS
        next_row    = current.row + direction[:dx]
        next_column = current.column + direction[:dy]
        if map.valid_index?(next_row, next_column)
          neighbor = map[next_row, next_column]
          if (neighbor.type == Trail::Type::PATH || neighbor.type == Trail::Type::GOAL) && neighbor.cost >= current.cost + 1
            neighbor.cost = current.cost + 1
            neighbor.link = current
          end
          if not neighbor.visited? && neighbor.type != Trail::Type::GOAL
            neighbor.visited
            queue.push(neighbor)
          end
        end
      end
    end
  end

  class Trail
    module Type
      START    = 's'
      GOAL     = 'g'
      WALL     = 'w'
      PATH     = ' '
      SELECTED = '@'

      def self.include?(type)
        return type == Type::START || type == Type::GOAL || type == Type::WALL || Type::PATH || Type::SELECTED
      end
    end

    attr_accessor :row, :column, :cost, :link

    def initialize(row, column, type, cost=Float::INFINITY, link=nil)
      validate(type, cost, link)
      @row      = row
      @column   = column
      @type     = type
      @cost     = cost
      @link     = link
      @visited  = false
    end

    def type
      @type
    end

    def type=(type)
      raise TypeError, "invalid type for Trail type" if not Type::include?(type)
      @type = type
    end

    def visited?
      @visited
    end

    def visited
      @visited = true
    end

    def to_s
      @type
    end

    private

    def validate(type, cost, link)
      validated   = Type::include?(type)
      validated &&= cost == Float::INFINITY || cost.is_a?(Integer)
      validated &&= link == nil || link.kind_of?(Trail)
      raise TypeError, "invalid type for Trail class" if not validated
    end
  end

  class Maze
    attr_accessor :rows, :columns, :start, :goal

    def initialize(data, rows, columns)
      validate(data, rows, columns)
      @data    = data
      @rows    = rows
      @columns = columns
      @start   = nil
      @goal    = nil
      initialized!
    end

    def [](row, column)
      raise RangeError, "invalid access to maze" if not valid_index?(row, column)
      return @data[row][column]
    end

    def []=(row, column, data)
      raise RangeError, "invalid access to maze" if not valid_index?(row, column)
      raise TypeError,  "invalid access to maze" if not valid_trail?(data)
      @data[row][column] = data
    end

    def valid_index?(row, column)
      validated   = row.is_a?(Integer) && 0 <= row && row < @rows
      validated &&= column.is_a?(Integer) && 0 <= column && column < @columns
      return validated
    end

    def show
      for row in 0...@rows
        puts @data[row].join
      end
    end

    private

    def validate(data, rows, columns)
      validated   = data.kind_of?(Array) && data.all? {|array| array.kind_of?(Array)}
      validated &&= rows.is_a?(Integer) && rows >= 0
      validated &&= columns.is_a?(Integer) && columns >= 0
      raise TypeError, "invalid type for Maze class" if not validated
    end

    def initialized!
      for row in 0...@rows
        @data[row] = Array.new if @data[row] == nil
        for column in 0...@columns
          case @data[row][column]
          when Trail::Type::START then
            raise RangeError, "multiple start specified" if not @start == nil
            @start = Trail.new(row, column, Trail::Type::START)
            @data[row][column] = @start
          when Trail::Type::GOAL then
            raise RangeError, "multiple start specified" if not @goal == nil
            @goal = Trail.new(row, column, Trail::Type::GOAL)
            @data[row][column] = @goal
          when Trail::Type::PATH
            @data[row][column] = Trail.new(row, column, Trail::Type::PATH)
          else
            @data[row][column] = Trail.new(row, column, Trail::Type::WALL)
          end
        end
      end
    end

    def valid_trail?(data)
      return data.kind_of?(Trail)
    end
  end
end

$/      = 'END'
data    = [[]]
rows    = 0
columns = 0

lines = STDIN.gets.rstrip.split(/\r?\n/)
lines.each_with_index do |line, row|
  if row != lines.size - 1
    rows      = rows.succ
    columns   = columns > line.size ? columns : line.size
    data[row] = Array.new if data[row] == nil
    line.each_char.with_index do |c, column|
      data[row][column] = c
    end
  end
end

begin
  maze = Solver::Maze::new(data, rows, columns)
  Solver::solve(maze)
  maze.show
rescue TypeError, RangeError => e
  puts e.to_s
end