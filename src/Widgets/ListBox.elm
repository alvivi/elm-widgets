module Widgets.ListBox exposing (listBox)

{-| A [listbox][wai-lb] widget presents a list of options and allows a user to
select one or more of them. The widget is similar to Form.select, but this
widget allows custom styles. Also known as Dropdown or Select.

@docs listBox

[wai-lb]: https://www.w3.org/TR/2017/NOTE-wai-aria-practices-1.1-20171214/#Listbox
[wai-ex]: https://www.w3.org/TR/2017/NOTE-wai-aria-practices-1.1-20171214/examples/listbox/listbox-collapsible.html

-}

import Array
import Css as C
import Css.Colors as Color
import Html.Styled as H exposing (Html)
import Html.Styled.Attributes as H
import Html.Styled.Attributes.Aria as Aria
import Html.Styled.Attributes.Aria.Popup as Popup
import Html.Styled.Attributes.Aria.Role as Role
import Html.Styled.Events as H
import KeywordList as K exposing (KeywordList)
import Widgets.Form as Form
import Widgets.Form.Attributes as Form
import Widgets.Form.Elements as Form
import Widgets.Helpers.Css as C
import Widgets.ListBox.Attributes exposing (Attribute)
import Widgets.ListBox.Elements as Elements
import Widgets.ListBox.Internal.Context as Context exposing (Context)
import Widgets.ListBox.Internal.Elements as Elements exposing (Element)


{-| A ListBox element. A id is always required to set ARIA relationships. A
custom set of attributes are available in its own module. Also, a custom set
of children nodes are allowed in order to fill the widget with options or
further personalization.

    Widgets.listBox { id = "listbox" } []
        [ ListBox.textOption "one"
        , ListBox.textOption "two"
        , ListBox.textOption "three"
        , ListBox.textOption "over 9000"
        ]

-}
listBox : { id : String, description : String } -> List (Attribute msg) -> List ( Element, Html msg ) -> Html msg
listBox { id, description } attrs elements =
    let
        ctx =
            Context.empty
                |> Context.setId id
                |> Context.setDescription description
                |> Context.insertElements elements
                |> Context.insertAttributes attrs
    in
        H.div
            (K.fromMany
                [ K.one <| H.id <| Elements.id id Elements.Wrapper
                , K.one <|
                    H.css <|
                        K.fromMany
                            [ K.one <| C.position C.relative
                            , K.many <| Array.toList ctx.wrapperCss
                            ]
                , K.many <| Array.toList ctx.wrapperAttrs
                ]
            )
            (K.fromMany
                [ descriptionView ctx
                , K.one <| buttonView ctx
                , K.one <| listView ctx
                ]
            )


buttonView : Context msg -> Html msg
buttonView ctx =
    Form.button
        (K.fromMany
            [ K.one <|
                Form.html Form.control
                    (K.fromMany
                        [ K.many
                            [ Aria.hasPopup Popup.Listbox
                            , H.id <| Elements.id ctx.id Elements.Button
                            ]
                        , K.ifTrue ctx.expanded (Aria.expanded True)
                        , labelAttributes ctx
                        ]
                    )
            , K.one <|
                Form.css Form.control <|
                    K.fromMany
                        [ K.maybeMap C.paddingRight <| iconPadding ctx
                        ]
            , K.many <| Array.toList ctx.buttonAttrs
            ]
        )
        (K.fromMany
            [ iconView ctx
            , if Array.isEmpty ctx.buttonHtml then
                K.one <| H.text <| buttonText ctx
              else
                K.many <| Array.toList ctx.buttonHtml
            ]
        )


buttonText : Context msg -> String
buttonText ctx =
    ctx
        |> Context.selected
        |> Maybe.map .text
        |> Maybe.withDefault
            (ctx.placeholder
                |> Maybe.withDefault
                    (ctx.options
                        |> Array.get 0
                        |> Maybe.map (Tuple.first >> .text)
                        |> Maybe.withDefault ctx.description
                    )
            )


descriptionView : Context msg -> KeywordList (Html msg)
descriptionView ctx =
    if Context.hasDescriptionVisible ctx then
        K.one <|
            H.span
                (K.fromMany
                    [ K.one <| H.id <| Elements.id ctx.id Elements.Description
                    , K.ifFalse (Array.isEmpty ctx.descriptionCss) (H.css <| Array.toList ctx.descriptionCss)
                    , K.many <| Array.toList ctx.descriptionAttrs
                    ]
                )
                (if Array.isEmpty ctx.descriptionHtml then
                    [ H.text ctx.description ]
                 else
                    Array.toList ctx.descriptionHtml
                )
    else
        K.zero


iconView : Context msg -> KeywordList (Html msg)
iconView { iconAttrs, iconCss, iconHtml } =
    if Array.isEmpty iconHtml then
        K.zero
    else
        let
            hasNoStyle =
                Array.isEmpty iconCss
        in
            K.one <|
                H.span
                    [ H.css
                        [ C.display C.inlineBlock
                        , C.height <| C.pct 100
                        , C.position C.relative
                        ]
                    ]
                    [ H.span
                        (K.fromMany
                            [ K.many
                                [ Aria.hidden True
                                , H.css <|
                                    K.fromMany
                                        [ K.many
                                            [ C.height iconSide
                                            , C.width iconSide
                                            , C.display C.inlineBlock
                                            , C.position C.relative
                                            , C.marginRight iconPaddingHorizontal
                                            , C.top iconPaddingVertical
                                            ]
                                        , K.many <| Array.toList iconCss
                                        ]
                                ]
                            , K.many <| Array.toList iconAttrs
                            ]
                        )
                        (Array.toList iconHtml)
                    ]


listView : Context msg -> Html msg
listView ctx =
    H.ul
        (K.fromMany
            [ K.many
                [ Aria.role Role.Listbox
                , H.id <| Elements.id ctx.id Elements.List
                , H.tabindex -1
                , H.css
                    (K.fromMany
                        [ K.many
                            [ C.backgroundColor Color.white
                            , C.border3 (C.px 1) C.solid Color.silver
                            , C.intrinsicWidth
                            , C.listStyleType C.none
                            , C.margin C.zero
                            , C.paddingLeft C.zero
                            , C.position C.absolute
                            ]
                        , K.ifTrue ctx.expanded <| C.display C.block
                        , K.ifFalse ctx.expanded <| C.display C.none
                        , K.many <| Array.toList ctx.listCss
                        ]
                    )
                ]
            , K.maybeMap (.id >> Aria.activeDescendant) (Context.selected ctx)
            , labelAttributes ctx
            , K.many <| Array.toList ctx.listAttrs
            ]
        )
        (Array.foldr
            (\( { selected, id }, content ) list ->
                (H.li
                    (K.fromMany
                        [ K.many
                            [ H.id id
                            , H.css <|
                                K.fromMany
                                    [ K.many <| Array.toList ctx.optionsCss
                                    , if selected then
                                        K.many <| Array.toList ctx.selectedOptionCss
                                      else
                                        K.zero
                                    ]
                            ]
                        , K.ifTrue selected (Aria.selected True)
                        , K.maybeMap (\handler -> H.onClick <| handler id) ctx.onOptionClick
                        , K.many <| Array.toList ctx.optionsAttrs
                        , if selected then
                            K.many <| Array.toList ctx.selectedOptionAttrs
                          else
                            K.zero
                        ]
                    )
                    [ content ]
                )
                    :: list
            )
            []
            ctx.options
        )


labelAttributes : Context msg -> KeywordList (H.Attribute msg)
labelAttributes ctx =
    K.group
        [ K.ifTrue (Context.hasDescriptionVisible ctx)
            (Aria.labeledBy
                [ Elements.id ctx.id Elements.Description
                ]
            )
        , K.ifFalse (Context.hasDescriptionVisible ctx) (Aria.label ctx.description)
        ]



-- Values --


iconSide : C.Px
iconSide =
    C.px 16


iconPaddingVertical : C.Px
iconPaddingVertical =
    C.px 2


iconPaddingHorizontal : C.Px
iconPaddingHorizontal =
    C.px 4


iconPadding : Context msg -> Maybe C.Px
iconPadding { iconCss, iconHtml } =
    if Array.isEmpty iconHtml || not (Array.isEmpty iconCss) then
        Nothing
    else
        Just <|
            C.px (iconSide.numericValue + iconPaddingHorizontal.numericValue)
