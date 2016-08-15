module Lib (
  str
) where

import Language.Haskell.TH
import Language.Haskell.TH.Quote

qqUndef :: QuasiQuoter
qqUndef = QuasiQuoter {
  quoteExp = error "quoteExp undefined",
  quotePat = error "quotePat undefined",
  quoteType = error "quoteType undefined",
  quoteDec = error "quoteDec undefined"
}

str :: QuasiQuoter
str = qqUndef { quoteExp = stringE }
