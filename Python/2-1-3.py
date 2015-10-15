# PCCB 2-1-3
# -*- coding: utf-8 -*-

import sys

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


class placeholder(object):
    def __init__(self, clazz):
        self.clazz = clazz

    def __get__(self, instance, clazz):
        class Wrapper(self.clazz):
            outer = instance
        Wrapper.__name__ = self.clazz.__name__
        return Wrapper


class Solver(object):
    @staticmethod
    def solve(maze):
        queue = Queue(maze.start.cost)

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
        def __init__(self):
            self.data = []

        def enqueue(self, item):
            self.data.append(item)

        def dequeue(self):
            return self.data.pop(len(self.data) - 1)

        def is_empty(self):
            return len(self.data) > 0

    class Trail(object):
        def __init__(self, cell, cost=float('inf'), previous=None):
            self.cell = cell
            self.cost = cost
            self.previous = previous

        def __setattr__(self, key, value):
            super(Solver.Trail, self).__setattr__(key, value)
            return self

        def __repr__(self):
            return repr(self.cell)

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
                        if cell == Solver.Cells.START:
                            if self.start:
                                raise ValueError('start must be unique')
                            else:
                                self.start = cell
                        if cell == Solver.Cells.GOAL:
                            if self.goal:
                                raise ValueError('goal must be unique')
                            else:
                                self.goal = cell
                        self.trails[row].append(Solver.Trail(cell))
                    except IndexError:
                        self.trails[row].append(Solver.Trail(Solver.Cells.WALL))
            if not self.start or not self.goal:
                raise ValueError('exactly one start and goal must exist')

        def __repr__(self):
            result = ""
            for row in range(0, self.rows):
                for column in range(0, self.columns):
                    result += repr(self.trails[row][column])
                result += "\n"
            return result


def main(argv=None):
    try:
        if not argv:
            argv = map(lambda line: line.rstrip('\n'), sys.stdin.readlines())
            problem = Solver.Maze(argv, len(argv), len(max(argv, key=len)))
        if argv:
            print problem
        else:
            print >> sys.stderr, "usage: python 2-1-3.py <map>"
    except Exception as e:
        print >> sys.stderr, str(e)


if __name__ == '__main__':
    sys.exit(main())
