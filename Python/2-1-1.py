# PCCB 2-1-1
# -*- coding: utf-8 -*-

import sys

class Solver(object):
    @staticmethod
    def solve(target, items, callback):
        Solver.dfs(target, 0, items, callback)

    @staticmethod
    def dfs(target, offset, items, callback, accumulator=[]):
        if offset >= len(items):
            if target == 0:
                callback(accumulator)
        else:
            if target >= items[offset]:
                accumulator.append(items[offset])
                Solver.dfs(target - items[offset], offset + 1, items, callback, accumulator)
                accumulator.pop(len(accumulator) - 1)
            Solver.dfs(target, offset + 1, items, callback, accumulator)


def on_found(accumulator):
    print accumulator


def main(argv=None):
    if not argv:
        argv = sys.argv[1:]
    if argv:
        try:
            target = int(argv.pop(0))
            items = [int(arg) for arg in argv]
            Solver.solve(target, items, on_found)
        except Exception as e:
            print >> sys.stderr, str(e)
    else:
        print >> sys.stderr, "usage: python 2-1-1.py <list>"


if __name__ == '__main__':
    sys.exit(main())
