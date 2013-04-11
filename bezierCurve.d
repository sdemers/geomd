/**
Bezier

Copyright: Serge Demers 2012
License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module geomd.bezierCurve;

import geomd.bezierIndex;
import geomd.point2d;
import geomd.utils;
import geomd.test;
import geomd.optional;

import std.math;
import std.stdio;
import std.format;
import std.range;
import std.conv;

enum OptimizationStrategy
{
    None,
    Increments,
    LinearApproximation
}

/**
    Represents a Cubic Bezier Curve

    See_Also:
        <a href="http://www.wikipedia.org/wiki/Bezier_curve">Bezier Curve on Wikipedia</a>
*/
class BezierCurve
{

    /**
        Constructor

        Params:
            start = coordinate of starting point
            cp1 = coordinate of first control point
            cp2 = coordinate of second control point
            end = coordinate of ending point
    */
    this(const ref Point2Dd start,
         const ref Point2Dd cp1,
         const ref Point2Dd cp2,
         const ref Point2Dd end,
         OptimizationStrategy strategy)
    {
        m_p0 = start;
        m_p1 = cp1;
        m_p2 = cp2;
        m_p3 = end;

        auto p0Times3 = m_p0 * 3.0;
        auto p1Times3 = m_p1 * 3.0;
        auto p2Times3 = m_p2 * 3.0;

        // A = x3 - 3 * x2 + 3 * x1 - x0
        // B = 3 * x2 - 6 * x1 + 3 * x0
        // C = 3 * x1 - 3 * x0
        // D = x0

        m_A = m_p3 - p2Times3 + p1Times3 - m_p0;
        auto p1Times6 = m_p1 * 6.0;
        m_B = p2Times3 - p1Times6 + p0Times3;
        m_C = p1Times3 - p0Times3;
        m_D = m_p0;

        m_A3 = m_A * 3.0;
        m_B2 = m_B * 2.0;

        Increment[] increments = computeIncrements(m_A, m_B, m_C, m_D);

        if (strategy == OptimizationStrategy.Increments)
        {
            m_optIncrement = increments;
        }

        m_length = increments[increments.length - 1].distanceFromStart;

        m_radInitHeading = normalizeRadian(atan2(m_C.x(), m_C.y()));

        m_radFinalHeading = normalizeRadian(atan2((m_p3.x() - m_p2.x()),
                                                  (m_p3.y() - m_p2.y())));

/*
        vector<XYPoint> points = list_of(m_p0)(m_p1)(m_p2)(m_p3);

        m_convexHullLimits = computeMinMaxLimits(points).get();
        m_convexHull       = computeConvexHull(points);
*/
    }

    /// Returns if increments are used internally.
    bool usesIncrements() immutable
    {
        return m_optIncrement.isSet;
    }

    /// Returns the coordinates of the starting point.
    auto ref initCoord() const
    {
        return m_p0;
    }

    /// Returns the coordinates of the ending point.
    auto ref finalCoord() const
    {
        return m_p3;
    }

    /// Returns the initial heading
    @property double initHeading() const
    {
        return m_radInitHeading;
    }

    /// Returns the final heading
    @property double finalHeading() const
    {
        return m_radFinalHeading;
    }

    /// Returns the length
    @property double length() const
    {
        return m_length;
    }

private:
    const Point2Dd m_p0; /// initial point
    const Point2Dd m_p1; /// control point 1
    const Point2Dd m_p2; /// control point 2
    const Point2Dd m_p3; /// final point

    // A cubic Bezier can be expressed as a cubic polynomial with eight coefficients
    // t being the index on the curve [0, 1]
    // x = Axt3 + Bxt2 + Cxt + Dx
    // y = Ayt3 + Byt2 + Cyt + Dy
    const Point2Dd m_A;
    const Point2Dd m_B;
    const Point2Dd m_C;
    const Point2Dd m_D;

    const Point2Dd m_A3; /// a * 3
    const Point2Dd m_B2; /// b * 2

    double m_length; /// length of curve

    double m_radInitHeading;   /// initial heading
    double m_radFinalHeading;  /// final heading

    Optional!(Increment[]) m_optIncrement;

    /**
        Returns the increments for the curve (pre-computed or not)
    */
    const(Increment[]) increments() const
    {
        if (m_optIncrement.isSet)
        {
            return m_optIncrement.get();
        }

        return computeIncrements(m_A, m_B, m_C, m_D);
    }

    /**
        Returns an increment for the given index as precise as possible.

        Params:
            index = bezier index
    */
    Increment incrementForIndex(const ref BezierIndex index) immutable
    {
        // Build an increment using the previous and next increments
        // found from the passed bezier index.

        // Find the increment closest to the bezier index. Use the increment
        // before or after as the second increment. The increment that this function
        // returns contains values calculated using linear interpolation.

        int previousStep = index.step();
        int nextStep     = index.step();

        double remainder = fmod(index.preciseStep(), 1.0);

        if (remainder < 0.5)
        {
            nextStep = index.step() + 1;
        }
        else
        {
            previousStep = index.step() - 1;
        }

        auto increments = increments();

        auto previousIncrement = increments[previousStep];
        auto nextIncrement     = increments[nextStep];

        double previousIndex = previousStep * index.getIncrementStep();
        double nextIndex     = nextStep * index.getIncrementStep();

        // factor is between [0, 1] and corresponds to the % of index
        // between the 2 found increments. It is needed for linear interpolation.
        float factor = 1.0 - ((nextIndex - index.value()) /
                              (nextIndex - previousIndex));

        if (isZero(factor))
        {
            return previousIncrement;
        }
        else if (isZero(1.0 - factor))
        {
            return nextIncrement;
        }

        Increment newIncrement;

        newIncrement.distanceFromPrevious = nextIncrement.distanceFromPrevious * factor;

        newIncrement.distanceFromStart = linearInterpolation!double(factor,
                                                                    previousIncrement.distanceFromStart,
                                                                    nextIncrement.distanceFromStart);

        newIncrement.x = linearInterpolation!double(factor, previousIncrement.x, nextIncrement.x);
        newIncrement.y = linearInterpolation!double(factor, previousIncrement.y, nextIncrement.y);

        return newIncrement;
    }


} // BezierCurve


/**
    Computes and returns an array of increments
 */
private auto ref computeIncrements(const Point2Dd A,
                                   const Point2Dd B,
                                   const Point2Dd C,
                                   const Point2Dd D)
{
    Increment[] inc;

    float distanceFromStart = 0.0;
    float x1 = D.x();
    float y1 = D.y();

    inc ~= Increment(0.0, distanceFromStart, x1, y1);

    return inc;
}

struct Increment
{
private:
    float distanceFromPrevious;
    float distanceFromStart;
    float x;
    float y;
}

unittest
{
}
