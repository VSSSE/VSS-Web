import Html exposing (Html, Attribute, div, input, text, button, program)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
-- JSON DECODER importsimport Json.Decode as Jdec
import Json.Decode.Pipeline as Jpipe
import Json.Encode as Jenc
import Json.Decode as Jdec
import Dict exposing (Dict, map, toList)
import List exposing (map)

main : Program Never Model Msg
main = program
  { init = init
  , view = view
  , update = update
  , subscriptions = (\_ -> Sub.none)
  }

init : (Model, Cmd Msg)
init = (Model "", Cmd.none)

-- Model

type alias Model =
  {
    input : String
  }

-- Update

type Msg
  = NewInput String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
      NewInput text ->
        { model | input = text } ! []

-- View

view : Model -> Html Msg
view model =
  div []
  [ input [ placeholder "title...", onInput NewInput] []
  , button [] [ text "search" ]
  , div [] [ text (model.input) ]
  ]

-- DECODER

type alias Movie =
    { id : String
    , name : String
    , soundtrack : Soundtrack
    }

type alias Soundtrack =
    { songs : List Song }

type alias Song =
    { artist : String
    , id : String
    , name : String
    , nr : String
    , url : String
    }

api =
  "./elm-landing/demo.json"

-- decoders and encoders

decodeMovie : Jdec.Decoder Movie
decodeMovie =
    Jpipe.decode Movie
        |> Jpipe.required "id" Jdec.string
        |> Jpipe.required "name" Jdec.string
        |> Jpipe.required "soundtrack" (Jdec.list Soundtrack)


decodeSong : Jdec.Decoder Song
decodeSong =
    Jpipe.decode Song
        |> Jpipe.required "artist" Jdec.string
        |> Jpipe.required "id" Jdec.string
        |> Jpipe.required "name" Jdec.string
        |> Jpipe.required "nr" Jdec.string
        |> Jpipe.required "url" Jdec.string
