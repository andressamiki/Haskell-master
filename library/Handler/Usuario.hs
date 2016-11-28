{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE QuasiQuotes       #-}
module Handler.Usuario where

import Foundation
import Yesod
import Data.Text

formUser :: Form Usuario
formUser = renderDivs $ Usuario
    <$> areq emailField    (fieldSettingsLabel MsgLoginEmail)  Nothing
    <*> areq passwordField (fieldSettingsLabel MsgLoginSenha)   Nothing

getLoginR :: Handler Html
getLoginR = do
    (widget,enctype)<- generateFormPost formUser
    defaultLayout $ do
        sess <- lookupSession "_ID"
        setTitle "Login / Biblioteca do Saber"
        
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
        $(whamletFile "templates/login.hamlet")
        $(whamletFile "templates/footer.hamlet")
        
        
        
        
postLoginR :: Handler Html
postLoginR = do
    ((resultado,_),_)<- runFormPost formUser
    case resultado of
        FormSuccess user -> do
            usuario <- runDB $ selectFirst [UsuarioEmail ==. (usuarioEmail user),
                                    UsuarioSenha ==. (usuarioSenha user)] []
            case usuario of
                Nothing -> redirect LoginR
                Just (Entity uid _) -> do
                    setSession "_ID" (pack $ show uid)
                    redirect LivR
        _ -> redirect HomeR


getListUserR:: Handler Html
getListUserR = do
    usuario <- runDB $ selectList [] [Asc UsuarioEmail]
    defaultLayout $ do
    sess <- lookupSession "_ID"
    setTitle "Administradores / Biblioteca do Saber"
    
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
    $(whamletFile "templates/listUser.hamlet")
    $(whamletFile "templates/footer.hamlet")
        
postLogoutR :: Handler Html
postLogoutR = do
    deleteSession "_ID"
    redirect HomeR
    
    
getCadUserR :: Handler Html
getCadUserR = do
    (widget,enctype)<- generateFormPost formUser
    defaultLayout $ do
    sess <- lookupSession "_ID"
    setTitle "Cadastrar Usuarios / Biblioteca do Saber"
    
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
    $(whamletFile "templates/cadUser.hamlet")
    $(whamletFile "templates/footer.hamlet")
    
postCadUserR :: Handler Html
postCadUserR = do
    ((resultado,_),_)<- runFormPost formUser
    case resultado of
        FormSuccess user -> do
            unicoEmail <- runDB $ getBy $ UniqueEmail (usuarioEmail user)
            case unicoEmail of
                Just _ -> redirect CadUserR
                Nothing -> do
                    uid <- runDB $ insert user
                    defaultLayout $ do
                
                    sess <- lookupSession "_ID"
                    setTitle "Sucesso Usuario / Biblioteca do Saber"
                    
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
                    $(whamletFile "templates/sucesUser.hamlet")
                    $(whamletFile "templates/footer.hamlet")
                        
        _ -> redirect LivR
            
