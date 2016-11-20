{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE ViewPatterns         #-}
{-# LANGUAGE QuasiQuotes       #-}
module Application where

import Foundation
import Yesod
import Handler.Usuario
import Handler.Contatos
import Handler.Livro
import Handler.Categorias
import View.Home
import View.Institucional
import View.Duvidas
import View.AdicionaLivro
------------------
mkYesodDispatch "App" resourcesApp




    
    
    