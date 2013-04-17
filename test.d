/**
Test utilities

Copyright: Serge Demers 2012
License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module geomd.test;

import std.format;
import std.math;
import std.range;
import std.stdio;
import std.conv;

private bool checkReturn(T)(T val, T expected,
                            string file, int line, bool delegate() fp,
                            bool print, string format)
{
    bool ret = fp();
    if (ret == false && print)
    {
        string fmt = file ~ "(" ~ to!string(line) ~
                     "): Test failed: got " ~ format ~ ", expected " ~ format;
        stderr.writefln(fmt, val, expected);
    }
    return ret;
}

/**
    Compares values that supports the == operator.
*/
bool check(T)(T val, T expected,
              string file = __FILE__, int line = __LINE__, bool print = true)
{
    bool fp() { return val == expected; }
    return checkReturn!(T)(val, expected, file, line, &fp, print, "%s");
}

/**
    Compares floating point values.

    Examples:
    ---
    checkClose!float(0.001f, 0.002f);
    checkClose!double(PI, 3.14159);
    ---
*/
bool checkClose(T)(T val, T expected,
                   string file = __FILE__, int line = __LINE__,
                   T epsilon = 0.00001,
                   bool print = true, string format = "%.10g")
{
    bool fp() { return abs(val - expected) < epsilon; }
    return checkReturn!(T)(val, expected, file, line, &fp, print, format);
}

/**
    Checks if value is true.
*/
bool check(T = bool)(bool value, string file = __FILE__, int line = __LINE__, bool print = true)
{
    if (value == false && print)
    {
        stderr.writefln(file ~ "(" ~ to!string(line) ~ "): Test failed");
    }
    return value;
}

/**
    Asserts that value is true.
*/
void require(bool value, string file = __FILE__, int line = __LINE__, bool print = true)
{
    assert(check!bool(value, file, line, print));
}
