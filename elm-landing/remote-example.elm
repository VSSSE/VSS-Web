module Main exposing (..)

import RemoteData exposing (WebData, RemoteData(..), asCmd, fromTask)
import Html exposing (Html, text, div, input, br)
import Html.Events exposing (onClick)
import Html.Attributes exposing (type_, value)
import Http exposing (get, toTask)
import Json.Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (decode, required)
import Random exposing (int, generate)
import Task exposing (Task, andThen, attempt, perform)


type alias Person =
    { name : String
    , gender : String
    }


type alias Starship =
    { name : String
    , model : String
    }


type alias Model =
    { person : WebData Person
    , starship : WebData Starship
    , counter : Int
    }


type Msg
    = PersonResponse (WebData Person)
    | StarshipResponse (WebData Starship)
    | GetPerson
    | GenerateRandomNumber
    | NewNumber Int


decodePerson : Decoder Person
decodePerson =
    decode Person
        |> required "name" string
        |> required "gender" string


decodeStarship : Decoder Starship
decodeStarship =
    decode Starship
        |> required "name" string
        |> required "model" string


getPerson : Int -> Cmd Msg
getPerson id =
    Http.get ("http://swapi.co/api/people/" ++ (toString id)) decodePerson
        |> RemoteData.sendRequest
        |> Cmd.map PersonResponse


getStarship : Int -> Cmd Msg
getStarship id =
    Http.get ("http://swapi.co/api/starships/" ++ (toString id)) decodeStarship
        |> RemoteData.sendRequest
        |> Cmd.map StarshipResponse


getPersonTask : Int -> Task.Task Http.Error Person
getPersonTask id =
    Http.get ("http://swapi.co/api/people/" ++ (toString id)) decodePerson
        |> toTask


getStarshipTask : Int -> Task.Task Http.Error Starship
getStarshipTask id =
    Http.get ("http://swapi.co/api/starships/" ++ (toString id)) decodeStarship
        |> toTask


getPersonAndThenStarship : Int -> Cmd Msg
getPersonAndThenStarship id =
    let
        chainedTask =
            getPersonTask id
                |> andThen
                    (\person ->
                        let
                            _ =
                                Debug.log "person" person
                        in
                            getStarshipTask 9
                    )
    in
        asCmd chainedTask
            |> Cmd.map StarshipResponse


randomIdGenerator : Random.Generator Int
randomIdGenerator =
    int 1 100


init : ( Model, Cmd Msg )
init =
    ( { person = Loading
      , starship = NotAsked
      , counter = 1
      }
    , getPerson 1
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewNumber newNumber ->
            ( { model
                | counter = newNumber
                , person = Loading
                , starship = Loading
              }
            , getPerson newNumber
            )

        GenerateRandomNumber ->
            ( model, generate NewNumber randomIdGenerator )

        PersonResponse response ->
            ( { model
                | person = response
                , starship = Loading
              }
            , getStarship 9
            )

        GetPerson ->
            ( { model | person = Loading }
            , getPersonAndThenStarship model.counter
            )

        StarshipResponse response ->
            ( { model | starship = response }, Cmd.none )


view : Model -> Html Msg
view model =
    case model.person of
        NotAsked ->
            viewPerson model "Initializing: "

        Loading ->
            viewPerson model "Loading: "

        Failure err ->
            viewPerson model ("Error: " ++ toString err)

        Success news ->
            viewPerson model ""


viewPerson : Model -> String -> Html Msg
viewPerson model error =
    div []
        [ text error
        , text (toString model.person)
        , br [] []
        , text (toString model.starship)
        , input
            [ onClick GenerateRandomNumber
            , type_ "button"
            , value "Get Person"
            ]
            []
        ]


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
