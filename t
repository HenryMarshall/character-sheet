[1mdiff --git a/.gitignore b/.gitignore[m
[1mindex 5347dbe..c97d37e 100644[m
[1m--- a/.gitignore[m
[1m+++ b/.gitignore[m
[36m@@ -4,3 +4,4 @@[m [mbuild/[m
 [m
 .directory[m
 npm-debug.log[m
[32m+[m[32m.#*[m
[1mdiff --git a/src/elm/Main.elm b/src/elm/Main.elm[m
[1mindex 80243ef..a4584bb 100644[m
[1m--- a/src/elm/Main.elm[m
[1m+++ b/src/elm/Main.elm[m
[36m@@ -186,18 +186,23 @@[m [msubscriptions model =[m
 [m
 view : Model -> Html Msg[m
 view model =[m
[31m-    div [][m
[31m-        [ h1 [ class "some-class" ] [ text "Elm Character Sheet" ][m
[32m+[m[32m    div [ class "sheet" ][m
[32m+[m[32m        [ header [][m
[32m+[m[32m              [ div [ class "hero" ][m
[32m+[m[32m                    [ h1 [ class "title" ] [ text "Character Sheet" ][m
[32m+[m[32m                    , h2 [ class "subtitle" ] [ text "for Pathfinder" ][m
[32m+[m[32m                    ][m
[32m+[m[32m              , dieDisplay model[m
[32m+[m[32m              ][m
         , abilities model.abilities[m
         , skills model[m
[31m-        , dieDisplay model[m
         ][m
 [m
 [m
 abilities : List Ability -> Html Msg[m
 abilities abilities =[m
[31m-    div [][m
[31m-        [ h2 [ id "some-id" ] [ text "Abilities" ][m
[32m+[m[32m    div [ class "abilities" ][m
[32m+[m[32m        [ h2 [] [ text "Abilities" ][m
         , abilityHeader[m
             :: (List.map ability abilities)[m
             |> table [][m
[36m@@ -243,8 +248,8 @@[m [mability ability =[m
 [m
 skills : Model -> Html Msg[m
 skills model =[m
[31m-    div [][m
[31m-        [ h2 [ id "some-id" ] [ text "Skills" ][m
[32m+[m[32m    div [ class "skills" ][m
[32m+[m[32m        [ h2 [] [ text "Skills" ][m
         , skillHeader[m
             :: (List.map (skill model) model.skills)[m
             |> table [][m
[36m@@ -284,7 +289,7 @@[m [mskill model skill =[m
 [m
 dieDisplay : Model -> Html Msg[m
 dieDisplay model =[m
[31m-    div [][m
[32m+[m[32m    div [ class "die-rolls" ][m
         [ h1 [] [ text (toString model.dieFace) ][m
         , button [ onClick Roll ] [ text "Roll" ][m
         ][m
[36m@@ -316,6 +321,7 @@[m [mmodifierFromName abilities name =[m
                 0[m
 [m
 [m
[32m+[m
 main : Program Never Model Msg[m
 main =[m
     Html.program[m
[1mdiff --git a/src/sass/style.sass b/src/sass/style.sass[m
[1mindex 45af5a2..1c31ff7 100644[m
[1m--- a/src/sass/style.sass[m
[1m+++ b/src/sass/style.sass[m
[36m@@ -1,5 +1,5 @@[m
[31m-.some-class[m
[31m-  color: red[m
[32m+[m[32m@import bourbon/bourbon[m
[32m+[m[32m@import neat/neat[m
[32m+[m[32m@import base/base[m
 [m
[31m-#some-id[m
[31m-  color: blue[m
[32m+[m[32m@import sheet[m
