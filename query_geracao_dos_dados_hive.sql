--Importacao do arquivo de notas do ENEM do estado de Sao Paulo
CREATE EXTERNAL TABLE IF NOT EXISTS Notas_Enem(
        NO_MUNICIPIO_RESIDENCIA string,
        UF_RESIDENCIA string,
        IDADE int,
        TP_SEXO string,
        TP_ESCOLA string,
        NOTA_CN double,
        NOTA_CH double,
        NOTA_LC double,
        NOTA_MT double)
     COMMENT 'Notas do ENEM por municipio'
     ROW FORMAT DELIMITED
     FIELDS TERMINATED BY ';'
     STORED AS TEXTFILE
     LOCATION '/user/cloudera/curso/notas'
     ;
     drop table Regioes_SP

--Importacao do arquivo de regioes do estado de Sao Paulo
CREATE EXTERNAL TABLE IF NOT EXISTS Regioes_SP(
        Nome_UF string,
        Mesorregiao_Geografica int,
        Nome_Mesorregiao string,
        Microrregiao_Geografica int,
        Nome_Microrregiao string,
        Municipio int,
        Cod_Municipio_Completo int,
        Nome_Municipio string)
     COMMENT 'Regioes do estado de Sao Paulo'
     ROW FORMAT DELIMITED
     FIELDS TERMINATED BY ';'
     STORED AS TEXTFILE
     LOCATION '/user/cloudera/curso/regioes'
     ;     

drop table IDHMSP
--Importacao do arquivo de IDH das regioes do estado de Sao Paulo
CREATE EXTERNAL TABLE IF NOT EXISTS IDHMSP(
        Ano int,
        UF int,
        CodMun int,
        CodMun2 int,
        Nome_Municipio string,
        IDHM double)
    COMMENT 'IDH das Regioes do estado de Sao Paulo'
     ROW FORMAT DELIMITED
     FIELDS TERMINATED BY ';'
     STORED AS TEXTFILE
     LOCATION '/user/cloudera/curso/idh'
     ;          

--Normalizacao da base de Regioes     
DROP TABLE REGIOES_SP_RES
CREATE TABLE REGIOES_SP_RES as
    SELECT Nome_Mesorregiao, upper(TRANSLATE(upper(Nome_Municipio), "ÃÁÂÀÄ?ÊÉÈËÍÌÔÕÒÓÚÙÜÇ", "AAAAAEEEEEIIOOOOUUUC")) AS Nome_Municipio
        FROM regioes_sp

--Normalizacao da base de IDH   
drop table IDHMSP_RES
CREATE TABLE IDHMSP_RES as
    SELECT IDHM, upper(TRANSLATE(upper(Nome_Municipio), "ÃÁÂÀÄ?ÊÉÈËÍÌÔÕÒÓÚÙÜÇ", "AAAAAEEEEEIIOOOOUUUC")) AS Nome_Municipio
        FROM IDHMSP
        
select * from IDHMSP_RES
 
--Geracao da base para estudo
DROP TABLE BASE_ESTUDO        
CREATE TABLE BASE_ESTUDO AS
        SELECT A.*,(nota_cn+nota_ch+nota_lc+nota_mt)/4 as NOTA_FINAL,B.Nome_Mesorregiao AS MACRO_REGIAO,IDHM
            FROM Notas_Enem A LEFT OUTER JOIN REGIOES_SP_RES B
            ON
            A.NO_MUNICIPIO_RESIDENCIA = B.Nome_Municipio
            LEFT OUTER JOIN IDHMSP_RES C
            on
            A.NO_MUNICIPIO_RESIDENCIA = C.Nome_Municipio
            
select * from BASE_ESTUDO

--Sumarizacao da base de estudo
create table base_sumarizada as
    select idade, NO_MUNICIPIO_RESIDENCIA, MACRO_REGIAO, tp_sexo, tp_escola, count(*) as VOLUME
        from base_estudo
    group by idade, NO_MUNICIPIO_RESIDENCIA, MACRO_REGIAO, tp_sexo, tp_escola
    
select * from base_sumarizada


create table residencia_mean as
    select NO_MUNICIPIO_RESIDENCIA, avg(NOTA_FINAL) as MEAN_NOTA_FINAL
        from base_estudo
    group by NO_MUNICIPIO_RESIDENCIA
    
select * from residencia_mean


create table MACRO_REGIAO_mean as
    select MACRO_REGIAO, avg(NOTA_FINAL) as MEAN_NOTA_FINAL
        from base_estudo
    group by MACRO_REGIAO
    
select * from MACRO_REGIAO_mean

create table idade_mean as
    select idade, avg(NOTA_FINAL) as MEAN_NOTA_FINAL
        from base_estudo
    group by idade
    
select * from idade_mean

create table tp_escola_mean as
    select tp_escola, avg(NOTA_FINAL) as MEAN_NOTA_FINAL
        from base_estudo
    group by tp_escola
    
select * from tp_escola_mean

create table tp_sexo_mean as
    select tp_sexo, avg(NOTA_FINAL) as MEAN_NOTA_FINAL
        from base_estudo
    group by tp_sexo
    
select * from tp_sexo_mean