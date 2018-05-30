module ListHelpers exposing (groupWhile, uncons)

import List exposing (head)

-- kind of inspired by
-- https://github.com/elm-community/list-extra/blob/36b63fc2ab1b1b602a30dbc71e9b829a0f325e21/src/List/Extra.elm#L1302-L1328
groupWhile : (a -> a -> Bool) -> List a -> List (List a)
groupWhile keepGrouping xs =
  let
    prepend x (cur, rest) =
      case head cur of
        Nothing -> ([x], rest)
        Just y ->
          if keepGrouping x y then
            (x :: cur, rest)
          else
            ([x], cur :: rest)
  in
    case List.foldr prepend ([], []) xs of
      ([], res) -> res
      (cur, res) -> cur :: res

-- exactly like
-- https://github.com/elm-community/list-extra/blob/36b63fc2ab1b1b602a30dbc71e9b829a0f325e21/src/List/Extra.elm#L285-L298
uncons : List a -> Maybe (a, List a)
uncons list =
  case list of
    [] -> Nothing
    x :: xs -> Just ( x, xs )
