# PCCB 2-1-2
# -*- coding: utf-8 -*-

import sys

class innerclass(object):
    def __init__(self, clazz):
        self.clazz = clazz

    def __get__(self, instance, clazz):
        class Wrapper(self.clazz):
            outer = instance
        Wrapper.__name__ = self.clazz.__name__
        return Wrapper


class EnumType(type):
    def __init__(clazz, name, bases, attributes):
        super(EnumType, clazz).__init__(name, bases, attributes)
        clazz._values = []
        for key, value in attributes.iteritems():
            item = clazz(key, value)
            setattr(clazz, key, item)
            clazz._values.append(item)

    def __iter__(clazz):
        return iter(clazz._values)


class Solver(object):
    @staticmethod
    def solve(geograph):
        pass

    @innerclass
    class Cell(object):
        def __init__(self, char):
            self.data = char

    @innerclass
    class Map(object):
        def __init__(self, data, rows, columns):
            self.data = [[None] * columns] * rows
            self.rows = rows
            self.columns = columns
            for row, line in zip(range(0, rows - 1), data):
                for column, char in zip(range(0, columns - 1), line):
                    self.data[row][column] = Solver.Cell(char)


def main(argv=[]):
    if not argv:
        argv = map(lambda line: line.rstrip('\n'), sys.stdin.readlines())
    if argv:
        geograph = Solver.Map(argv, len(argv), len(max(argv, key=len)))
        print argv
    else:
        print >> sys.stderr, "usage: python 2-1-2.py <map>"


if __name__ == '__main__':
    sys.exit(main())
