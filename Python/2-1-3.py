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

    def __eq__(other):
        return self.key == other.key and self.value == other.value if isinstance(other, self.__class__) else False


class Solver(object):
    class Cells(Enum):
        WALL   = 'w'
        PATH   = ' '
        WALKED = '@'

        @staticmethod
        def parse(char):
            for trail in Solver.Cells:
                if char == trail.value:
                    return trail
            return Solver.Cells.WALL

    class Trail(object):
        def __init__(self, cell, previous=None):
            self.cell = cell
            self.previous = previous

        def __repr__(self):
            return repr(self.cell)

    class Maze(object):
        def __init__(self, data, rows, columns):
            self.trails = []
            self.rows = rows
            self.columns = columns
            for row in range(0, self.rows):
                self.trails.append([])
                for column in range(0, self.columns):
                    try:
                        self.trails[row].append(Solver.Trail(Solver.Cells.parse(data[row][column])))
                    except IndexError:
                        self.trails[row].append(Solver.Trail(Solver.Cells.WALL))

        def __repr__(self):
            result = ""
            for row in range(0, self.rows):
                for column in range(0, self.columns):
                    result += repr(self.trails[row][column])
                result += "\n"
            return result


def main(argv=None):
    if not argv:
        argv = map(lambda line: line.rstrip('\n'), sys.stdin.readlines())
        problem = Solver.Maze(argv, len(argv), len(max(argv, key=len)))
    if argv:
        print problem
    else:
        print >> sys.stderr, "usage: python 2-1-3.py <map>"


if __name__ == '__main__':
    sys.exit(main())
