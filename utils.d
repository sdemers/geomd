/**
Misc utilities

Copyright: Serge Demers 2012
License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module geomd.utils;

import geomd.test;

import std.math;
import std.conv;

const real TWO_PI = 2 * PI;

bool isZero(T)(T value, T epsilon = 0.0000001)
{
    return abs(to!(T)(value)) < epsilon;
}

T normalizeRadian(T)(const T value)
{
    if (value >= 0.0 &&
        value <= TWO_PI)
    {
        return value;
    }

    T res = fmod(value, TWO_PI);
    return (res > 0.0) ? res : (res + TWO_PI);
}

T normalizeRadianToPi(T)(T radian)
{
    T res = normalizeRadian(radian);
    return (res <= PI ? res : res - TWO_PI);
}

// index should be between 0 and 1
T linearInterpolation(T)(T index, T low, T high)
{
    return low + ((high - low) * index);
}

T degToRad(T)(T deg)
{
    return deg * 0.01745329238;
}

T radToDeg(T)(T rad)
{
    return rad / 0.01745329238;
}

/**
	Filters an array of T with a function taking a T and an U. Returns a new
    array with the result.
*/
public T[] filterArray(T, U)(T[] ts, U u, bool delegate(T, U) fp)
{
	T[] ret;
	foreach (T e; ts)
	{
		if (fp(e, u))
		{
			ret ~= e;
		}
	}

	return ret;
}

public bool arrayContains(T, U)(T[] ts, U u, bool delegate(T, U) fp)
{
	foreach (T e; ts)
	{
		if (fp(e, u))
		{
			return true;
		}
	}

	return false;
}

public T popFront(T)(ref T[] a)
{
    T t = a[0];
    a = a[1 .. $];
    return t;
}

public T popBack(T)(ref T[] a)
{
    T t = a[a.length - 1];
    a = a[0 .. $ - 1];
    return t;
}

unittest
{
    check!bool(isZero(0.0001) == false);
    check!bool(isZero(0.00000001));

    checkClose!double(normalizeRadian(0.2), 0.2);
    checkClose!double(normalizeRadian(-0.2), 6.083185307);
    checkClose!double(normalizeRadian(-10.0), 2.566370614);
    checkClose!double(normalizeRadian(6.3), 0.01681469282);
    checkClose!double(normalizeRadian(14.3), 1.733629386);

    checkClose!double(normalizeRadianToPi(0.2), 0.2);
    checkClose!double(normalizeRadianToPi(-0.2), -0.2);
    checkClose!double(normalizeRadianToPi(-10.0), 2.566370614);
    checkClose!double(normalizeRadianToPi(6.3), 0.01681469282);
    checkClose!double(normalizeRadianToPi(14.3), 1.733629386);

    checkClose!double(linearInterpolation(0.5, 100.0, 200.0), 150.0);

    checkClose!double(degToRad!double(45.0), 0.7853981571);
    checkClose!double(degToRad!double(360.0), 6.2831852568);
    checkClose!double(radToDeg!double(0.7853981571), 45.0);
    checkClose!double(radToDeg!double(6.2831852568), 360.0);
}
