module Types exposing (..)

import Date exposing (Date)
import Set exposing (Set)

type alias ParsedInt = Result String Int
type alias IntInput = (String, ParsedInt)

type alias ComparableDate = (Int, Int)

type Msg = SetToday Date
         | UpdateDaysFinished String
         | UpdateDaysRequired String
         | SkipDay Date
         | UnskipDay Date
         | SkipDays (List Date)
         | UnskipDays (List Date)
         | Noop

type alias Model =
  { days_finished : IntInput
  , days_required : IntInput
  , days_to_skip : Set ComparableDate
  , today : Maybe Date
  }

toComparableDate : Date -> ComparableDate
toComparableDate date =
  let
    monthNum month =
      case month of
        Date.Jan -> 1
        Date.Feb -> 2
        Date.Mar -> 3
        Date.Apr -> 4
        Date.May -> 5
        Date.Jun -> 6
        Date.Jul -> 7
        Date.Aug -> 8
        Date.Sep -> 9
        Date.Oct -> 10
        Date.Nov -> 11
        Date.Dec -> 12
  in
    (monthNum <| Date.month date, Date.day date)
