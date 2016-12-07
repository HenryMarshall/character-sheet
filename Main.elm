module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Model =
    { abilities : List Ability
    , skills : List Skill
    }


type alias Ability =
    { score : Int
    , name : String
    }


type alias Skill =
    -- Perhaps this should be the `Ability` itself, rather than its "name"
    { ability : String
    , ranks : Int
    , name : String
    }


initModel : Model
initModel =
    let
        newAbility =
            Ability 10

        abilityNames =
            [ "STR", "DEX", "CON", "INT", "WIS", "CHA" ]
    in
        { abilities = List.map newAbility abilityNames
        , skills =
            [ Skill "DEX" 0 "Acrobatics"
            , Skill "INT" 0 "Appraise"
            , Skill "CHA" 0 "Bluff"
            ]
        }


type Msg
    = AbilityScore
    | SkillRank


update : Msg -> Model -> Model
update msg model =
    case msg of
        _ ->
            model


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Elm Character Sheet" ]
        , abilities model.abilities
        , skills model.skills
        ]


abilities : List Ability -> Html Msg
abilities abilities =
    div []
        [ h2 [] [ text "Abilities" ]
        ]


skills : List Skill -> Html Msg
skills skills =
    div []
        [ h2 [] [ text "Skills" ] ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }
