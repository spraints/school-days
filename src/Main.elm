port module Main exposing (..)

import Date exposing (Date)
import Html
import Html.Attributes
import Html.Events
import Task exposing (perform)
import Time exposing (hour)

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
  Html.div [] []

xcalendarView : Model -> Html.Html Msg
xcalendarView model =
  let
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

alwaysInt : (String, ParsedInt) -> Int
alwaysInt (_, res) =
  case res of
    Err _ -> 0
    Ok n -> n
