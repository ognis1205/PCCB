# PCCB 1-6-3
# -*- coding: utf-8 -*-

import sys

class Solver(object):
    @staticmethod
    def solve(target, items):
        Solver.prepare(items)
        for i in range(0, len(items)):
            for j in range(i + 1, len(items)):
                for k in range(j + 1, len(items)):
                    l = Solver.binary_search(target - items[i] - items[j] - items[k], items[k + 1:])
                    if l >= 0:
                        return items[i], items[j], items[k], items[l + k + 1]
        return None

    @staticmethod
    def prepare(items):
        items = sorted(items)

    @staticmethod
    def binary_search(target, items):
        left = 0
        right = len(items) - 1
        while left < right:
            mid = (left + right) // 2
            if target <= items[mid]:
                right = mid
            else:
                left = mid + 1
        return left if target == items[left] else -1


def main(argv=None):
    if not argv:
        argv = sys.argv[1:]
    if argv:
        try:
            target = int(argv.pop(0))
            items = [int(arg) for arg in argv]
            candidate = Solver.solve(target, items)
            if candidate:
                print "found: %d %d %d %d" % candidate
            else:
                print "not found"
        except Exception as e:
            print >> sys.stderr, str(e)
            exit
    else:
        print >> sys.stderr, "usage: python 1-6-3.py <target> <items>"


if __name__ == '__main__':
    sys.exit(main())
