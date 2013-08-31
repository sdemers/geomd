/**
Optional

Copyright: Serge Demers 2012
License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
*/

module geomd.optional;

import geomd.test;

/**
    Class to hold data that may or may not be initialized.
*/
struct Optional(T)
{
public:

    this(T data)
    {
        m_isSet = true;
        m_data = data;
    }

    /**
        Assign operator
    */
    void opAssign(T data)
    {
        set(data);
    }

    /**
        Returns if optional contains data.
    */
    bool isSet() const
    {
        return m_isSet;
    }

    /**
        Returns true if data is uninitialized (empty).
    */
    bool isEmpty() const
    {
        return m_isSet == false;
    }

    /**
        Sets contained data.
    */
    void set(T data)
    {
        m_isSet = true;
        m_data = data;
    }

    /**
        Sets optional as empty.
    */
    void reset()
    {
        m_isSet = false;
    }

    /**
        Returns contained data.
    */
    auto get() const
    {
        assert(m_isSet);
        return m_data;
    }

    /**
        Returns contained data or a default value if not initialized.
    */
    T getValueOr(T data)
    {
        return m_isSet ? m_data : data;
    }

private:
    bool m_isSet = false;
    T m_data;
}

unittest
{
    Optional!double m1;
    m1 = 1.0;
    check!bool(m1.isSet);

    Optional!double m2;
    check!bool(m2.isEmpty);

    m1.reset();
    check!bool(m1.isEmpty);

    m1 = 2.0;
    check!bool(m1.isSet());

    checkClose!double(m1.get(), 2.0);
    checkClose!double(m1.getValueOr(3.0), 2.0);

    m1.reset();
    checkClose!double(m1.getValueOr(3.0), 3.0);

    auto m3 = Optional!int(1);
    check!bool(m3.isSet);
    check!int(m3.get() == 1);
}
