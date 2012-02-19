/**
Test utilities

Copyright: Serge Demers 2012
License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module geomd.test;

import std.stdio;
import std.format;
import std.range;

private bool checkReturn(T)(T val, T expected, bool delegate() fp, bool print, string format)
{
    bool ret = fp();
    if (ret == false && print)
    {
        string fmt = "Test failed: got " ~ format ~ ", expected " ~ format;
        writefln(fmt, val, expected);
    }
    return ret;
}

/**
    Compares any values that supports the == operator.
*/
bool check(T)(T val, T expected, bool print = true)
{
    bool fp() { return val == expected; }
    return checkReturn!(T)(val, expected, &fp, print, "%s");
}

/**
    Compares floating point values.

    Examples:
    ---
    assert(checkClose!float(0.001f, 0.002f));
    assert(checkClose!double(PI, 3.14159));
    ---
*/
bool checkClose(T)(T val, T expected, T epsilon = 0.00001,
                   bool print = true, string format = "%.10g")
{
    bool fp() { return abs(val - expected) < epsilon; }
    return checkReturn!(T)(val, expected, &fp, print, format);
}
