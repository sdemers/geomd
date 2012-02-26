/**
Bezier Index

Copyright: Serge Demers 2012
License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module geomd.bezierIndex;

import geomd.point2d;
import geomd.utils;
import geomd.test;

import std.math;
import std.stdio;
import std.format;
import std.conv;
import std.algorithm;


/**
    This class is used as the the Bezier Curve parameter and represents a
    floating point value between 0.0 and 1.0.

    Coordinates and length are unitless.

*/
class BezierIndex
{

    /**
        Constructor

        Params:
            value = value of index
    */
    this(double value = 0.0, size_t incrementCount = 500)
    {
        assert(incrementCount > 0);
        m_incrementCount = incrementCount;
        m_incrementStep = 1.0 / m_incrementCount;
        setValue(value);
    }

    /**
        Returns the current value [0.0, 1.0]
    */
    double value() const
    {
        return m_value;
    }

    /**
        Returns the bezier index's "step" [0, incrementCount]
    */
    int step() const
    {
        return to!int(round(m_preciseStep));
    }

    /**
        Sets the index's value (clamps between 0.0 and 1.0)
    */
    double setValue(double value)
    {
        m_value = max(0.0, min(1.0, value));

        m_preciseStep = m_value / m_incrementStep;

        return m_value;
    }

    /**
        Resets the index to zero
    */
    double reset()
    {
        return setValue(0.0);
    }

    /**
        Set the index's step and returns the corresponding value.
    */
    double setStep(int step)
    {
        return setValue(step * m_incrementStep);
    }

    /**
        Prefix operator: increments value by "incrementStep" and
        returns the new value.
    */
    void opUnary(string s)() if (s == "++")
    {
        setValue(m_value + m_incrementStep);
    }

    /**
        Prefix operator: decrements value by "incrementStep" and
        returns the new value.
    */
    void opUnary(string s)() if (s == "--")
    {
        setValue(m_value - m_incrementStep);
    }

    /**
        Returns if bezier index is at the start (i.e. == 0)
    */
    bool isAtStart() const
    {
        return isZero(m_value);
    }

    /**
        Returns if bezier index is at the end (i.e. == 1.0)
    */
    bool isAtEnd() const
    {
        return isZero(m_value - 1.0);
    }

private:
    double m_value;          /// index value [0.0 - 1.0]
    double m_preciseStep;    /// current step matching m_value [0.0 - incrementCount]
    size_t m_incrementCount; /// Number of increments between start and end of index
    double m_incrementStep; /// Increment step (1.0 / m_incrementCount);

} // BezierIndex

unittest
{
    auto b1 = new BezierIndex;
    check!bool(b1.isAtStart());
    ++b1;
    checkClose(b1.value(), 0.002);
    ++b1;
    checkClose(b1.value(), 0.004);
    b1++;
    checkClose(b1.value(), 0.006);
    check!int(b1.step(), 3);
    b1--;
    checkClose(b1.value(), 0.004);
    --b1;
    checkClose(b1.value(), 0.002);
    check!int(b1.step(), 1);

    auto b2 = new BezierIndex(0.0, 100);
    check!bool(b2.isAtStart());
    ++b2;
    checkClose(b2.value(), 0.01);
    b2++;
    checkClose(b2.value(), 0.02);

    b2.reset();
    check!bool(b2.isAtStart());
    b2.setValue(1.0);
    check!bool(b2.isAtEnd());
    b2.setValue(-1.0);
    check!bool(b2.isAtStart());
    b2.setValue(2.0);
    check!bool(b2.isAtEnd());

    b2.setStep(101);
    check!bool(b2.isAtEnd());
    b2.setStep(99);
    check!bool(b2.isAtEnd() == false);
    checkClose(b2.value(), 0.99);

}
