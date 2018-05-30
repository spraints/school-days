module DateHelpers exposing (addDay, subDay, isWeekend)

import Date exposing (Date, dayOfWeek, fromTime, toTime)
import Time exposing (hour)

addDay : Date -> Date
addDay date =
  fromTime <| 24 * hour + (toTime date)

subDay : Date -> Date
subDay date =
  fromTime <| (toTime date) - 24 * hour

isWeekend : Date -> Bool
isWeekend date =
  case dayOfWeek date of
    Date.Mon -> False
    Date.Tue -> False
    Date.Wed -> False
    Date.Thu -> False
    Date.Fri -> False
    Date.Sat -> True
    Date.Sun -> True
