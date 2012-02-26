/**
Clothoid

Copyright: Serge Demers 2012
License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module geomd.clothoid;

import geomd.point2d;
import geomd.test;

import std.math;
import std.stdio;
import std.format;
import std.range;
import std.conv;


/**
    Represents a Clothoid (or Euler Spiral)

    Euler spirals are widely used in rail and highway engineering for providing
    a transition or an easement between a tangent and a horizontal circular curve.

    See_Also:
        <a href="http://en.wikipedia.org/wiki/Euler_spiral">Euler Spiral on Wikipedia</a>
*/
class Clothoid
{
    /**
        Constructor, clothoid is placed at origin (0, 0).

        Params:
            A = flatness value
    */
    this(double A = 1.0)
    {
        m_A = A;

        foreach (int i; 0..(m_powersOfA.length))
        {
            m_powersOfA[i] = pow(m_A, i);
        }
    }

    override string toString() const
    {
        string s = "geomd.clothoid\n" ~ "    m_A: " ~ to!string(m_A) ~ "\n";
        s ~= "    m_powersOfA: " ~ to!string(m_powersOfA);
        return s;
    }

    /**
        Returns the length at given radius.
    */
    double lengthAtRadius(double radius) const
    {
        assert(radius != 0.0);
        return m_powersOfA[2] / radius;
    }

    /**
        Returns the radius at given length.
    */
    double radiusAtLength(double length) const
    {
        if (length > 0.0)
        {
            return m_powersOfA[2] / length;
        }

        return double.max;
    }

    /**
        Returns the tangent at given length.
    */
    double tangentAtLength(double length) const
    {
        return length * length / (2.0 * m_powersOfA[2]);
    }

    /**
        Returns the length at given tangent.
    */
    double lengthAtTangent(double radTangent) const
    {
        return sqrt(2.0 * m_powersOfA[2] * radTangent);
    }

    /**
        Returns the coordinate at given length.
    */
    Point2Dd xy(double length)
    {
        // Using formula derived by Euler to approximate clothoid
        const double L = length;

        double x = L - term(L, 5, 4, 40.) + term(L, 9, 8, 3456.) -
                       term(L, 13, 12, 599040.0) + term(L, 17, 16, 175472640.0);

        double y = term(L, 3, 2, 6.0) - term(L, 7, 6, 336.0) +
                   term(L, 11, 10, 42240.0) - term(L, 15, 14, 9676800.0) +
                   term(L, 19, 18, 3530096640.0);

        return new Point2Dd(x, y);
    }

private:
    double      m_A = 1.0;
    double[20]  m_powersOfA;

    /**
        Computes a term for the approximate function.
    */
    double term(double L, int powerOfL, int powerOfA, double constant) const
    {
        return pow(L, powerOfL) / (constant * m_powersOfA[powerOfA]);
    }

} // Clothoid


/**
    Computes flatness of a clothoid.

    Examples:
    The following example builds a clothoid having a length of 10.0 where
    its radius is 5.0.
    ---
    double flatness = computeFlatness(10.0, 5.0);
    auto clothoid = new Clothoid(flatness);
    ---
*/
double computeFlatness(double length, double radius)
{
    return sqrt(radius * length);
}

unittest
{
    double flatness = computeFlatness(10.0, 5.0);
    checkClose!double(flatness, 7.071067812);

    auto clothoid = new Clothoid(flatness);
    checkClose!double(clothoid.lengthAtRadius(5.0), 10.0);

    checkClose!double(clothoid.radiusAtLength(10.0), 5.0);
    checkClose!double(clothoid.radiusAtLength(7.5), 6.66667);
    checkClose!double(clothoid.radiusAtLength(-1.0), double.max);

    checkClose!double(clothoid.tangentAtLength(7.5), 0.5625);

    checkClose!double(clothoid.lengthAtTangent(0.3333), 5.77321401);
    checkClose!double(clothoid.lengthAtTangent(0.0333), 1.824828759);

    auto p1 = clothoid.xy(5.0);
    checkClose!double(p1.x(), 4.968840292);
    checkClose!double(p1.y(), 0.4148102427);

    string s ="geomd.clothoid
    m_A: 7.07107
    m_powersOfA: [1, 7.07107, 50, 353.553, 2500, 17677.7, 125000, 883883, 6.25e+06, 4.41942e+07, 3.125e+08, 2.20971e+09, 1.5625e+10, 1.10485e+11, 7.8125e+11, 5.52427e+12, 3.90625e+13, 2.76214e+14, 1.95313e+15, 1.38107e+16]";
    check!bool(s == clothoid.toString());

    /*
    foreach (int i; 0..40)
    {
        writeln(clothoid.xy(0.5 * i));
    }
    */
}
