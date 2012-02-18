/*

Copyright (c) 2012, Serge Demers <sdemers@gmail.com>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the “Software”), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

*/

module geomd.clothoid;

import std.math;

class Clothoid
{
    private double   m_A;
    private double[20] m_powersOfA;

    //------------------------------------------------------------------------------
    /**
        Computes a term for the approximate function.

        Bugs: Doesn't work for negative values.

    *///----------------------------------------------------------------------------
    private double term(double L, int powerOfL, int powerOfA, double constant)
    {
        return pow(L, powerOfL) / (constant * m_powersOfA[powerOfA]);
    }

    //------------------------------------------------------------------------------
    /**
        Constructor, clothoid is placed at origin (0, 0).

        Params:
            A = flatness value
    *///----------------------------------------------------------------------------
    this(double A = 1.0)
    {
        foreach (int i; 0..(m_powersOfA.length - 1))
        {
            m_powersOfA[i] = pow(m_A, i);
        }
    }

    //------------------------------------------------------------------------------
    /**
        Returns the length at given radius

    *///----------------------------------------------------------------------------
    double lengthAtRadius(double radius)
    {
        assert(radius != 0.0);
        return m_powersOfA[2] / radius;
    }

    //------------------------------------------------------------------------------
    /**
        Returns the radius at given length

    *///----------------------------------------------------------------------------
    double radiusAtLength(double length)
    {
        if (length > 0.0)
        {
            return m_powersOfA[2] / length;
        }

        return double.max;
    }

    static double computeFlatness(double length, double radius)
    {
        return sqrt(radius * length);
    }
}
