# PCCB 2-1-3
# -*- coding: utf-8 -*-

import sys

class EnumType(type):
    def __init__(clazz, name, bases, attributes):
        super(EnumType, clazz).__init__(name, bases, attributes)
        clazz._values = []
        for key, value in attributes.iteritems():
            if is_enum_instance(key, value):
                instance = clazz(key, value)
                setattr(clazz, key, item)
                clazz._values.append(item)

    def __iter__(clazz):
        return iter(clazz.values)

    def _is_enum_instance(clazz, key, value):
        return not hasattr(value, '__call__') and key.isupper()


class Enum(object):
    __metaclass__ = EnumType

    def __init__(self, key, value):
        self.key = key
        self.value = value

    def __repr__(self):
        return repr(self.value)


def main(argv=None):
    if not argv:
        argv = map(lambda line: line.rstrip('\n'), sys.argv.readlines())
    if argv:
        print argv
    else:
        print >> sys.stderr, "usage: python 2-1-3.py <map>"


if __name__ == '__main__':
    sys.exit(main())
