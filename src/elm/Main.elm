module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random


-- MODEL


type alias Model =
    -- IIRC you can't iterate over a records keys. Using a list we have to
    -- iterate over for *every* relevant ability seems like madness though.
    -- FWIW, this is similar to how James Moore stored players in the demo
    -- scoreboard app from knowthen. Perhaps the solution is a union type of
    -- the different abilities?
    { dieFace : Int
    , bonus : Int
    , abilities : List Ability
    , skills : List Skill
    }


type alias Ability =
    { score :
        Int
        -- Would it be wise to cache the "modifier", it is derived exclusively
        -- from the score.
    , name : String
    }


type alias Skill =
    -- Perhaps this should be the `Ability` itself, rather than its `name`
    { ranks : Int
    , ability : String
    , name : String
    }


init : ( Model, Cmd Msg )
init =
    let
        newAbility =
            Ability 10

        abilityNames =
            [ "STR", "DEX", "CON", "INT", "WIS", "CHA" ]

        newSkill =
            Skill 0
    in
        ( { abilities = List.map newAbility abilityNames
          , skills =
                [ newSkill "DEX" "Acrobatics"
                , newSkill "INT" "Appraise"
                , newSkill "CHA" "Bluff"
                , newSkill "STR" "Climb"
                , newSkill "INT" "Craft"
                , newSkill "CHA" "Diplomacy"
                , newSkill "DEX" "Disable Device"
                , newSkill "CHA" "Disguise"
                , newSkill "DEX" "Escape Artist"
                , newSkill "DEX" "Fly"
                , newSkill "CHA" "Handle Animal"
                , newSkill "WIS" "Heal"
                , newSkill "CHA" "Intimidate"
                , newSkill "INT" "Knowledge (Arcana)"
                , newSkill "INT" "Knowledge (Dungeoneering)"
                , newSkill "INT" "Knowledge (Engineering)"
                , newSkill "INT" "Knowledge (Geography)"
                , newSkill "INT" "Knowledge (History)"
                , newSkill "INT" "Knowledge (Local)"
                , newSkill "INT" "Knowledge (Nature)"
                , newSkill "INT" "Knowledge (Nobility)"
                , newSkill "INT" "Knowledge (Planes)"
                , newSkill "INT" "Knowledge (Religion)"
                , newSkill "INT" "Linguistics"
                , newSkill "WIS" "Perception"
                , newSkill "CHA" "Perform"
                , newSkill "WIS" "Profession"
                , newSkill "DEX" "Ride"
                , newSkill "WIS" "Sense Motive"
                , newSkill "DEX" "Sleight of Hand"
                , newSkill "INT" "Spellcraft"
                , newSkill "DEX" "Stealth"
                , newSkill "WIS" "Survival"
                , newSkill "STR" "Swim"
                , newSkill "CHA" "Use Magic Device"
                ]
          , dieFace = 0
          , bonus = 0
          }
        , Cmd.none
        )



-- MESSAGES


type Msg
    = AbilityScore String String
    | SkillRank String String
    | Roll Int
    | NewFace Int



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AbilityScore name score ->
            ( { model | abilities = (abilityScore model.abilities name score) }, Cmd.none )

        SkillRank name ranks ->
            ( { model | skills = (skillRank model.skills name ranks) }, Cmd.none )

        Roll bonus ->
            ( { model | bonus = bonus }, Random.generate NewFace (Random.int 1 20) )

        NewFace newFace ->
            ( { model | dieFace = newFace }, Cmd.none )


skillRank : List Skill -> String -> String -> List Skill
skillRank skills name newRanks =
    case (String.toInt newRanks) of
        Ok ranks ->
            List.map
                (\skill ->
                    if skill.name == name then
                        -- I could abstract skillRanks and abilityScore into a
                        -- single function if I knew how to use a variable key
                        -- ("ranks" vs "score" in the following).
                        { skill | ranks = (Basics.max 0 ranks) }
                    else
                        skill
                )
                skills

        Err err ->
            skills


abilityScore : List Ability -> String -> String -> List Ability
abilityScore abilities name newScore =
    case (String.toInt newScore) of
        Ok score ->
            List.map
                (\ability ->
                    if ability.name == name then
                        { ability | score = (Basics.max 0 score) }
                    else
                        ability
                )
                abilities

        Err err ->
            abilities


abilityModifier : Int -> Int
abilityModifier score =
    score
        |> (+) -10
        |> toFloat
        |> (*) 0.5
        |> floor



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [ class "some-class" ] [ text "Elm Character Sheet" ]
        , dieDisplay model
        , abilities model.abilities
        , skills model
        ]


abilities : List Ability -> Html Msg
abilities abilities =
    div []
        [ h2 [ id "some-id" ] [ text "Abilities" ]
        , abilityHeader
            :: (List.map ability abilities)
            |> table []
        ]


abilityHeader : Html Msg
abilityHeader =
    tr []
        [ th [] [ text "Ability" ]
        , th [] [ text "Score" ]
        , th [] [ text "Modifier" ]
        ]


ability : Ability -> Html Msg
ability ability =
    -- Naming conventions for functions and their params. This is the pattern
    -- used by James Moore, but it seems that way lies madness.
    tr []
        [ td []
            [ text ability.name ]
        , td []
            [ input
                [ value (toString ability.score)
                , onInput (AbilityScore ability.name)
                , type_ "number"
                  -- Is it better to enforce the minimum here, in the update
                  -- handler or both?
                , Html.Attributes.min "0"
                ]
                []
            ]
        , td []
            [ text
                (ability.score
                    |> abilityModifier
                    |> toString
                )
            ]
        , td [] [ button [ onClick (Roll (abilityModifier ability.score)) ] [ text "Roll" ] ]
        ]


skills : Model -> Html Msg
skills model =
    div []
        [ h2 [ id "some-id" ] [ text "Skills" ]
        , skillHeader
            :: (List.map (skill model) model.skills)
            |> table []
        ]


skillHeader : Html Msg
skillHeader =
    tr []
        [ th [] [ text "Name" ]
        , th [] [ text "Bonus" ]
        , th [] [ text "Ability" ]
        , th [] [ text "Ability Mod" ]
        , th [] [ text "Ranks" ]
        , th [] [ text "Skill Check" ]
        ]


skill : Model -> Skill -> Html Msg
skill model skill =
    let
        bonus =
            (skillModifier model skill)
    in
        tr []
            [ td [] [ text skill.name ]
            , td [] [ text (toString bonus) ]
            , td [] [ text skill.ability ]
              -- I hate having to pass around the entire model for this value
            , td [] [ text (toString (modifierFromName model.abilities skill.ability)) ]
            , td []
                [ input
                    [ value (toString skill.ranks)
                    , onInput (SkillRank skill.name)
                    , type_ "number"
                    , Html.Attributes.min "0"
                    ]
                    []
            , td [] [ button [ onClick (Roll bonus) ] [ text "Roll" ] ]
            ]


dieDisplay : Model -> Html Msg
dieDisplay model =
    div []
        [ h1 [] [ text (toString (model.dieFace + model.bonus)) ]
        ]


skillModifier : Model -> Skill -> Int
skillModifier model skill =
    let
        abilityModifier =
            modifierFromName model.abilities skill.ability
    in
        skill.ranks + abilityModifier


modifierFromName : List Ability -> String -> Int
modifierFromName abilities name =
    let
        ability =
            abilities
                |> List.filter (\ability -> ability.name == name)
                |> List.head
    in
        case ability of
            Just ability ->
                abilityModifier ability.score

            -- Perhaps this should be an error...
            Nothing ->
                0


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
