port module Main exposing (..)

import Date exposing (Date)
import Html
import Html.Attributes
import Html.Events
import Task exposing (perform)

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
        UpdateDaysFinished n -> { model | days_finished = n }
        UpdateDaysRequired n -> { model | days_required = n }
        SkipDay date -> { model | days_to_skip = date :: model.days_to_skip }
        UnskipDay date -> { model | days_to_skip = List.filter (\d -> d /= date) model.days_to_skip }
  in
    (updated_model, Cmd.none)

view : Model -> Html.Html Msg
view model =
  Html.div []
    [ configView model
    , calendarView model
    ]

configView : Model -> Html.Html Msg
configView model =
  let
    configLine prompt (s, val) mkmsg =
      Html.tr []
        [ Html.td [] [ Html.text prompt ]
        , Html.td [] [ Html.input [ Html.Events.onInput <| updateConfig mkmsg, Html.Attributes.value s ] [] ]
        , Html.td [] [ configError val ]
        ]
    configError val =
      case val of
        Ok _ -> Html.text ""
        Err msg -> Html.span [ Html.Attributes.class "config-error" ] [ Html.text msg ]
    updateConfig mkmsg s =
      mkmsg (s, String.toInt s)
  in
    Html.table []
      [ configLine "Days Finished" model.days_finished UpdateDaysFinished
      , configLine "Days Required" model.days_required UpdateDaysRequired
      ]

calendarView : Model -> Html.Html Msg
calendarView model =
  Html.text <| toString model.today
