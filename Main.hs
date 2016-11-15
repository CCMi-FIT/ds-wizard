{-# LANGUAGE OverloadedStrings #-}

module Main where

import Prelude
import Data.Maybe (isNothing, catMaybes)

import FormEngine.JQuery (ready, errorIO)
import Transform.Questionnaire as Questionnaire
import FormEngine.FormElement.FormElement as Element
import Form

main :: IO ()
main = ready $ do
  let tabMaybes = map (Element.makeChapter Nothing) Questionnaire.formItems
  errorIO . show $ tabMaybes {- DEBUG -}
  if any isNothing tabMaybes then do
    errorIO "Error generating tabs"
    return ()
  else do
    let tabs = catMaybes tabMaybes
    generateForm tabs
