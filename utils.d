/**
Misc utilities

Copyright: Serge Demers 2012
License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module geomd.utils;

import geomd.test;

import std.math;
import std.conv;

bool isZero(T)(T value, T epsilon = 0.0000001)
{
    return abs(to!(T)(value)) < epsilon;
}

unittest
{
    check!bool(isZero(0.0001) == false);
    check!bool(isZero(0.00000001));
}
