module Form exposing (main)

import Html
import Docs


main : Html.Html msg
main =
    Docs.toHtml
        [ Docs.markdown """
# elm-widgets / **Form**

**TODO** Basic behaviour. What exports *Form* module and how to use it.

**TODO** `<form>` and `<fieldset>`. ARIA Recommendations.

**TODO** Use `highlight.js` for code blocks. More info in the *elm-markdown*
`README.md`.

"""
        ]
