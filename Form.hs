{-# LANGUAGE OverloadedStrings #-}

module Form where

import           Prelude
import           FormEngine.JQuery as JQ

import           FormEngine.FormItem
import           FormEngine.FormElement.FormElement as E
import           FormEngine.FormElement.Identifiers
import           FormEngine.FormElement.Rendering
import           FormEngine.FormElement.Tabs
import           FormEngine.FormContext

generateForm :: [FormElement] -> IO ()
generateForm tabs = do
  formJq <- select "#form"
  let allTabs = aboutTab : tabs
  _ <- renderTabGroup allTabs (aboutTabPaneJq : tabsContentsJq tabs) formJq
  _ <- selectTab 0 allTabs
  fireClicks

  where
    tabsContentsJq :: [FormElement] -> [IO JQuery]
    tabsContentsJq = map makePaneJq
      where
        makePaneJq :: FormElement -> IO JQuery
        makePaneJq tab =
          select "<div class='main-pane'>"
          >>= makeFormSubPane
          >>= makeDescSubPane
          where
            makeFormSubPane :: JQuery -> IO JQuery
            makeFormSubPane jq =
              appendT "<div class='form-subpane'>" jq
              >>= inside
              >>= foldElements (E.children tab) formContext
                    ElemBehaviour { focusAction = noAction, blurAction = noAction }
              >>= JQ.parent
              where
                formContext = FormContext
                  { allElems = tabs
                  , validImg = "<img class='validity-flag' src='img/valid.png'/>"
                  , invalidImg = "<img class='validity-flag' src='img/invalid.png'/>"
                  }
            makeDescSubPane :: JQuery -> IO JQuery
            makeDescSubPane jq =
              appendT "<div class='desc-subpane'>" jq >>=
              setAttrInside "id" (descSubpaneId tab) >>=
              inside
              >>= appendT "<p class='long-desc'>" >>=
              setAttrInside "id" (descSubpaneParagraphId tab)
              >>= inside
              >>= appendT "<img src='img/hint-icon.png' style='margin-right: 5px;'>"
              >>= appendT "<span/>"
              >>= JQ.parent
              >>= JQ.parent
    fireClicks :: IO ()
    fireClicks = do
      _ <- select "input:checked" >>= click >>= click
      _ <- select "input" >>= mouseleave
      _ <- select "textarea" >>= mouseleave
      _ <- select "select" >>= mouseleave
      return ()

aboutTab :: FormElement
aboutTab = ChapterElem
  { chfi = Chapter
    { chDescriptor = FIDescriptor
      { iLabel = Just "About"
      , iNumbering = Numbering [1000] 0
      , iIdent = Nothing
      , iTags = []
      , iShortDescription = Nothing
      , iLongDescription = Nothing
      , iLink = Nothing
      , iRules = []
      , iMandatory = False
      }
    , chItems = []
    }
  , chElements = []
  , visited = False
  }

aboutTabPaneJq :: IO JQuery
aboutTabPaneJq = select
                   "\
\  <div>\
\    <p>\
\      Questionnaire generated from precompiler JSON of <a href=\"https://github.com/CCMi-FIT/ds-km\" target=\"_blank\">Data Stewardship Knowledge Model</a>.\
\    </p>\
\  </div>\
\ "
