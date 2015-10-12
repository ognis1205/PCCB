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
            if not key.startswith('_') and key.isupper():
                item = clazz(key, value)
                setattr(clazz, key, item)
                clazz._values.append(item)

    def __iter__(clazz):
        return iter(clazz._values)


class Enum(object):
    __metaclass__ = EnumType

    def __init__(self, key, value):
        self.key = key
        self.value = value

    def __repr__(self):
        return repr(self.value)


class Solver(object):
    @staticmethod
    def solve(problem):
        answer = 0
        for row in range(0, problem.rows):
            for column in range(0, problem.columns):
                if problem[row][column] == Solver.Cells.LAKE:
                    answer += 1
                    Solver.dfs(problem, row, column)
                    print problem
        return answer

    @staticmethod
    def dfs(problem, row, column):
        for direction in Solver.Directions:
            next_row = row + direction['dx']
            next_column = column + direction['dy']
            if problem.has_index(next_row, next_column) and problem[next_row][next_column] == Solver.Cells.LAKE:
                problem[next_row][next_column] = Solver.Cells.WALKED
                Solver.dfs(problem, next_row, next_column)

    class Directions(Enum):
        UPLEFT    = {'dx' : -1, 'dy' :  1}
        LEFT      = {'dx' : -1, 'dy' :  0}
        DOWNLEFT  = {'dx' : -1, 'dy' : -1}
        UP        = {'dx' :  0, 'dy' :  1}
        STAY      = {'dx' :  0, 'dy' :  0}
        DOWN      = {'dx' :  0, 'dy' : -1}
        UPRIGHT   = {'dx' :  1, 'dy' :  1}
        RIGHT     = {'dx' :  1, 'dy' :  0}
        DOWNRIGHT = {'dx' :  1, 'dy' : -1}

        def __getitem__(self, key):
            return self.value[key]

    class Cells(Enum):
        LAND   = '*'
        LAKE   = 'w'
        WALKED = '-'

        @staticmethod
        def parse(char):
            for cell in Solver.Cells:
                if cell.value == char:
                    return cell
            return Solver.Cells.LAND

        def __eq__(self, other):
            return self.key == other.key and self.value == other.value if isinstance(other, Solver.Cells) else False

    @innerclass
    class Map(object):
        def __init__(self, data, rows, columns):
            self.cells = []
            self.rows = rows
            self.columns = columns
            for row in range(0, rows):
                self.cells.append([])
                for column in range(0, columns):
                    try:
                        self.cells[row].append(Solver.Cells.parse(data[row][column]))
                    except IndexError:
                        self.cells[row].append(Solver.Cells.LAND)

        def has_index(self, row, column):
            return 0 <= row and row < self.rows and 0 <= column and column < self.columns

        def __getitem__(self, index):
            return self.cells[index]

        def __repr__(self):
            result = ""
            for row in range(0, self.rows):
                for column in range(0, self.columns):
                    result += self[row][column].value
                result += '\n'
            return result


def main(argv=[]):
    if not argv:
        argv = map(lambda line: line.rstrip('\n'), sys.stdin.readlines())
    if argv:
        problem = Solver.Map(argv, len(argv), len(max(argv, key=len)))
        print "result: %d" % Solver.solve(problem)
        print problem
    else:
        print >> sys.stderr, "usage: python 2-1-2.py <map>"


if __name__ == '__main__':
    sys.exit(main())
