module Widgets.Dialog exposing (dialog)

{-| A [dialog][wai-dl] is a window overlayed on either the primary window or
another dialog window. Windows under a modal dialog are inert.

@docs dialog

[wai-dl]: https://www.w3.org/TR/wai-aria-practices-1.1/#dialog_modal
[wai-ex]: https://www.w3.org/TR/wai-aria-practices-1.1/examples/dialog-modal/dialog.html

-}

import Array
import Css as C
import Css.Media as Media
import Html.Styled as H exposing (Html)
import Html.Styled.Attributes as H
import Html.Styled.Attributes.Aria as Aria
import Html.Styled.Attributes.Aria as Aria
import Html.Styled.Attributes.Aria.Role as Role
import Html.Styled.Events as H
import KeywordList as K
import Widgets.Dialog.Attributes exposing (Attribute)
import Widgets.Dialog.Elements as Elements exposing (Element)
import Widgets.Dialog.Internal.Context as Context


{-| A modal Dialog element. A id is always required to set ARIA relationships.
A Dialog is not based in others HTML controls so this Widget has more CSS than
the others. Of course, you can override any style.
TODO: Add an example.
-}
dialog : { id : String, title : String } -> List (Attribute msg) -> List ( Element, Html msg ) -> Html msg
dialog { id, title } attrs elements =
    let
        ctx =
            Context.empty
                |> Context.setId id
                |> Context.setTitle title
                |> Context.insertElements elements
                |> Context.insertAttributes attrs

        isLabelled =
            not ctx.titleHidden && Array.isEmpty ctx.titleHtml

        titleTag =
            if Array.isEmpty ctx.titleHtml then
                H.h2
            else
                H.span
    in
        H.div
            (K.fromMany
                [ K.ifTrue isLabelled <| Aria.labelledBy [ Elements.id id Elements.title ]
                , K.ifFalse isLabelled <| Aria.label title
                , K.many
                    [ H.id <| Elements.id id Elements.backdrop
                    , H.css <|
                        K.fromMany
                            [ if ctx.opened then
                                K.many
                                    [ C.backgroundColor <| C.rgba 0 0 0 0.3
                                    , C.bottom C.zero
                                    , C.left C.zero
                                    , C.overflowY C.auto
                                    , C.position C.fixed
                                    , C.right C.zero
                                    , C.top C.zero
                                    ]
                              else
                                K.one <| C.display C.none
                            , K.many <| Array.toList ctx.backdropCss
                            ]
                    ]
                , K.many <| Array.toList ctx.backdropAttrs
                ]
            )
            [ H.div
                (K.fromMany
                    [ K.one <| H.tabindex 0
                    , K.maybeMap H.onFocus ctx.onFocusLeavesBackward
                    ]
                )
                []
            , H.div
                (K.fromMany
                    [ K.many
                        [ Aria.modal True
                        , Aria.role Role.Dialog
                        , H.id <| Elements.id id Elements.window
                        , H.css <|
                            K.fromMany
                                [ K.many
                                    [ C.backgroundColor <| C.rgb 255 255 255
                                    , C.border3 (C.px 1) C.solid (C.rgb 0 0 0)
                                    , C.padding (C.px 5)
                                    , C.boxSizing C.borderBox
                                    , C.minHeight <| C.vh 100
                                    , Media.withMedia [ Media.only Media.screen [ Media.minWidth <| C.px 600 ] ]
                                        [ C.margin2 (C.vh 10) C.auto
                                        , C.property "min-height" "auto"
                                        , C.width <| C.pct 50
                                        ]
                                    ]
                                , K.many <| Array.toList ctx.windowCss
                                ]
                        ]
                    , K.many <| Array.toList ctx.windowAttrs
                    ]
                )
                (K.fromMany
                    [ if ctx.titleHidden then
                        K.zero
                      else
                        K.one <|
                            titleTag
                                (K.fromMany
                                    [ K.one <| H.id <| Elements.id id Elements.title
                                    , K.one <| H.css <| Array.toList ctx.titleCss
                                    , K.many <| Array.toList ctx.titleAttrs
                                    ]
                                )
                                (if Array.isEmpty ctx.titleHtml then
                                    [ H.text title ]
                                 else
                                    Array.toList ctx.titleHtml
                                )
                    , K.many <| Array.toList ctx.windowHtml
                    ]
                )
            , H.div
                (K.fromMany
                    [ K.one <| H.tabindex 0
                    , K.maybeMap H.onFocus ctx.onFocusLeavesForward
                    ]
                )
                []
            ]
