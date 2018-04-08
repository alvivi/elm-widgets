module Widgets.Helpers.KeywordList exposing (applyJoin)

import KeywordList as K exposing (KeywordList)


applyJoin : (a -> KeywordList b) -> (a -> KeywordList b) -> a -> KeywordList b
applyJoin f q a =
    K.group [ f a, q a ]
