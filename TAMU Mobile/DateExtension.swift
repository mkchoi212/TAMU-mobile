import UIKit


//-------------------------------------------------------------
//NSDate extensions.
extension NSDate
{
    /**
    This adds a new method dateAt to NSDate.
    
    It returns a new date at the specified hours and minutes of the receiver
    
    :param: hours: The hours value
    :param: minutes: The new minutes
    
    :returns: a new NSDate with the same year/month/day as the receiver, but with the specified hours/minutes values
    */
    func dateAt(#hours: Int, minutes: Int) -> NSDate
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        //get the month/day/year componentsfor today's date.
        let date_components = calendar.components(NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay, fromDate: self)

        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0
 
        let newDate = calendar.dateFromComponents(date_components)!
        
        return newDate
    }
}
//-------------------------------------------------------------
//Tell the system that NSDates can be compared with ==, >, >=, <, and <= operators
extension NSDate: Equatable {}
extension NSDate: Comparable {}

//-------------------------------------------------------------
//Define the global operators for the
//Equatable and Comparable protocols for comparing NSDates

public func ==(lhs: NSDate, rhs: NSDate) -> Bool
{
    return lhs.timeIntervalSince1970 == rhs.timeIntervalSince1970
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool
{
    return lhs.timeIntervalSince1970 < rhs.timeIntervalSince1970
}
public func >(lhs: NSDate, rhs: NSDate) -> Bool
{
    return lhs.timeIntervalSince1970 > rhs.timeIntervalSince1970
}
public func <=(lhs: NSDate, rhs: NSDate) -> Bool
{
    return lhs.timeIntervalSince1970 <= rhs.timeIntervalSince1970
}
public func >=(lhs: NSDate, rhs: NSDate) -> Bool
{
    return lhs.timeIntervalSince1970 >= rhs.timeIntervalSince1970
}

