-- To decode the JSON data, add this file to your project, run
--
--     elm-package install NoRedInk/elm-decode-pipeline
--
-- add these imports
--
--     import Json.Decode exposing (decodeString)
<<<<<<< HEAD
--     import SoundtrackDecoder exposing (soundtrackDecoder)
--
-- and you're off to the races with
--
--     decodeString soundtrackDecoder myJsonString

module SoundtrackDecoder exposing
    ( SoundtrackDecoder
    , soundtrackDecoderToString
    , soundtrackDecoder
    , Soundtrack
=======
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
>>>>>>> 61ae5dff9e94894944430a253ddb583781a7d6b9
    )

import Json.Decode as Jdec
import Json.Decode.Pipeline as Jpipe
import Json.Encode as Jenc
import Dict exposing (Dict, map, toList)
import List exposing (map)

<<<<<<< HEAD
type alias SoundtrackDecoder =
    { purpleSoundtrack : List Soundtrack
    }

type alias Soundtrack =
=======
type alias Welcome =
    { id : String
    , name : String
    , purpleSoundtrackList : List SoundtrackList
    }

type alias SoundtrackList =
>>>>>>> 61ae5dff9e94894944430a253ddb583781a7d6b9
    { artist : String
    , id : String
    , name : String
    , nr : String
    , url : String
    }

-- decoders and encoders

<<<<<<< HEAD
soundtrackDecoderToString : SoundtrackDecoder -> String
soundtrackDecoderToString r = Jenc.encode 0 (encodeSoundtrackDecoder r)

soundtrackDecoder : Jdec.Decoder SoundtrackDecoder
soundtrackDecoder =
    Jpipe.decode SoundtrackDecoder
        |> Jpipe.required "soundtrack" (Jdec.list soundtrack)

encodeSoundtrackDecoder : SoundtrackDecoder -> Jenc.Value
encodeSoundtrackDecoder x =
    Jenc.object
        [ ("soundtrack", makeListEncoder encodeSoundtrack x.purpleSoundtrack)
        ]

soundtrack : Jdec.Decoder Soundtrack
soundtrack =
    Jpipe.decode Soundtrack
=======
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
>>>>>>> 61ae5dff9e94894944430a253ddb583781a7d6b9
        |> Jpipe.required "artist" Jdec.string
        |> Jpipe.required "id" Jdec.string
        |> Jpipe.required "name" Jdec.string
        |> Jpipe.required "nr" Jdec.string
        |> Jpipe.required "url" Jdec.string
<<<<<<< HEAD
=======

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
>>>>>>> 61ae5dff9e94894944430a253ddb583781a7d6b9
