module Calendar exposing (..)

import Date

type alias Calendar = List Month
type alias Month = { month : Date.Month, days : List Day }
type alias Day =
  { date : Date.Date
  , what : TypeOfDay
  }
type TypeOfDay = NoSchool
               | Weekend
               | School Int
