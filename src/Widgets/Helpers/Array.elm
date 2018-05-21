module Widgets.Helpers.Array exposing (getBounded, singleton)

import Array exposing (Array)


getBounded : Int -> Array a -> Maybe a
getBounded index array =
    let
        maxIndex =
            Array.length array - 1
    in
        Array.get (max 0 (min index maxIndex)) array


singleton : a -> Array a
singleton value =
    Array.push value Array.empty
