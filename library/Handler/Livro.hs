{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
module Handler.Livro where

import Foundation
import Yesod
import Yesod.Static
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Applicative
import Data.Text
import Database.Persist.Postgresql

formLivro :: Form Livro
formLivro = renderDivs $ Livro
    <$> areq textField  "Nome: "       Nothing
    <*> areq textField  "Autor: "      Nothing
    <*> areq textField  "Assunto: "    Nothing
    <*> areq (selectField cats)  "Categoria: "  Nothing
    
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
                <h2 class="text-center">
                    Cadastro de Livros
                
            
            <hr>
            <br>
            <div class="well">
                <form method=post action=@{LivR} enctype=#{enctype}>
                    ^{widget}
                    <input type="submit" value="Enviar">
                     
                            
    
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
                                
                                <li>
                                    <a href=@{ContR}>Fale conosco
                                    
                            <ul class="nav navbar-nav navbar-right">
                                $maybe _ <- sess
                                    <li> 
                                        <form action=@{LogoutR} method=post>
                                            <input type="submit" value="Logout">
                                $nothing
                                    <li> <a href=@{LoginR}>Área Exclusiva
                                
                    <main id="content" class="container">
                        
                        <h2>Obrigado!
                                
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
        _ -> redirect LivR
        
getListLivR :: Handler Html
getListLivR = do
             listaL <- runDB $ selectList [] [Asc LivroNome]
             defaultLayout $ [whamlet|
                 <h1> Livros cadastrados:
                 $forall Entity lid liv <- listaL
                     #{livroNome liv} 
             |]