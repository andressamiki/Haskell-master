{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
module Handler.Livro where

import Foundation
import Yesod

formLivro :: Form Livro
formLivro = renderDivs $ Livro
    <$> areq textField  (fieldSettingsLabel MsgCadastroLivroNome)       Nothing
    <*> areq textField  (fieldSettingsLabel MsgCadastroLivroAutor)      Nothing
    <*> areq textField  (fieldSettingsLabel MsgCadastroLivroAssunto)    Nothing
    <*> areq (selectField cats)  (fieldSettingsLabel MsgCadastroLivroCategoria)  Nothing
    
cats = do
       entidades <- runDB $ selectList [] [Asc CategoriasNome] 
       optionsPairs $ fmap (\ent -> (categoriasNome $ entityVal ent, entityKey ent)) entidades

getLivR :: Handler Html
getLivR = do
    (widget,enctype)<- generateFormPost formLivro
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
    $(whamletFile "templates/cadLivro.hamlet")
    $(whamletFile "templates/footer.hamlet")
    
    
                    
    
postLivR :: Handler Html
postLivR = do
    ((resultado,_),_)<- runFormPost formLivro
    case resultado of
        FormSuccess liv -> do
            lid <- runDB $ insert liv
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
                $(whamletFile "templates/sucesLivro.hamlet")
                $(whamletFile "templates/footer.hamlet")
                    
        _ -> redirect LivR
        
getListLivR :: Handler Html
getListLivR = do
            listaL <- runDB $ selectList [] [Asc LivroNome]
            defaultLayout $ do
                sess <- lookupSession "_ID"
                setTitle "Livros Cadastrados / Biblioteca do Saber"
                
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
                $(whamletFile "templates/listLivro.hamlet")
                $(whamletFile "templates/footer.hamlet")

getListLivUserR :: Handler Html
getListLivUserR = do
            listaL <- runDB $ selectList [] [Asc LivroNome]
            
            defaultLayout $ do
                sess <- lookupSession "_ID"
                setTitle "Acervo / Biblioteca do Saber"
                
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
                $(whamletFile "templates/nav.hamlet")
                $(whamletFile "templates/listLivroUser.hamlet")
                $(whamletFile "templates/footer.hamlet")
                

getLivroUserR :: LivroId -> Handler Html
getLivroUserR lid = do
            livro <- runDB $ get404 lid 
            cat <- runDB $ get404 (livroCatid livro)
            defaultLayout  $ do
                sess <- lookupSession "_ID"
                setTitle "Livro / Biblioteca do Saber"
                
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
                $(whamletFile "templates/nav.hamlet")
                $(whamletFile "templates/perfilLivro.hamlet")
                $(whamletFile "templates/footer.hamlet")
                



getLivroR :: LivroId -> Handler Html
getLivroR lid = do
            livro <- runDB $ get404 lid 
            cat <- runDB $ get404 (livroCatid livro)
            defaultLayout  $ do
                sess <- lookupSession "_ID"
                setTitle "Livro / Biblioteca do Saber"
                
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
                $(whamletFile "templates/perfilLivro.hamlet")
                $(whamletFile "templates/footer.hamlet")
                


             
postLivroR :: LivroId -> Handler Html
postLivroR lid = do
     runDB $ delete lid
     redirect ListLivR
