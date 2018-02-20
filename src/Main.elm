port module Main exposing (..)

import Html

type alias Msg = ()
type alias Model = ()

port title : String -> Cmd a

main = Html.program
  { init = init
  , subscriptions = sub
  , update = update
  , view = view
  }

-- days left
init : (Model, Cmd Msg)
init = ((), title "School Days Remaining")

sub : Model -> Sub Msg
sub model = Sub.none

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  (model, Cmd.none)

view : Model -> Html.Html Msg
view model =
  Html.text "todo"
