{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
module Handler.Categorias where
import Yesod
import Foundation

formCat:: Form Categorias
formCat = renderDivs $ Categorias <$>
            areq textField "Nome" Nothing

getCatR :: Handler Html
getCatR = do
    (widget,enctype)<- generateFormPost formCat
    defaultLayout $ do
    sess <- lookupSession "_ID"
    setTitle "Adicionar Livros / Biblioteca do Saber"
    
    toWidgetHead[hamlet|
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
    |]
    -- Adiciona o bootstrap via CDN
    addStylesheetRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
    
    -- Adiciona o jquery via CDN
    addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"
    -- Adiciona o js via CDN
    addScriptRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
    
    addStylesheet $ StaticR css_principal_css
    $(whamletFile "templates/navAdmin.hamlet")
    $(whamletFile "templates/cadCat.hamlet")
    $(whamletFile "templates/footer.hamlet")
            
postCatR :: Handler Html
postCatR = do
                ((result, _), _) <- runFormPost formCat
                case result of
                    FormSuccess cat -> do
                        runDB $ insert cat
                        defaultLayout $ do
                            sess <- lookupSession "_ID"
                            setTitle "Contatos Sucesso / Biblioteca do Saber"
                            
                            toWidgetHead[hamlet|
                                <meta http-equiv="X-UA-Compatible" content="IE=edge">
                                <meta name="viewport" content="width=device-width, initial-scale=1">
                            |]
                            -- Adiciona o bootstrap via CDN
                            addStylesheetRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
                            
                            -- Adiciona o jquery via CDN
                            addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"
                            -- Adiciona o js via CDN
                            addScriptRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
                            
                            addStylesheet $ StaticR css_principal_css
                            $(whamletFile "templates/navAdmin.hamlet")
                            $(whamletFile "templates/sucesCat.hamlet")
                            $(whamletFile "templates/footer.hamlet")
                    _ -> redirect CatR
                    
                    
getListCatR :: Handler Html
getListCatR = do
            listaL <- runDB $ selectList [] [Asc CategoriasNome]
            defaultLayout $ do
                sess <- lookupSession "_ID"
                setTitle "Categorias Cadastrados / Biblioteca do Saber"
                
                toWidgetHead[hamlet|
                    <meta http-equiv="X-UA-Compatible" content="IE=edge">
                    <meta name="viewport" content="width=device-width, initial-scale=1">
                |]
                -- Adiciona o bootstrap via CDN
                addStylesheetRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
                
                -- Adiciona o jquery via CDN
                addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"
                -- Adiciona o js via CDN
                addScriptRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
                addStylesheet $ StaticR css_principal_css
                $(whamletFile "templates/navAdmin.hamlet")
                $(whamletFile "templates/listCat.hamlet")
                $(whamletFile "templates/footer.hamlet")
                
postDelCatR :: CategoriasId -> Handler Html
postDelCatR cid = do
     runDB $ delete cid
     redirect ListCatR