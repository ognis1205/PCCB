# PCCB 1-6-2
# -*- coding: utf-8 -*-

import sys

class Solver(object):
    @staticmethod
    def solve(length, ants):
        maximum = minimum = 0
        for ant in ants:
            maximum = max(maximum, max(ant, length - ant))
            minimum = max(minimum, min(ant, length - ant))
        return maximum, minimum


def main(argv=None):
    if not argv:
        argv = sys.argv[1:]
    if argv:
        try:
            length = int(argv.pop(0))
            if length <= 0:
                raise ValueError("invalid length value assigned")
            ants = filter(lambda x: x <= length and x > 0, [int(arg) for arg in argv])
            print "maximum: %d, minimum: %d" % Solver.solve(length, ants)
        except Exception as e:
            print >> sys.stderr, str(e)
    else:
        print >> sys.stderr, "usage: python 1-6-2.py <length> <ants>"


if __name__ == '__main__':
    sys.exit(main())
