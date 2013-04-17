
/**
Point 2D

Copyright: Serge Demers 2012
License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module geomd.point2d;

import std.stdio;
import std.conv;
import std.math;
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
        return "(" ~ to!string(x) ~ ", " ~ to!string(y) ~ ")";
    }

    /// Returns x coordinate
    @property T x() const { return m_x; }

    /// Returns y coordinate.
    @property T y() const { return m_y; }

    /// Adds rhs
    auto opBinary(string op, T)(const Point2D!T rhs) const if (op == "+")
    {
        return new Point2D!T(x + rhs.x, y + rhs.y);
    }

    /// Substracts rhs
    auto opBinary(string op, T)(const Point2D!T rhs) const if (op == "-")
    {
        return new Point2D!T(x - rhs.x, y - rhs.y);
    }

    /// Multiplies x and y by a value
    auto opBinary(string op, T)(T multiplier) const if (op == "*")
    {
        return new Point2D!T(x * multiplier, y * multiplier);
    }

    /// Divides x and y by a value
    auto opBinary(string op, T)(T divider) const if (op == "/")
    {
        return new Point2D!T(x / divider, y / divider);
    }

    auto getDistance(const Point2D!T p) const
    {
        auto x2 = p.x() - x;
        auto y2 = p.y() - y;
        return sqrt(x2 * x2 + y2 * y2);
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

    checkClose!double(p1.getDistance(p2), 0.1414213562);
    checkClose!double(p2.getDistance(p1), 0.1414213562);
}
