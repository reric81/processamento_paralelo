#Subindo Base
ENEM_SP <- read.csv("C:/Users/thoma/Desktop/Processamento_Paralelo/base_analitica.csv", header = TRUE, sep = ";", dec=".")

#Gerando Subset
ENEM_SP2<-subset(ENEM_SP,ENEM_SP[11]==c("Bauru", "Campinas","Litoral Sul Paulista", "Metropolitana de SÃ£o Paulo", "Macro Metropolitana Paulista"))

#Analisando informações basicas da Base
dim(ENEM_SP2)
ls()
names(ENEM_SP2)

#Criando Variáveis a partir do Data Frame

macro_regiao <- ENEM_SP2$macro_regiao
length(macro_regiao)
table(macro_regiao)

nota_cn<- as.numeric(as.character(ENEM_SP2$nota_cn))
length(nota_cn)
summary(nota_cn)

nota_ch<- as.numeric(as.character(ENEM_SP2$nota_ch))
length(nota_ch)
summary(nota_cn)

nota_lc<- as.numeric(as.character(ENEM_SP2$nota_lc))
length(nota_lc)
summary(nota_cn)

nota_mt<- as.numeric(as.character(ENEM_SP2$nota_mt))
length(nota_mt)
summary(nota_cn)

#Criando a média geral
nota_total = (nota_cn+nota_ch+nota_lc+nota_mt)/4
length(nota_total)
summary(nota_total)


mean(nota_total, na.rm=TRUE) # returns 2
median(nota_total, na.rm=TRUE)

# Média por MesoRegião
tapply(nota_total, macro_regiao, mean, na.rm = TRUE)

#Execução do Teste de Tukey
a1 <- aov(nota_total~ macro_regiao)
posthoc <- TukeyHSD(x=a1, 'macro_regiao', conf.level=0.95)
posthoc

plot(posthoc)

