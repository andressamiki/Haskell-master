{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module View.Institucional where

import Foundation
import Yesod
import Data.Text
import Control.Applicative

getInstR:: Handler Html
getInstR = defaultLayout $ do
    setTitle "Institucional"
    
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
                <a href="home"><img src=@{StaticR img_logo_jpg} alt="Logo da biblioteca do saber" class="img-responsive">
        
    

    <nav class="navbar navbar-inverse">
        <div class="container">
            <ul class="nav navbar-nav">
                <li>
                    <a href=@{HomeR}>Home
                
                <li  class="active">
                    <a href=@{InstR}>Institucional
                
                <li>
                    <a href=@{DuvR}>Dúvidas Frequentes
                
                <li>
                    <a href=@{FaleR}>Fale conosco
                
            
            <ul class="nav navbar-nav navbar-right">
                <li>
                    <a href="login">Área exclusiva
    <main id="content">
        <div class="container">
            <header>
                <h2 class="text-center">
                    Institucional
                
            
            <hr>
            <h3>
                Apresentação
            
            <p>
                A Biblioteca do saber possui um acervo com livros, periódicos, fotografias
                e materiais multimídia. Recebe pessoas e realiza empréstimos diariamente.
                Oferece atendimento especial às crianças e aos deficientes visuais, além
                de proporcionar o acesso da população à leitura.
            
            <p>
                Consciente de seu importante papel de disseminador da informação, a Biblioteca
                do saber serve também de centro de pesquisa a todos os segmentos da sociedade
                que necessitam do insumo informacional para seu desenvolvimento.Neste sentido,
                seus acervos são abertos, a qualquer pessoa, para consulta fisica. Bem
                como seus espaços de estudo podem ser utilizados por quaisquer interessados.
            
            <br>
            <h3>
                Objetivo da Política Geral
            
            <p>
                Gerar condições favoráveis para o desenvolvimento dos acervos informacionais
                como suporte às atividades de ensino, pesquisa e extensão e o incorporamento
                de novas tecnologias para a implementação ou reestruturação dos serviços
                de informação.
           
                
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
