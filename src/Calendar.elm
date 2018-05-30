module Calendar exposing (..)

import Date
import List exposing (reverse)
import Set

import Types exposing (..)
import DateHelpers exposing (addDay, isWeekend)

type alias Calendar = List Month
type alias Month = { month : Date.Month, days : List Day }
type alias Day =
  { date : Date.Date
  , what : TypeOfDay
  }
type TypeOfDay = NoSchool
               | Weekend
               | School Int

makeDays : Model -> List Day
makeDays model =
  let
    makeDaysRec res currentYear info =
      if Date.year info.date /= currentYear then
        reverse res
      else
        let
          d = makeDay info
        in
          makeDaysRec (d :: res) currentYear (nextDayInfo info d)

    nextDayInfo info d =
      { info
      | date = addDay info.date
      , completed =
          case d.what of
            School n -> n
            _ -> info.completed
      }
    firstDayInfo today model =
      { date = today
      , completed = alwaysInt model.days_finished
      , skipped = model.days_to_skip
      }

    makeDay info =
      { date = info.date
      , what = whatIs info
      }
    whatIs info =
      if isWeekend info.date then
        Weekend
      else if Set.member (toComparableDate info.date) model.days_to_skip then
        NoSchool
      else if info.completed < (alwaysInt model.days_required) then
        School <| info.completed + 1
      else
        Weekend
  in
    case model.today of
      Nothing -> []
      Just d -> makeDaysRec [] (Date.year d) (firstDayInfo d model)

makeCalendar : Model -> Calendar
makeCalendar model =
  let
    startMonth info =
      { month = Date.month info.date
      , days = [info]
      }

    aggMonth info res =
      case uncons res of
        Nothing -> [startMonth info]
        Just (month, rest) ->
          if month.month == Date.month info.date then
            {month | days = info :: month.days} :: rest
          else
            (startMonth info) :: res

    splitMonths =
      List.foldr aggMonth []
  in
    makeDays model |> splitMonths

-- exactly like
-- https://github.com/elm-community/list-extra/blob/36b63fc2ab1b1b602a30dbc71e9b829a0f325e21/src/List/Extra.elm#L285-L298
uncons : List a -> Maybe (a, List a)
uncons list =
  case list of
    [] -> Nothing
    x :: xs -> Just ( x, xs )
