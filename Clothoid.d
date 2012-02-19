/**
Clothoid

Copyright: Serge Demers 2012
License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module geomd.clothoid;

import geomd.test;

import std.math;
import std.stdio;
import std.format;
import std.range;

/**
    Represents a Clothoid (or Euler Spiral)

    Euler spirals are widely used in rail and highway engineering for providing
    a transition or an easement between a tangent and a horizontal circular curve.
*/
class Clothoid
{

private double      m_A = 1.0;
private double[20]  m_powersOfA;

override string toString() const
{
    return "allo" ;
    //string s = "m_A: " + m_A + "\n";
    //s += "m_powersOfA: [" + m_powersOfA + "]";

    //return s;
/*
    foreach (auto i: 0..(m_powersOfA.length - 2))
    {
        s+= m_powersOfA[i] + ", ")
    }
    s += m_powersOfA[m_powersOfA.length - 1] + "]";
*/
}

/**
    Computes a term for the approximate function.
*/
private double term(double L, int powerOfL, int powerOfA, double constant) immutable
{
    return pow(L, powerOfL) / (constant * m_powersOfA[powerOfA]);
}


/**
    Constructor, clothoid is placed at origin (0, 0).

    Params:
        A = flatness value
*/
this(double A = 1.0)
{
    foreach (int i; 0..(m_powersOfA.length - 1))
    {
        m_powersOfA[i] = pow(m_A, i);
    }
}


/**
    Returns the length at given radius
*/
double lengthAtRadius(double radius)
{
    assert(radius != 0.0);
    return m_powersOfA[2] / radius;
}

/**
    Returns the radius at given length
*/
double radiusAtLength(double length) immutable
{
    if (length > 0.0)
    {
        return m_powersOfA[2] / length;
    }

    return double.max;
}

/**
    Returns the tangent at given length
*/
double tangentAtLength(double length) immutable
{
    return length * length / (2.0 * m_powersOfA[2]);
}

/**
    Returns the length at given tangent
*/
double lengthAtTangent(double radTangent) immutable
{
    return sqrt(2.0 * m_powersOfA[2] * radTangent);
}

} // Clothoid


/**
    Computes flatness of a clothoid.

    Examples:
    ---
    double flatness = computeFlatness(10.0, PI/2);
    Clothoid clothoid(flatness);
    ---
*/
double computeFlatness(double length, double radius)
{
    return sqrt(radius * length);
}

unittest
{
    double flatness = computeFlatness(10.0, PI_2);
    assert(checkClose!double(flatness, 3.963327298));

    auto clothoid = new Clothoid(flatness);
    assert(checkClose!double(clothoid.lengthAtRadius(5.0), 0.2));

    assert(check!int(0, 1));
}

void main()
{
}
