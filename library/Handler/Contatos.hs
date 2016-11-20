{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Handler.Contatos where

import Foundation
import Yesod


formCont :: Form Contatos
formCont = renderDivs $ Contatos
    <$> areq textField  "Nome: "     Nothing
    <*> areq textField  "Email: "    Nothing
    <*> areq textField   "Mensagem: " Nothing

getContR:: Handler Html
getContR = do
    (widget,enctype)<- generateFormPost formCont
    defaultLayout $ do
    setTitle "Fale Conosco / Biblioteca do Saber"
    
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
                <li>
                    <a href="login">Área exclusiva
                    
    <main id="content">
        <div class="container">
            <header>
                <h2 class="text-center">
                    Fale conosco
                
            
            <hr>
            <br>
            <div class="well">
                <form method=post action=@{ContR} enctype=#{enctype}>
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


postContR :: Handler Html
postContR = do
    ((resultado,_),_)<- runFormPost formCont
    case resultado of
        FormSuccess cont -> do
            uid <- runDB $ insert cont
            defaultLayout $ do
            
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
                                
                    <main id="content" class="container">
                        
                        <h2>Obrigado #{contatosNome cont} pelo Contato em breve retornaremos!
                                
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
        _ -> redirect ContR