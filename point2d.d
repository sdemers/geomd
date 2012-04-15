
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

    /// Adds rhs
    auto opBinary(string op, T)(const ref Point2D!T rhs) const if (op == "+")
    {
        return new Point2D!T(m_x + rhs.m_x, m_y + rhs.m_y);
    }

    /// Substracts rhs
    auto opBinary(string op, T)(const ref Point2D!T rhs) const if (op == "-")
    {
        return new Point2D!T(m_x - rhs.m_x, m_y - rhs.m_y);
    }

    /// Multiplies x and y by a value
    auto opBinary(string op, T)(T multiplier) const if (op == "*")
    {
        return new Point2D!T(m_x * multiplier, m_y * multiplier);
    }

    /// Divides x and y by a value
    auto opBinary(string op, T)(T divider) const if (op == "/")
    {
        return new Point2D!T(m_x / divider, m_y / divider);
    }

private:
    const T m_x;
    const T m_y;
}

alias Point2D!double Point2Dd; /// double alias
alias Point2D!float  Point2Df; /// float alias
alias Point2D!real   Point2Dr; /// real alias

unittest
{
    Point2Dd p1 = new Point2Dd(1.0, 1.0);
    Point2Dd p2 = new Point2Dd(1.1, 1.1);
    Point2Dd p3 = new Point2Dd(1.0, 1.0);

    check!bool(p1.x() != p2.x());
    check!bool(p1.y() != p2.y());
    check!bool(checkClose!double(p1.x(), p3.x()));
    check!bool(checkClose!double(p1.y(), p3.y()));
    check!bool(p1 != p2);
    check!bool(p1 != p3);
    check!bool(p2.toString() == "(1.1, 1.1)");
}
