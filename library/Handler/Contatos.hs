{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
module Handler.Contatos where

import Foundation
import Yesod
 
formCont :: Form Contatos
formCont = renderDivs $ Contatos
    <$> areq textField  (fieldSettingsLabel MsgContatoNome) Nothing
    <*> areq emailField (fieldSettingsLabel MsgContatoEmail)    Nothing
    <*> areq textField  (fieldSettingsLabel MsgContatoMensagem) Nothing

getContR:: Handler Html
getContR = do
    (widget,enctype)<- generateFormPost formCont
    defaultLayout $ do
    sess <- lookupSession "_ID"
    setTitle "Fale Conosco / Biblioteca do Saber"
    
    toWidgetHead[hamlet|
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
    |]
    -- Adiciona o bootstrapp via CDN
    addStylesheetRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
    
    -- Adiciona o jquery via CDN
    addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"
    -- Adiciona o js via CDN
    addScriptRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
    
    addStylesheet $ StaticR css_principal_css
    $(whamletFile "templates/nav.hamlet")
    $(whamletFile "templates/contato.hamlet")
    $(whamletFile "templates/footer.hamlet")

postContR :: Handler Html
postContR = do
    ((resultado,_),_)<- runFormPost formCont
    case resultado of
        FormSuccess cont -> do
            uid <- runDB $ insert cont
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
                $(whamletFile "templates/nav.hamlet")
                $(whamletFile "templates/sucesCont.hamlet")
                $(whamletFile "templates/footer.hamlet")        
                
        _ -> redirect ContR
        
        
getListContR:: Handler Html
getListContR = do
    contatos <- runDB $ selectList [] [Asc ContatosNome]
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
    $(whamletFile "templates/listCont.hamlet")
    $(whamletFile "templates/footer.hamlet")
    
        
postDelContR :: ContatosId -> Handler Html
postDelContR uid = do 
                runDB $ delete uid
                redirect ListContR