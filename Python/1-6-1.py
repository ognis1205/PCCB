# PCCB 1-6-1
# -*- coding: utf-8 -*-

import sys

class Solver(object):
    @staticmethod
    def solve(edges):
        edges = sorted(edges, reverse=True)
        for i in range(0, len(edges)):
            for j in range(i + 1, len(edges)):
                for k in range(j + 1, len(edges)):
                    if edges[i] < edges[j] + edges[k]:
                        print "found: %d %d %d" % (edges[i], edges[j] ,edges[k])
                        return
        print "not found"


def main(argv=None):
    if not argv:
        argv = sys.argv[1:]
    if argv:
        try:
            edges = filter(lambda x: x > 0, [int(arg) for arg in argv])
            Solver.solve(edges)
        except Exception as e:
            print >> sys.stderr, str(e)
    else:
        print >> sys.stderr, "usage: python 1-6-1.py <edges>"


if __name__ == '__main__':
    sys.exit(main())
