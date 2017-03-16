import Html exposing (..)
import Html.Events exposing (..)

import Converter exposing (..)

type alias Model = 
    { x : String
    , y : String
    , wgs : Maybe Wgs
    }

type Msg = Received Wgs
    | ChangeX String
    | ChangeY String
    | Convert

init : ( Model, Cmd Msg )
init = ( { x = "", y = "", wgs = Nothing }, Cmd.none )

view : Model -> Html Msg
view model = div []  
    [ h1 [] [text "UTM Converter"]
    , div [] [ label [] [text "X: "] , input [ onInput ChangeX ] [] ]
    , div [] [ label [] [text "Y: "] , input [ onInput ChangeY ] [] ]
    , div [] [button [ onClick Convert ] [ text "Convert" ] ]
    , div [] [
        case model.wgs of
            Nothing -> text "Nothing to show"
            Just wgs -> text ("Lat: " ++ toString wgs.coord.latitude ++ ", Long: " ++ toString wgs.coord.longitude)
        ]
    ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Received wgs ->
            ( { model | wgs = Just wgs }, Cmd.none )
        ChangeX x ->
            ( { model | x = x }, Cmd.none )
        ChangeY y ->
            ( { model | y = y }, Cmd.none )
        Convert ->
            ( model, maybeConvert model.x model.y )


maybeConvert : String -> String -> Cmd msg
maybeConvert x y =
    case (String.toInt x, String.toInt y) of
        (Ok xi, Ok yi) -> 
            toWgs { coord = { x = xi, y = yi }, isSouthern = False, zone = 32 }
        _ -> Cmd.none

subscriptions : Model -> Sub Msg
subscriptions model = receiveWgs Received

main = Html.program { init = init, view = view, update = update, subscriptions = subscriptions}
