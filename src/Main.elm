port module Main exposing (..)

import Date exposing (Date)
import Html

type Msg = UpdateDaysFinished Int
         | UpdateDaysRequired Int
         | SkipDay Date
         | UnskipDay Date

type alias Model =
  { days_finished : Int
  , days_required : Int
  , days_to_skip : List Date }

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
  ({ days_finished = 0, days_required = 180, days_to_skip = [] }, title "School Days Remaining")

sub : Model -> Sub Msg
sub model = Sub.none

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let
    updated_model =
      case msg of
        UpdateDaysFinished n -> { model | days_finished = n }
        UpdateDaysRequired n -> { model | days_required = n }
        SkipDay date -> { model | days_to_skip = date :: model.days_to_skip }
        UnskipDay date -> { model | days_to_skip = List.filter (\d -> d /= date) model.days_to_skip }
  in
    (updated_model, Cmd.none)

view : Model -> Html.Html Msg
view model =
  Html.text "todo"
