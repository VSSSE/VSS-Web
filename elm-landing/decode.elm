-- To decode the JSON data, add this file to your project, run
--
--     elm-package install NoRedInk/elm-decode-pipeline
--
-- add these imports
--
--     import Json.Decode exposing (decodeString)
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
    )

import Json.Decode as Jdec
import Json.Decode.Pipeline as Jpipe
import Json.Encode as Jenc
import Dict exposing (Dict, map, toList)
import List exposing (map)

type alias SoundtrackDecoder =
    { purpleSoundtrack : List Soundtrack
    }

type alias Soundtrack =
    { artist : String
    , id : String
    , name : String
    , nr : String
    , url : String
    }

-- decoders and encoders

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
        |> Jpipe.required "artist" Jdec.string
        |> Jpipe.required "id" Jdec.string
        |> Jpipe.required "name" Jdec.string
        |> Jpipe.required "nr" Jdec.string
        |> Jpipe.required "url" Jdec.string
