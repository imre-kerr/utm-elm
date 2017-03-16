port module Converter exposing (..)

type alias Utm = 
    { coord :
        { x : Int
        , y : Int
        }
    , isSouthern : Bool
    , zone : Int
    }

type alias Wgs = 
    { coord: 
        { latitude : Float
        , longitude : Float
        }
    }

port toWgs : Utm -> Cmd msg

port receiveWgs : ( Wgs -> msg ) -> Sub msg
