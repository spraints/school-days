port module Main exposing (..)

import Date exposing (Date)
import Html
import Html.Attributes
import Html.Events
import List exposing (head, reverse, tail)
import Maybe exposing (withDefault)
import Task exposing (perform)
import Time exposing (hour)

import Debug

type alias ParsedInt = Result String Int

type Msg = SetToday Date
         | UpdateDaysFinished (String, ParsedInt)
         | UpdateDaysRequired (String, ParsedInt)
         | SkipDay Date
         | UnskipDay Date
         | Noop

type alias Model =
  { days_finished : (String, ParsedInt)
  , days_required : (String, ParsedInt)
  , days_to_skip : List Date
  , today : Maybe Date
  }

port title : String -> Cmd a

main = Html.program
  { init = init
  , subscriptions = sub
  , update = update
  , view = view
  }

-- days left
init : (Model, Cmd Msg)
init =
  let
    initialModel =
      { days_finished = ("0", Ok 0)
      , days_required = ("180", Ok 180)
      , days_to_skip = []
      , today = Nothing
      }
    initialActions =
      [ title "School Days Remaining"
      , perform SetToday Date.now
      ]
  in
    (initialModel, Cmd.batch initialActions)

sub : Model -> Sub Msg
sub model = Sub.none

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let
    updated_model =
      case msg of
        Noop -> model
        SetToday date -> { model | today = Just date }
        UpdateDaysFinished n -> { model | days_finished = n } -- todo put this in the url?
        UpdateDaysRequired n -> { model | days_required = n }
        SkipDay date -> { model | days_to_skip = date :: model.days_to_skip }
        UnskipDay date -> { model | days_to_skip = List.filter (\d -> d /= date) model.days_to_skip }
  in
    (updated_model, Cmd.none)

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
        [ Html.div [ Html.Attributes.class "col-2" ] [ Html.text prompt ]
        , Html.div [ Html.Attributes.class "col-2" ] [ Html.input [ Html.Events.onInput <| updateConfig mkmsg, Html.Attributes.value s ] [] ]
        , Html.div [ Html.Attributes.class "col-2" ] [ configError val ]
        ]
    configError val =
      case val of
        Ok _ -> Html.text ""
        Err msg -> Html.span [ Html.Attributes.class "config-error" ] [ Html.text msg ]
    updateConfig mkmsg s =
      mkmsg (s, String.toInt s)
  in
    Html.div []
      [ configLine "Days Finished" model.days_finished UpdateDaysFinished
      , configLine "Days Required" model.days_required UpdateDaysRequired
      ]

calendarView : Model -> Html.Html Msg
calendarView model =
  Html.div [] [ ycalendarView model, xcalendarView model ]

ycalendarView : Model -> Html.Html Msg
ycalendarView model =
  -- todo:
  -- [x] click day to skip
  -- [ ] click week to skip
  -- [ ] use query string for data
  let
    months = makeCalendar model
  in
    Html.div [] <|
      List.map renderMonth months

renderMonth : Month -> Html.Html Msg
renderMonth month =
  let
    notSunday info _ = Date.Sat /= Date.dayOfWeek info.date
  in
    groupWhile notSunday month.days
      |> List.map renderWeek
      |> (::) (Html.h2 [ Html.Attributes.class "month-name" ] [ Html.text (toString month.month) ])
      |> Html.div [ Html.Attributes.class "month" ]

renderWeek : List Day -> Html.Html Msg
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
        NoSchool -> "no-school"
        Weekend -> "no-school"
        School _ -> "school"
    dayDesc day =
      case day.what of
        School n -> (toString n) ++ " days"
        NoSchool -> "(skip)"
        Weekend -> ""
    act day =
      case day.what of
        School _ -> SkipDay day.date
        NoSchool -> UnskipDay day.date
        Weekend -> Noop
    htmlDay day =
      Html.div [ Html.Events.onClick (act day), Html.Attributes.class ("col-1 day " ++ (whatClass day)) ]
        [ Html.h6 [ Html.Attributes.class "day-number" ] [ Html.text <| toString <| Date.day day.date ]
        , Html.text <| dayDesc day
        ]
    htmlDays = List.map htmlDay days
  in
    pad ++ htmlDays |> Html.div [ Html.Attributes.class "row" ]

groupByWeek : List Day -> List (List Day)
groupByWeek days =
  []

type alias Calendar = List Month
type alias Month = { month : Date.Month, days : List Day }
type alias Day =
  { date : Date
  , what : TypeOfDay
  }
type TypeOfDay = NoSchool
               | Weekend
               | School Int

makeCalendar : Model -> Calendar
makeCalendar model =
  let
    makeDays = makeDaysRec []
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
      else if List.member info.date model.days_to_skip then
        NoSchool
      else
        School <| info.completed + 1

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
    case model.today of
      Nothing -> []
      Just today ->
        firstDayInfo today model
          |> makeDays (Date.year today)
          |> splitMonths

xcalendarView : Model -> Html.Html Msg
xcalendarView model =
  let
    calendarFor res date year n =
      if year /= Date.year date then
        res
      else if isWeekend date then
        calendarFor (res ++ (calendarDayView date "no school")) (addDay date) year n
      else if List.member date model.days_to_skip then
        calendarFor (res ++ skippableDayView date "skipped" UnskipDay) (addDay date) year n
      else
        calendarFor (res ++ skippableDayView date ("#" ++ (toString n)) SkipDay) (addDay date) year (n + 1)

    calendarDayView date desc =
      [ Html.tr [] [ Html.td [] [ Html.text <| toString date ], Html.td [] [ Html.text desc ] ] ]
    skippableDayView date desc act =
      [ Html.tr [] [ Html.td [] [ Html.text <| toString date ], Html.td [] [ Html.text desc ], Html.td [] [ Html.button [ Html.Events.onClick (act date) ] [ Html.text "~" ] ] ] ]

    calendarStartingAt today =
      calendarFor [] today (Date.year today) ((alwaysInt model.days_finished) + 1)
  in
    case model.today of
      Just today -> Html.table [] <| calendarStartingAt today
      Nothing -> Html.text "don't know what today is :("

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

alwaysInt : (String, ParsedInt) -> Int
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
