
/**
Point 2D

Copyright: Serge Demers 2012
License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module geomd.point2d;

import std.stdio;
import std.conv;
import geomd.test;

/**
    Representation of a 2D point.
*/
class Point2D(T)
{
    this(T x = 0.0, T y = 0.0)
    {
        m_x = x;
        m_y = y;
    }

    override string toString() const
    {
        return "(" ~ to!string(m_x) ~ ", " ~ to!string(m_y) ~ ")";
    }

    /// Returns x coordinate.
    T x() const { return m_x; }

    /// Returns y coordinate.
    T y() const { return m_y; }

private:
    T m_x;
    T m_y;
}

alias Point2D!double Point2Dd; /// double alias
alias Point2D!float  Point2Df; /// float alias
alias Point2D!real   Point2Dr; /// real alias

unittest
{
    Point2Dd p1 = new Point2Dd(1.0, 1.0);
    Point2Dd p2 = new Point2Dd(1.1, 1.1);
    Point2Dd p3 = new Point2Dd(1.0, 1.0);

    assert(p1.x() != p2.x());
    assert(p1.y() != p2.y());
    assert(checkClose!double(p1.x(), p3.x()));
    assert(checkClose!double(p1.y(), p3.y()));
    assert(p1 != p2);
    assert(p1 != p3);

    assert(p1 != p3);
}
