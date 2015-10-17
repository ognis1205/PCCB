# PCCB 2-1-3
# -*- coding: utf-8 -*-

import sys
from functools import wraps

class EnumType(type):
    def __init__(clazz, name, bases, attributes):
        super(EnumType, clazz).__init__(name, bases, attributes)
        clazz._values = []
        for key, value in attributes.iteritems():
            if EnumType._check_if_enum_instance(key, value):
                instance = clazz(key, value)
                setattr(clazz, key, instance)
                clazz._values.append(instance)

    def __iter__(clazz):
        return iter(clazz._values)

    @staticmethod
    def _check_if_enum_instance(key, value):
        return not hasattr(value, '__call__') and key.isupper()


class Enum(object):
    __metaclass__ = EnumType

    def __init__(self, key, value):
        self.key = key
        self.value = value

    def __repr__(self):
        return self.value if isinstance(self.value, str) else repr(self.value)

    def __eq__(self, other):
        return self.key == other.key and self.value == other.value if isinstance(other, self.__class__) else False


class Generative(object):
    @staticmethod
    def chain(func):
        @wraps(func)
        def decorator(self, *args, **kargs):
            func(self, *args, **kargs)
            return self
        return decorator


class Solver(object):
    @staticmethod
    def solve(maze):
        Solver.first_walk(maze)
        Solver.second_walk(maze)

    @staticmethod
    def first_walk(maze):
        queue = Solver.Queue(maze.start.set_cost(0).set_previous(None))
        while not queue.is_empty():
            current = queue.dequeue()
            for variation in Solver.Variations:
                next_row = current.row + variation['dx']
                next_column = current.column + variation['dy']
                if maze.has_index(next_row, next_column):
                    neighbor = maze[next_row][next_column]
                    cost = current.cost + 1
                    if neighbor.cell != Solver.Cells.WALL and cost < neighbor.cost:
                        neighbor.set_cost(cost).set_previous(current)
                        queue.enqueue(neighbor)

    @staticmethod
    def second_walk(maze):
        trail = maze.goal
        while trail:
            if trail.cell == Solver.Cells.PATH:
                trail.set_cell(Solver.Cells.WALKED)
            trail = trail.previous

    class Variations(Enum):
        UP    = {'dx' :  0, 'dy' :  1}
        RIGHT = {'dx' :  1, 'dy' :  0}
        DOWN  = {'dx' :  0, 'dy' : -1}
        LEFT  = {'dx' : -1, 'dy' :  0}

        def __getitem__(self, key):
            return self.value[key]

    class Cells(Enum):
        START  = 's'
        GOAL   = 'g'
        WALL   = 'w'
        PATH   = ' '
        WALKED = '@'

        @staticmethod
        def parse(char):
            for trail in Solver.Cells:
                if char == trail.value:
                    return trail
            return Solver.Cells.WALL

    class Queue(object):
        def __init__(self, data=None):
            if not data:
                self.data = []
            else:
                if isinstance(data, list):
                    self.data = data
                else:
                    self.data = [data]

        def enqueue(self, item):
            self.data.append(item)

        def dequeue(self):
            return self.data.pop(len(self.data) - 1)

        def is_empty(self):
            return not len(self.data) > 0

    class Trail(Generative):
        def __init__(self, row, column, cell, cost=float('inf'), previous=None):
            self.row = row
            self.column = column
            self.cell = cell
            self.cost = cost
            self.previous = previous

        def __setattr__(self, key, value):
            super(Solver.Trail, self).__setattr__(key, value)
            return self

        def __repr__(self):
            return repr(self.cell)

        @Generative.chain
        def set_row(self, row):
            self.row = row

        @Generative.chain
        def set_column(self, column):
            self.column = column

        @Generative.chain
        def set_cell(self, cell):
            self.cell = cell

        @Generative.chain
        def set_cost(self, cost):
            self.cost = cost

        @Generative.chain
        def set_previous(self, previous):
            self.previous = previous

    class Maze(object):
        def __init__(self, data, rows, columns):
            self.trails = []
            self.start = None
            self.goal = None
            self.rows = rows
            self.columns = columns
            for row in range(0, self.rows):
                self.trails.append([])
                for column in range(0, self.columns):
                    try:
                        cell = Solver.Cells.parse(data[row][column])
                        trail = Solver.Trail(row, column, cell)
                        if cell == Solver.Cells.START:
                            if self.start:
                                raise ValueError('start must be unique')
                            else:
                                self.start = trail
                        if cell == Solver.Cells.GOAL:
                            if self.goal:
                                raise ValueError('goal must be unique')
                            else:
                                self.goal = trail
                        self.trails[row].append(trail)
                    except IndexError:
                        self.trails[row].append(Solver.Trail(row, column, Solver.Cells.WALL))
            if not self.start or not self.goal:
                raise ValueError('exactly one start and goal must exist')

        def __getitem__(self, index):
            return self.trails[index]

        def __repr__(self):
            result = ""
            for row in range(0, self.rows):
                for column in range(0, self.columns):
                    result += repr(self.trails[row][column])
                result += "\n"
            return result

        def has_index(self, row, column):
            return 0 <= row and row < self.rows and 0 <= column and column < self.columns


def main(argv=None):
    try:
        if not argv:
            argv = map(lambda line: line.rstrip('\n'), sys.stdin.readlines())
            problem = Solver.Maze(argv, len(argv), len(max(argv, key=len)))
        if argv:
            Solver.solve(problem)
            print problem
        else:
            print >> sys.stderr, "usage: python 2-1-3.py <map>"
    except Exception as e:
        print >> sys.stderr, str(e)


if __name__ == '__main__':
    sys.exit(main())
