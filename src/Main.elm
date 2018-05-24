port module Main exposing (..)

import Date exposing (Date)
import Html
import Html.Attributes
import Html.Events
import List exposing (reverse)
import Task exposing (perform)
import Time exposing (hour)

import Debug

type alias ParsedInt = Result String Int

type Msg = SetToday Date
         | UpdateDaysFinished (String, ParsedInt)
         | UpdateDaysRequired (String, ParsedInt)
         | SkipDay Date
         | UnskipDay Date

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
  -- * transform model so that it:
  --  (1) starts on Sunday
  --  (2) has the day numbers in the struct, and any other info for drawing
  --  (3) splits up months (?)
  -- * render as bootstrap rows
  let
    allTheDays = makeCalendar model
  in
    Html.div [] <|
      Debug.log (toString allTheDays) []

type alias Calendar = List Month
type alias Month = { name : String, days : List Day }
type alias Day =
  { date : Date
  , what : TypeOfDay
  }
type TypeOfDay = NoSchool
               | School Int

makeCalendar : Model -> Calendar
makeCalendar model =
  let
    makeDays currentYear info res =
      if Date.year info.date /= currentYear then
        reverse res
      else
        let
          d = makeDay info
        in
          makeDays currentYear (nextDayInfo info d) (d :: res)

    nextDayInfo info d =
      { info
      | date = addDay info.date
      , completed =
          case d.what of
            NoSchool -> info.completed
            School n -> n
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
      if isSchoolDay info then
        School <| info.completed + 1
      else
        NoSchool

    isSchoolDay info =
      if isWeekend info.date then
        False
      else if List.member info.date model.days_to_skip then
        False
      else
        True
  in
    case model.today of
      Nothing -> []
      Just today ->
        [{name = "todo", days = makeDays (Date.year today) (firstDayInfo today model) []}]

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
