module Main where

import System.IO (hFlush, stdout, stderr, hPutStrLn)
import System.Environment (getArgs)
import System.Exit (exitWith, ExitCode(..))
import qualified Data.ByteString as B
import Data.Text (Text, pack)
import Data.Text.Encoding (decodeUtf8)
import Control.Monad (forever, when)

-- Global error flags
data ErrorState = ErrorState { hadError :: Bool, hadRuntimeError :: Bool }

defaultErrorState :: ErrorState
defaultErrorState = ErrorState False False

main :: IO ()
main = do
  args <- getArgs
  if length args > 1
    then putStrLn "Usage: hlox [script]" >> exitWith (ExitFailure 64)
    else if length args == 1
      then runFile (head args)
      else runPrompt

runFile :: FilePath -> IO ()
runFile path = do
  bytes <- B.readFile path
  let source = decodeUtf8 bytes
  run source

runPrompt :: IO ()
runPrompt = forever $ do
  putStr "> "
  hFlush stdout
  line <- getLine
  if null line then return () else run (pack line)

run :: Text -> IO ()
run source = do
  putStrLn "Running the source code..."
