{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module View.AdicionaLivro where

import Foundation
import Yesod
import Data.Text
import Control.Applicative


getAdicLivR:: Handler Html
getAdicLivR = defaultLayout $ do
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
                <li class="active">
                    <a href="adicionarlivro">Adicionar Livro
                
                <li>
                    <a href="mostralivro">Livros cadastrados
                
                <li>
                    <a href=@{ListContR}>SAC
                
            
            <ul class="nav navbar-nav navbar-right">
                $maybe _ <- sess
                    <li> 
                        <form action=@{LogoutR} method=post>
                            <input type="submit" value="Logout">
                $nothing
                    -> redirect LoginR
    <main id="content">
        <div class="container">
            <header>
                <h2 class="text-center">
                    Adicionando livros
              
            <hr>
            <br>
            <div class="well">
                <form class="form-horizontal" action="/index.php/Controleadmin/livro" method="POST">
                    <div class="form-group">
                        <label for="titulo" class="col-sm-2 control-label">
                            Titulo:
                        
                        <div class="col-sm-10">
                            <input type="text" class="form-control" name="titulo" id="titulo" required>
                        
                    
                    <div class="form-group">
                        <label for="autor" class="col-sm-2 control-label">
                            Autor:
                        
                        <div class="col-sm-10">
                            <input type="text" class="form-control" name="autor" id="autor" required>
                        
                    
                    <div class="form-group">
                        <label for="lancamento" class="col-sm-2 control-label">
                            Lançamento:
                        
                        <div class="col-sm-10">
                            <input type="date" class="form-control" name="lancamento" id="lancamento" required>
                        
                    
                    <div class="form-group">
                        <label for="exemplar" class="col-sm-2 control-label">
                            Numero de exemplares:
                        
                        <div class="col-sm-10">
                            <input type="number" class="form-control" name="exemplar" id="exemplar" required>
                        
                    
                    <div class="form-group">
                        <label for="assunto" class="col-sm-2 control-label">
                            Assunto:
                        
                        <div class="col-sm-10">
                            <textarea class="form-control" rows="3" name="assunto" id="assunto" required>
                            
                        
                    
                    <div class="text-right">
                        <input class="btn btn-default" type="submit" value="Enviar">
                       
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