module Helpers exposing (fromStyledHtml)

import Html.Styled as H exposing (Html)
import Test.Html.Query as Q exposing (Single)


fromStyledHtml : Html msg -> Single msg
fromStyledHtml =
    H.toUnstyled >> Q.fromHtml
