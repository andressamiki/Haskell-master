{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module View.Home where

import Foundation
import Yesod
import Data.Text
import Control.Applicative
import Database.Persist.Postgresql


getHomeR:: Handler Html
getHomeR = defaultLayout $ do
    sess <- lookupSession "_ID"
    setTitle "Home / Biblioteca do Saber"
    
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
                    <li>
                        <a href=@{LoginR}>Área Exclusiva
                    
            
    
    <main id="content" class="container">
        <section id="carousel-example-generic" class="carousel slide" data-ride="carousel">
            <ol class="carousel-indicators">
                <li data-target="#carousel-example-generic" data-slide-to="0" class="active">
                <li data-target="#carousel-example-generic" data-slide-to="1">
            
            <div class="carousel-inner" role="listbox">
                <article class="item active">
                    <img src=@{StaticR img_imagem5_jpg} alt="" class="img-responsive"/>
                    <div class="carousel-caption">
                        <h2>
                            Brasil é arte
                        
                        <h4>
                            Conheça mais sobre a literatura brasileira
                        
                        <br>
                    
                <article class="item">
                    <img src=@{StaticR img_imagem4_jpg} alt="" class="img-responsive"/>
                    <div class="carousel-caption">
                        <h2>
                            Cuidado com o vencimento
                        
                        <h4>
                            Não esqueça das datas de devolver o livro e atualizar sua conta
                        
                        <br>
                    
                <a class="left carousel-control" href="#carousel-example-generic" role="button" data-slide="prev">
                    <span class="glyphicon glyphicon-chevron-left" aria-hidden="true">
                    <span class="sr-only">Previous
          
                <a class="right carousel-control" href="#carousel-example-generic" role="button" data-slide="next">
                    <span class="glyphicon glyphicon-chevron-right" aria-hidden="true">
                    <span class="sr-only">Next
          
        <section id="services">
            <br>
            <br>
            <header>
                <h3 class="text-center">
                    Serviços oferecidos para os usuários
                
            <div class="row">
                <div class="col-md-4 col-xs-6">
                    <hr>
                    <h4>
                        Consulta no acervo
                    
                    <p>
                        Os usuário cadastrados podem pesquisar pela base de dados da biblioteca
                        o livro que deseja.
                    
                
                <div class="col-md-4 col-xs-6">
                    <hr>
                    <h4>
                        Reserva de obras
                    
                    <p>
                        Todas as obras poderão ser reservadas pessoalmente por alunos e professores
                        da nossa instituição.
                    
                
                <div class="col-md-4 col-xs-6">
                    <hr>
                    <h4>
                        Central de informações
                    
                    <p>
                        A biblioteca do saber oferece uma central de informação em sua biblioteca
                        fisica.
                
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