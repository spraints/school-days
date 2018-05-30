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
