{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Handler.Usuario where

import Foundation
import Yesod
import Data.Text
import Control.Applicative
import Database.Persist.Postgresql

formUser :: Form Usuario
formUser = renderDivs $ Usuario
    <$> areq emailField    "E-mail"  Nothing
    <*> areq passwordField "Senha"   Nothing

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
        
        [whamlet|
        
        <div class="container">
            <header id="header" class="row">
                <div class="col-md-4 col-xs-6">
                    <a href=@{HomeR}><img src=@{StaticR img_logo_jpg} alt="Logo da biblioteca do saber" class="img-responsive">
            
        
             
        <nav class="navbar navbar-inverse">
            <div class="container">
                <ul class="nav navbar-nav">
                    <li>
                        <a href=@{HomeR}>Home
                    
                    <li>
                        <a href=@{InstR}>Institucional
                    
                    <li>
                        <a href=@{DuvR}>Dúvidas Frequentes
                    
                    <li class="active">
                        <a href=@{ContR}>Fale conosco
                    
                
                <ul class="nav navbar-nav navbar-right">
                    $maybe _ <- sess
                        <li> 
                            <form action=@{LogoutR} method=post>
                                <input type="submit" value="Logout">
                    $nothing
                        <li>
                            <a href=@{LoginR}>Área Exclusiva
                        
        <main id="content">
            <div class="container">
                <header>
                    <h2 class="text-center">Área administrativa
                    
                
                <hr>
                <br>
                <div class="well">
                    <form action=@{LoginR} method=post enctype=#{enctype}>
                        ^{widget}
                        <input type="submit" value="Logar">
                         
                                
        
        <footer>
            <section id="info" class="destaque">
                <div class="container">
                    <div class="row">
                        <br>
                        <div class="col-md-5">
                            <h6>
                                Biblioteca do Saber
                            
                            <h6>
                                Praça da Água, 2 - 13 3355-1000 | Lg. Maria de Lurdes, 24 - 13 3381-4890
                            
                            <h6>
                                Segunda a Sexta das 10h às 17h30 com permanência até as 18h.
                            
                        
                    
                
                <br>
            
            <h6 class="text-center">
                ©2015 Copyright Andressa - Todos os direitos reservados.
            |]    
    
-- ROTA DE AUTENTICACAO
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
                    redirect AdicLivR
        _ -> redirect HomeR
        
postLogoutR :: Handler Html
postLogoutR = do
    deleteSession "_ID"
    redirect HomeR