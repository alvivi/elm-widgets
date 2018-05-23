module Widgets.Helpers.Array
    exposing
        ( first
        , getBounded
        , getCycling
        , last
        , singleton
        )

import Array exposing (Array)


first : Array a -> Maybe a
first =
    Array.get 0


getBounded : Int -> Array a -> Maybe a
getBounded index array =
    let
        maxIndex =
            Array.length array - 1
    in
        Array.get (max 0 (min index maxIndex)) array


getCycling : Int -> Array a -> Maybe a
getCycling index array =
    let
        length =
            Array.length array
    in
        if index < 0 then
            Array.get (length - 1) array
        else if index >= length then
            Array.get 0 array
        else
            Array.get index array


last : Array a -> Maybe a
last array =
    Array.get (Array.length array - 1) array


singleton : a -> Array a
singleton value =
    Array.push value Array.empty
