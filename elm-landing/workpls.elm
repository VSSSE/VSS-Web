<<<<<<< HEAD
port module MovieTunes exposing (..)

import Html exposing (Html, Attribute, div, input, text, button, program, span)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
=======
import Html exposing (Html, Attribute, div, input, text, button, program)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
-- JSON DECODER importsimport Json.Decode as Jdec
>>>>>>> 61ae5dff9e94894944430a253ddb583781a7d6b9
import Json.Decode.Pipeline as Jpipe
import Json.Encode as Jenc
import Json.Decode as Jdec
import Dict exposing (Dict, map, toList)
import List exposing (map)

<<<<<<< HEAD
-- outbound port
port query : String -> Cmd msg
-- inbound port
port answer :

=======
>>>>>>> 61ae5dff9e94894944430a253ddb583781a7d6b9
main : Program Never Model Msg
main = program
  { init = init
  , view = view
  , update = update
  , subscriptions = (\_ -> Sub.none)
  }

init : (Model, Cmd Msg)
init = (Model "" [], Cmd.none)

-- Model

type alias Model =
  { input : String
  , songs : List Song
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

showSongList : List Song -> List (Html Msg)
showSongList songList =
  List.map showSong songList

showSong : Song -> Html Msg
showSong song =
  div [ class "song"]
  [ span [] [ text (toString song.nr) ]
  , span [ class "title" ] [ text song.name ]
  , span [ class "artist" ] [ text song.artist ]
  ]

-- DECODER

type alias SoundtrackDecoder =
    { purpleSoundtrack : List Song
    }

type alias Song =
    { artist : String
    , id : Int
    , name : String
    , nr : Int
    , url : String
    }

api =
  "./elm-landing/demo.json"


soundtrackDecoder : Jdec.Decoder SoundtrackDecoder
soundtrackDecoder =
    Jpipe.decode SoundtrackDecoder
        |> Jpipe.required "soundtrack" (Jdec.list soundtrack)


soundtrack : Jdec.Decoder Song
soundtrack =
    Jpipe.decode Song
        |> Jpipe.required "artist" Jdec.string
        |> Jpipe.required "id" Jdec.int
        |> Jpipe.required "name" Jdec.string
        |> Jpipe.required "nr" Jdec.int
        |> Jpipe.required "url" Jdec.string

-- HELPERS
