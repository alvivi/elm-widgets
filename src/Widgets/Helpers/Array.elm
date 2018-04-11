module Widgets.Helpers.Array exposing (singleton)

import Array exposing (Array)


singleton : a -> Array a
singleton value =
    Array.push value Array.empty
