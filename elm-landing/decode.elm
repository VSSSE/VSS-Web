-- To decode the JSON data, add this file to your project, run
--
--     elm-package install NoRedInk/elm-decode-pipeline
--
-- add these imports
--
--     import Json.Decode exposing (decodeString)
--     import MovieDecoder exposing (welcome)
--
-- and you're off to the races with
--
--     decodeString welcome myJsonString

module MovieDecoder exposing
    ( Welcome
    , welcomeToString
    , welcome
    , SoundtrackList
    )

import Json.Decode as Jdec
import Json.Decode.Pipeline as Jpipe
import Json.Encode as Jenc
import Dict exposing (Dict, map, toList)
import List exposing (map)

type alias Welcome =
    { id : String
    , name : String
    , purpleSoundtrackList : List SoundtrackList
    }

type alias SoundtrackList =
    { artist : String
    , id : String
    , name : String
    , nr : String
    , url : String
    }

-- decoders and encoders

welcomeToString : Welcome -> String
welcomeToString r = Jenc.encode 0 (encodeWelcome r)

welcome : Jdec.Decoder Welcome
welcome =
    Jpipe.decode Welcome
        |> Jpipe.required "id" Jdec.string
        |> Jpipe.required "name" Jdec.string
        |> Jpipe.required "soundtrackList" (Jdec.list soundtrackList)

encodeWelcome : Welcome -> Jenc.Value
encodeWelcome x =
    Jenc.object
        [ ("id", Jenc.string x.id)
        , ("name", Jenc.string x.name)
        , ("soundtrackList", makeListEncoder encodeSoundtrackList x.purpleSoundtrackList)
        ]

soundtrackList : Jdec.Decoder SoundtrackList
soundtrackList =
    Jpipe.decode SoundtrackList
        |> Jpipe.required "artist" Jdec.string
        |> Jpipe.required "id" Jdec.string
        |> Jpipe.required "name" Jdec.string
        |> Jpipe.required "nr" Jdec.string
        |> Jpipe.required "url" Jdec.string

encodeSoundtrackList : SoundtrackList -> Jenc.Value
encodeSoundtrackList x =
    Jenc.object
        [ ("artist", Jenc.string x.artist)
        , ("id", Jenc.string x.id)
        , ("name", Jenc.string x.name)
        , ("nr", Jenc.string x.nr)
        , ("url", Jenc.string x.url)
        ]

--- encoder helpers

makeListEncoder : (a -> Jenc.Value) -> List a -> Jenc.Value
makeListEncoder f arr =
    Jenc.list (List.map f arr)

makeDictEncoder : (a -> Jenc.Value) -> Dict String a -> Jenc.Value
makeDictEncoder f dict =
    Jenc.object (toList (Dict.map (\k -> f) dict))

makeNullableEncoder : (a -> Jenc.Value) -> Maybe a -> Jenc.Value
makeNullableEncoder f m =
    case m of
    Just x -> f x
    Nothing -> Jenc.null
