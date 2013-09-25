/**
Line

Copyright: Serge Demers 2013
License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module geomd.lineSegment;

import geomd.point2d;
import geomd.utils;
import geomd.test;
import geomd.optional;

import std.math;
import std.stdio;
import std.format;
import std.range;
import std.conv;

/**
    Represents a line segment
*/
class LineSegment
{
    /**
        Constructor

        Params:
            start = coordinate of starting point
            end = coordinate of ending point
    */
    this(const Point2Dd start,
         const Point2Dd end)
    {
        m_p0 = start;
        m_p1 = end;

        m_length = sqrt(sqr(m_p1.x - m_p0.x) + sqr(m_p1.y - m_p0.y));

        writefln("LineSegment length: %.2f", m_length);

        m_initHeading = normalizeRadian!double(atan2((m_p1.x() - m_p0.x()),
                                                     (m_p1.y() - m_p1.y())));

        m_finalHeading = m_initHeading;
    }

    /// Returns the coordinates of the starting point.
    auto initCoord() const
    {
        return m_p0;
    }

    /// Returns the coordinates of the ending point.
    auto finalCoord() const
    {
        return m_p1;
    }

    /// Returns the initial heading in radian
    double initHeading() const
    {
        return m_initHeading;
    }

    /// Returns the final heading in radian
    double finalHeading() const
    {
        return m_finalHeading;
    }

    /// Returns the length
    double length() const
    {
        return m_length;
    }

private:
    const Point2Dd m_p0; /// initial point
    const Point2Dd m_p1; /// final point

    double m_initHeading;  /// initial heading in radian
    double m_finalHeading; /// final heading in radian

    double m_length; /// length
}

unittest
{
}
