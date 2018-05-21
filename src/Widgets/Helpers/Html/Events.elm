module Widgets.Helpers.Html.Events exposing (onKeyUp, onTimedKeyUp)

import Char exposing (KeyCode)
import Html.Styled as H
import Html.Styled.Events as H
import Json.Decode as JD


onKeyUp : (KeyCode -> msg) -> H.Attribute msg
onKeyUp handler =
    H.onWithOptions "keyup"
        { stopPropagation = False
        , preventDefault = True
        }
        (JD.map handler H.keyCode)


onTimedKeyUp : (Int -> KeyCode -> msg) -> H.Attribute msg
onTimedKeyUp handler =
    H.onWithOptions "keyup"
        { stopPropagation = False
        , preventDefault = True
        }
        (JD.map2 handler (JD.field "timeStamp" JD.int) (JD.field "keyCode" JD.int))
