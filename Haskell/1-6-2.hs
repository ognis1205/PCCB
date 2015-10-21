-- * PCCB 1-6-2
-- |

import Data.List

getArgs :: IO [(Int, Int)]
getArgs = do arg <- getLine
             return [((read l::Int), (read r::Int)) | (l:r:_) <- map (delimit isDelimiter) (words arg)]

delimit :: (Char -> Bool) -> String -> [String]
delimit cnd s = case dropWhile cnd s of
                  "" -> []
                  s' -> w : delimit cnd s''
                        where (w, s'') = break cnd s'

isDelimiter :: Char -> Bool
isDelimiter c = case find (==c) delimiters of
                  Just d  -> True
                  Nothing -> False

delimiters :: [Char]
delimiters = ","

putAnsLn :: (Show a) => a -> IO ()
putAnsLn ans = putStrLn (show ans)

main = do as <- getArgs
          putAnsLn as
