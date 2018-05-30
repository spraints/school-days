port module Main exposing (..)

import Date exposing (Date)
import Html
import Html.Attributes
import Html.Events
import List exposing (head, reverse, tail)
import Maybe exposing (withDefault)
import Set exposing (Set)
import Task exposing (perform)
import Time exposing (Time, hour)

import Calendar
import Types exposing (..)

type alias Flags =
  { finished : Int
  , required : Int
  , skips : List ComparableDate
  , start : Maybe Time
  }

port title : String -> Cmd a
port saveModel : Flags -> Cmd a

main = Html.programWithFlags
  { init = init
  , subscriptions = sub
  , update = update
  , view = view
  }

-- days left
init : Flags -> (Model, Cmd Msg)
init flags =
  let
    initialActions =
      [ title "School Days Remaining"
      , perform SetToday Date.now
      ]
  in
    (unflagify flags, Cmd.batch initialActions)

sub : Model -> Sub Msg
sub model = Sub.none

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let
    updated_model =
      case msg of
        Noop -> model
        SetToday date -> { model | today = Just date, days_finished = adjustFinished model date }
        UpdateDaysFinished s -> { model | days_finished = parseIntInput s } -- todo put this in the url?
        UpdateDaysRequired s -> { model | days_required = parseIntInput s }
        SkipDay date -> { model | days_to_skip = Set.insert (toComparableDate date) model.days_to_skip }
        UnskipDay date -> { model | days_to_skip = Set.remove (toComparableDate date) model.days_to_skip }
        SkipDays dates -> { model | days_to_skip = Set.union model.days_to_skip <| Set.fromList <| List.map toComparableDate dates }
        UnskipDays dates -> { model | days_to_skip = Set.diff model.days_to_skip <| Set.fromList <| List.map toComparableDate dates }
  in
    (updated_model, saveModel <| flagify updated_model)

parseIntInput : String -> IntInput
parseIntInput s =
  (s, String.toInt s)

intAsIntInput : Int -> IntInput
intAsIntInput n =
  (toString n, Ok n)

adjustFinished : Model -> Date -> IntInput
adjustFinished model newToday =
  let
    compNewToday = toComparableDate newToday
    accum day res =
      if toComparableDate day.date < compNewToday then
        case day.what of
          Calendar.School n -> intAsIntInput n
          _ -> res
      else
        res
  in
    case model.today of
      Nothing -> model.days_finished
      Just today ->
        if Date.year today /= Date.year newToday then
          intAsIntInput 0
        else
          List.foldl accum model.days_finished <| makeDays model

flagify : Model -> Flags
flagify model =
  { finished = alwaysInt model.days_finished
  , required = alwaysInt model.days_required
  , skips = Set.toList model.days_to_skip
  , start = Maybe.map Date.toTime model.today
  }

unflagify : Flags -> Model
unflagify flags =
  Debug.log "unflagified"
  { days_finished = intAsIntInput flags.finished
  , days_required = intAsIntInput flags.required
  , days_to_skip = Set.fromList flags.skips
  , today = Maybe.map Date.fromTime flags.start
  }

view : Model -> Html.Html Msg
view model =
  Html.div [ Html.Attributes.class "container" ]
  [ Html.div []
    [ configView model
    , calendarView model
    ]
  ]

configView : Model -> Html.Html Msg
configView model =
  let
    configLine prompt (s, val) mkmsg =
      Html.div [ Html.Attributes.class "row" ]
        [ Html.div [ Html.Attributes.class "col-1" ] []
        , Html.div [ Html.Attributes.class "col-2" ] [ Html.text prompt ]
        , Html.div [ Html.Attributes.class "col-2" ] [ Html.input [ Html.Events.onInput mkmsg, Html.Attributes.value s ] [] ]
        , Html.div [ Html.Attributes.class "col-2" ] [ configError val ]
        ]
    configError val =
      case val of
        Ok _ -> Html.text ""
        Err msg -> Html.span [ Html.Attributes.class "config-error" ] [ Html.text msg ]
  in
    Html.div []
      [ configLine "Days Finished" model.days_finished UpdateDaysFinished
      , configLine "Days Required" model.days_required UpdateDaysRequired
      ]

calendarView : Model -> Html.Html Msg
calendarView model =
  -- todo:
  -- [x] click day to skip
  -- [x] click week to skip
  -- [ ] use query string or local storage for data
  let
    months = makeCalendar model
  in
    Html.div [] <|
      List.map renderMonth months

renderMonth : Calendar.Month -> Html.Html Msg
renderMonth month =
  let
    notSunday info _ = Date.Sat /= Date.dayOfWeek info.date
    monthNameRow =
      Html.div [ Html.Attributes.class "row" ]
        [ Html.div [ Html.Attributes.class "col-1" ] []
        , Html.div [ Html.Attributes.class "col-4" ] [ Html.h2 [ Html.Attributes.class "month-name" ] [ Html.text (toString month.month) ] ]
        ]
  in
    groupWhile notSunday month.days
      |> List.map renderWeek
      |> (::) monthNameRow
      |> Html.div [ Html.Attributes.class "month" ]

renderWeek : List Calendar.Day -> Html.Html Msg
renderWeek days =
  let
    firstDOW =
      case head days of
        Nothing -> Date.Sun
        Just firstDay -> Date.dayOfWeek firstDay.date
    padCount =
      case head days of
        Nothing -> 0
        Just day -> padCountFor day.date
    padCountFor date =
      case Date.dayOfWeek date of
        Date.Sun -> 0
        _ -> 1 + padCountFor (subDay date)
    pad = List.repeat padCount (Html.div [ Html.Attributes.class "col-1 pad-day" ] [])

    whatClass day =
      case day.what of
        Calendar.NoSchool -> "no-school"
        Calendar.Weekend -> "no-school"
        Calendar.School _ -> "school"
    dayDesc day =
      case day.what of
        Calendar.School n -> (toString n) ++ " days"
        Calendar.NoSchool -> "(skip)"
        Calendar.Weekend -> ""
    act day =
      case day.what of
        Calendar.School _ -> SkipDay day.date
        Calendar.NoSchool -> UnskipDay day.date
        Calendar.Weekend -> Noop
    htmlDay day =
      Html.div [ Html.Events.onClick (act day), Html.Attributes.class ("col-1 day " ++ (whatClass day)) ]
        [ Html.h6 [ Html.Attributes.class "day-number" ] [ Html.text <| toString <| Date.day day.date ]
        , Html.text <| dayDesc day
        ]
    htmlDays = List.map htmlDay days

    weekAct act label =
      Html.span
        [ Html.Attributes.class "week-action"
        , Html.Events.onClick <| act <| List.map .date days
        ]
        [ Html.text label ]
    weekActs =
      Html.div [ Html.Attributes.class "col-1 week-actions" ]
        [ weekAct SkipDays "NO"
        , weekAct UnskipDays "YES"
        ]
  in
    [weekActs] ++ pad ++ htmlDays |> Html.div [ Html.Attributes.class "row" ]

groupByWeek : List Calendar.Day -> List (List Calendar.Day)
groupByWeek days =
  []

makeDays : Model -> List Calendar.Day
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
            Calendar.School n -> n
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
        Calendar.Weekend
      else if Set.member (toComparableDate info.date) model.days_to_skip then
        Calendar.NoSchool
      else if info.completed < (alwaysInt model.days_required) then
        Calendar.School <| info.completed + 1
      else
        Calendar.Weekend
  in
    case model.today of
      Nothing -> []
      Just d -> makeDaysRec [] (Date.year d) (firstDayInfo d model)

makeCalendar : Model -> Calendar.Calendar
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


addDay date =
  Date.fromTime <| 24 * hour + (Date.toTime date)

subDay date =
  Date.fromTime <| (Date.toTime date) - 24 * hour

isWeekend date =
  case Date.dayOfWeek date of
    Date.Mon -> False
    Date.Tue -> False
    Date.Wed -> False
    Date.Thu -> False
    Date.Fri -> False
    Date.Sat -> True
    Date.Sun -> True

alwaysInt : IntInput -> Int
alwaysInt (_, res) =
  case res of
    Err _ -> 0
    Ok n -> n

-- exactly like
-- https://github.com/elm-community/list-extra/blob/36b63fc2ab1b1b602a30dbc71e9b829a0f325e21/src/List/Extra.elm#L285-L298
uncons : List a -> Maybe (a, List a)
uncons list =
  case list of
    [] -> Nothing
    x :: xs -> Just ( x, xs )

-- kind of inspired by
-- https://github.com/elm-community/list-extra/blob/36b63fc2ab1b1b602a30dbc71e9b829a0f325e21/src/List/Extra.elm#L1302-L1328
groupWhile : (a -> a -> Bool) -> List a -> List (List a)
groupWhile keepGrouping xs =
  let
    prepend x (cur, rest) =
      case head cur of
        Nothing -> ([x], rest)
        Just y ->
          if keepGrouping x y then
            (x :: cur, rest)
          else
            ([x], cur :: rest)
  in
    case List.foldr prepend ([], []) xs of
      ([], res) -> res
      (cur, res) -> cur :: res
