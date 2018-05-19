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
import Html.Styled as H exposing (Html)
import Html.Styled.Attributes as H
import Html.Styled.Attributes.Aria as Aria
import Html.Styled.Attributes.Aria.Popup as Popup
import Html.Styled.Attributes.Aria.Role as Role
import KeywordList as K exposing (KeywordList)
import Widgets.Form as Form
import Widgets.Form.Attributes as Form
import Widgets.Form.Elements as Form
import Widgets.ListBox.Attributes exposing (Attribute)
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
                , K.one <| H.css <| Array.toList ctx.wrapperCss
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
        [ Form.html Form.control
            (K.fromMany
                [ K.many
                    [ Aria.hasPopup Popup.Dialog
                    , H.id <| Elements.id ctx.id Elements.Button
                    ]
                , K.many <| Array.toList ctx.buttonAttrs
                , labelAttributes ctx
                ]
            )
        , Form.css Form.control (Array.toList ctx.buttonCss)
        ]
        (if Array.isEmpty ctx.buttonHtml then
            [ H.text ctx.description ]
         else
            Array.toList ctx.buttonHtml
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
                        [ K.one <| C.paddingLeft C.zero
                        , K.many <| Array.toList ctx.listCss
                        ]
                    )
                ]
            , K.many <| Array.toList ctx.listAttrs
            , labelAttributes ctx
            ]
        )
        (Array.foldr
            (\option list ->
                (H.li [ H.css [ C.listStyleType C.none ] ] [ option ]) :: list
            )
            []
            ctx.optionsHtml
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
