------------------
-- LBD DATABASE --
------------------

CREATE DATABASE IF NOT EXISTS lbd DEFAULT CHARSET = utf8;

USE lbd;


DROP TABLE IF EXISTS `material`
DROP TABLE IF EXISTS `fatiado_em`
DROP TABLE IF EXISTS `keywords`
DROP TABLE IF EXISTS `publicacao_keywords`
DROP TABLE IF EXISTS `producaoAcademica`;
DROP TABLE IF EXISTS `autor_artigo`
DROP TABLE IF EXISTS `artigo`
DROP TABLE IF EXISTS `pesquisador`;
DROP TABLE IF EXISTS `instituicao`;


-----------------------------------------------------------
-- instituicao (nomeInstituicao(nn), pais(nn), cidade) --
-----------------------------------------------------------
SET @saved_cs_client = @@character_set_client; SET character_set_client = utf8;
CREATE TABLE `instituicao` (
  `idInstituicao` int (5) NOT NULL AUTO_INCREMENT,
  `nomeInstituicao` varchar(100) NOT NULL,
  `pais` varchar(100) NOT NULL,
  `cidade` varchar(100) DEFAULT NULL,
  PRIMARY KEY (idInstituicao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; SET character_set_client = @saved_cs_client;


-----------------------------------------------------------------------------------------------------------------------------
-- pesquisador (idPesquisador(nn), nomePesquisador(nn), sobrenomePesquisador(nn), titulacao, ocupacao, nomeInstituição(nn)) 
------------------------------------------------------------------------------------------------------------------------------
SET @saved_cs_client = @@character_set_client; SET character_set_client = utf8;
CREATE TABLE `pesquisador` (
  `idPesquisador` int (5) NOT NULL AUTO_INCREMENT,
  `nomePesquisador` varchar(50) NOT NULL,
  `sobrenomePesquisador` varchar(100) NOT NULL,
  `titulacao` varchar(50) DEFAULT NULL,
  `ocupacao` varchar(50) DEFAULT NULL,
  `idInstituicao` int (5) DEFAULT NULL,
  PRIMARY KEY (idPesquisador),
  FOREIGN KEY (idInstituicao) REFERENCES instituicao(idInstituicao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; SET character_set_client = @saved_cs_client;

-----------------------------------------------------------------------------------------------------------------------------
-- producaoAcademica (idProdAcademica (nn), idPesquisador (nn), ano (nn), titulo (nn), resumo, urlProdAcademica, doi, grau (nn), orientador (nn), coorientador, instituicao (nn), financiadora)
-----------------------------------------------------------------------------------------------------------------------------
SET @saved_cs_client = @@character_set_client; SET character_set_client = utf8;
CREATE TABLE `producaoAcademica` (
  `idProdAcademica` int(5) NOT NULL AUTO_INCREMENT,
  `idPesquisador` int (5) NOT NULL,
  `ano` int(4) NOT NULL,
  `titulo` varchar(100) NOT NULL,
  `resumo` text(500) DEFAULT NULL,
  `urlProdAcademica` varchar(200) DEFAULT NULL,
  `doi` varchar(10) DEFAULT NULL,
  `grau` varchar(20) NOT NULL,
  `idOrientador` int (5) DEFAULT NULL,
  `idCoorientador` int (5) DEFAULT NULL,
  `idInstituicao` int (5) DEFAULT NULL,
  `financiadora`varchar(100) DEFAULT NULL,
  PRIMARY KEY (`idProdAcademica`),
  FOREIGN KEY (idPesquisador) REFERENCES pesquisador(idPesquisador),
  FOREIGN KEY (idOrientador) REFERENCES pesquisador(idPesquisador),
  FOREIGN KEY (idCoorientador) REFERENCES pesquisador(idPesquisador),
  FOREIGN KEY (idInstituicao) REFERENCES instituicao(idInstituicao),
  UNIQUE(titulo, ano)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; SET character_set_client = @saved_cs_client;


-----------------------------------------------------------------------------------------------------------------
-- artigo (idArtigo, ano (nn), titulo (nn), resumo, urlArtigo (nn), ISSN, evento/periodico (nn), financiadora) --
-----------------------------------------------------------------------------------------------------------------
SET @saved_cs_client = @@character_set_client; SET character_set_client = utf8;
CREATE TABLE `artigo` (
  `idArtigo` int(5) NOT NULL AUTO_INCREMENT,
  `ano` int(4) NOT NULL,
  `titulo` varchar(200) NOT NULL,
  `resumo` text(500) DEFAULT NULL,
  `urlArtigo` varchar(200) DEFAULT NULL,
  `doi` varchar(200) DEFAULT NULL,
  `evento_periodico` varchar(300) NOT NULL, 
  `financiadora`varchar(30) DEFAULT NULL,
  PRIMARY KEY (`idArtigo`),
  UNIQUE(titulo, ano)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; SET character_set_client = @saved_cs_client;


-----------------------------------------------------------------------------------------------------------------------------
-- autor_artigo (idArtigo, idPesquisador) 
-----------------------------------------------------------------------------------------------------------------------------
SET @saved_cs_client = @@character_set_client; SET character_set_client = utf8;
CREATE TABLE `autor_artigo` (
  `idArtigo` int(5) NOT NULL,
  `idPesquisador` int (5) NOT NULL,
  PRIMARY KEY (`idArtigo`, `idPesquisador`),
  FOREIGN KEY (idArtigo) REFERENCES artigo(idArtigo),
  FOREIGN KEY (idPesquisador) REFERENCES pesquisador(idPesquisador)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; SET character_set_client = @saved_cs_client;


-----------------------------------------------------------------------------------------------------------------------------
-- fatiado_em (idArtigo, idPesquisador) 
-----------------------------------------------------------------------------------------------------------------------------
SET @saved_cs_client = @@character_set_client; SET character_set_client = utf8;
CREATE TABLE `fatiado_em` (
  `idArtigo` int(5) NOT NULL,
  `idProdAcademica` int (5) NOT NULL,
  PRIMARY KEY (`idArtigo`, `idProdAcademica`),
  FOREIGN KEY (idArtigo) REFERENCES artigo(idArtigo),
  FOREIGN KEY (idProdAcademica) REFERENCES producaoAcademica(idProdAcademica)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; SET character_set_client = @saved_cs_client;



-----------------------------------------------------------------------------------------------------------------------------
-- keywords (idKeyword(nn), word(nn) )
-----------------------------------------------------------------------------------------------------------------------------
SET @saved_cs_client = @@character_set_client; SET character_set_client = utf8;
CREATE TABLE `keywords` (
  `idKeyword` int(5) NOT NULL AUTO_INCREMENT,
  `keyword` varchar(50) NOT NULL,
  PRIMARY KEY (`idKeyword`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; SET character_set_client = @saved_cs_client;


-----------------------------------------------------------------------------------------------------------------------------
-- artigo_keywords (idKeyword(nn), idArtigo, idProdAcademica)
-----------------------------------------------------------------------------------------------------------------------------
SET @saved_cs_client = @@character_set_client; SET character_set_client = utf8;
CREATE TABLE `artigo_keywords` (
  `idArtigo` int(5) NOT NULL,
  `idKeyword` int(5) NOT NULL,
  PRIMARY KEY (`idArtigo`, `idKeyword`),
  FOREIGN KEY (idArtigo) REFERENCES artigo(idArtigo),
  FOREIGN KEY (idKeyword) REFERENCES keywords(idKeyword)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; SET character_set_client = @saved_cs_client;


-----------------------------------------------------------------------------------------------------------------------------
-- material (idMaterial, idArtigo, idProdAcademica, tipoMaterial, urlMaterial)
-----------------------------------------------------------------------------------------------------------------------------
SET @saved_cs_client = @@character_set_client; SET character_set_client = utf8;
CREATE TABLE `material` (
  `idMaterial` int(5) NOT NULL AUTO_INCREMENT,
  `idArtigo` int(5) NOT NULL,
  `idProdAcademica` int(5) NOT NULL,
  `tipoMaterial` varchar(50) NOT NULL,
  `urlMaterial` varchar(50) NOT NULL,
  PRIMARY KEY (`idMaterial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; SET character_set_client = @saved_cs_client;

