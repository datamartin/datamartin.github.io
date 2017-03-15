## Kvantitatiivsed mudelid käitumisteadustes
## Praktikum nr 3: lineaarne regressioon
## 18.03.2016

# paarisregressiooni mudel
pisa.mudel1  <- lm(PVSCIE ~ GENSCIE, data=pisa)

# mudeli väljund
summary(pisa.mudel1)


# mitmese regressiooni mudel
pisa.mudel2 <- lm(PVSCIE ~ GENSCIE + INTSCIE + INSTSCIE, data=pisa)

# mudeli väljund
summary(pisa.mudel2)

# standardiseeritud regressioonikordajate arvutamise funktsioon
# moodulist QuantPsyc, mis tuleb enne installida ja laadida
install.packages("QuantPsyc")
library(QuantPsyc)
lm.beta(pisa.mudel2)#mitme standardhalbe v~orra muutub s~oltuv muutuja, kui prediktor muutub uhe standardhalbe v~orra (ja
#ulejaanud prediktorid jaavad samaks).

# mudeli parameetrite 95%-usalduspiirid
confint(pisa.mudel2)


# hierarhiliste mudelite võrdlemine
anova(pisa.mudel1, pisa.mudel2)


# mudeli standardiseeritud jäägid
mud2.standardized.residuals <- rstandard(pisa.mudel2)

# kui palju on suuri jääke
sum(abs(mud2.standardized.residuals) > 2)

# kas suuri jääke on rohkem kui 5% andmestikust
nrow(pisa) * 0.05

# kui palju on eriti suuri jääke
sum(abs(mud2.standardized.residuals) > 3)

# andmeread, mille puhul jäägid eriti suured
pisa[abs(mud2.standardized.residuals) > 3, ]

# kõige suurem Cooki kaugus
max(cooks.distance(pisa.mudel2))

# andmeread, mille puhul Cooki kaugused üle kriitilise piiri
pisa[cooks.distance(pisa.mudel2) > 1,]


# prediktorite-vahelised korrelatsioonid
# multikollineaarsuse hindamiseks
cor(pisa[,c("GENSCIE", "INTSCIE", "INSTSCIE")])

# multikollineaarsuse hindamiseks kasutatavad varieeruvusindeksid
# lisamooduli car funktsiooni vif abil
install.packages("car")
library(car)
vif(pisa.mudel2)

# hajuvusdiagramm heteroskedaktilisuse hindamiseks
plot(fitted.values(pisa.mudel2), resid(pisa.mudel2))

# jääkide histogramm
hist(mud2.standardized.residuals)

# kvantiil-kvantiil diagramm jääkide normaaljaotuse hindamiseks
qqnorm(mud2.standardized.residuals)
qqline(mud2.standardized.residuals, col="red", lwd=2)

# Durbin-Watsoni test jääkide sõltumatuse hindamiseks
# lisamoodulist car
dwt(pisa.mudel2)


##ÜLESANDED

# 1. Tehke paarisregressiooni mudel, mis ennustab matemaatika alatesti skoori (tunnus PVMATH) lugemise
# skoori kaudu (PVREAD). Kas seos on oluline? Kui suure osa matemaatika testi skooride
# hajuvusest lugemise testi skoor ära seletab? Mitme punkti võrra muutub matemaatika skoor kui
# lugemise skoor muutub ühe punkti võrra? Arvutage ka standardiseeritud regressioonikordaja ja
# mudeli parameetrite usalduspiirid. Mida nende põhjal järeldada saab?
mudel1 <- lm(PVMATH ~ PVREAD, data=pisa)
summary(mudel1)

# 2. Proovime mudeleid koostada väiksemas valimis. Teeme kõigepealt tabeli nimega pisa2, millesse
# valime tabelist pisa juhuslikult 400 vastajat. St valim läheb umbes 10 korda väiksemaks. Sellise
# tabeli saame alloleva koodireaga:
pisa2 <- pisa[sample(1:nrow(pisa), 400), ]
# (Funktsiooniga sample genereerime 400 juhuslikku arvu vahemikus 1-st kuni tabeli pisa ridade
# arvuni. Pannes selle tabeli nime järele nurksulgude sisse ja selle järele koma, valitakse tabelist
# nende järjekorranumbritega read.)

# A. Koostage tabelit pisa2 kasutades mudel, milles sõltuvaks tunnuseks on matemaatika testi
# skoor (PVMATH) ja prediktoriteks samad tunnused, millega ülal ennustasime loodusteaduste
# testi skoori: teaduse oluliseks pidamine (GENSCIE), huvi teaduse vastu (INTSCIE) ja motivatsioon
# loodusteadusi õppida (INSTSCIE).
mudel2 <- lm(PVMATH ~ GENSCIE + INTSCIE + INSTSCIE, data=pisa2)
summary(mudel2)
# B. Arvutage ka standardiseeritud kordajad ja mudeli parameetrite 95\%-usalduspiird.
#Standardiseeritud kordajad - ehk beeta kordajad - mitme SD võrra muutub sõltuv muutuja, kui prediktor muutub ühe SD võrra
library(QuantPsyc)
lm.beta(mudel2)
#Mudeli parameetire usalduspiirid:
confint(mudel2)

# C. Kui suure osa sõltuva tunnuse hajuvusest mudel ära seletab? Kas kõik prediktorid on olulised?
# Kui mõni prediktor pole oluline, tehke uus mudel, millest see välja jäetud on?
mudel3 <- lm(PVMATH ~ GENSCIE + INSTSCIE, data=pisa2)
summary(mudel3)

# D. Arvutage uue mudeli standardiseeritud jäägid (või vana mudeli omad, kui kõik prediktorid on
# olulised). Kui suur on jääkide osakaal, mille absoluutväärtus on suurem kui 2? Kas neid on
# liiga palju?
m_residuals <- rstandard(mudel3)
#jääke üle kahe
sum(abs(m_residuals ) > 2)# 17 kas seda on rohkem kui 5%
nrow(pisa2) * 0.05# 5 % on 20; 17 on sellest väiksem
sum(abs(m_residuals) > 3)# standardiseeritud jäägid absoluutväärtusega üle 3-e

# E. Arvutage mudeli kohta Cooki kaugused. Kas esineb liiga suure mõjukuseastmega vaatlusi?
max(cooks.distance(mudel3))
pisa[cooks.distance(mudel3) > 1,]# kui juhtumeid oleks, saaks ühest suuremad nii kätte

# F. Kas mudelil on probleeme multikollineaarsuse, heteroskedaktilisuse, jääkide jaotuse või jääkide
# sõltumatusega?
#multikolineaarsus - ehk olukord, kui mudeli prediktorid on omavahel liiga tugevalt korreleeritud.
cor(pisa2[,c("PVMATH", "GENSCIE", "INSTSCIE")])
library(car)
vif(mudel3)#Indeksi vaartused ule 10-e annavad marku probleemsest multikollineaarsusest.

#heteroskedaktilsus - heteroskedaktilisus ehk olukord kui mudeli jaakide hajuvus on prediktorite eri tasemetel liiga erinev.
plot(fitted.values(mudel3), resid(mudel3))

#jääkide jaotus - mudeli jaagid peavad olema normaaljaotusega.
hist(m_residuals)
qqnorm(m_residuals)#Sirge joon esindab normaaljaotust ja punktid jaake.

#jääkide multikolineaarsus - jaakide s~oltumatus, mis tahendab, et ei tohi esineda liiga palju uksteisega sarnanevaid jaake.
dwt(mudel3) 
# Vaatame valjundis numbrit, mille kohale on kirjutatud D-W Statistic. Selle soovitav vaartus on
# vahemikus 1 kuni 3, mida lahemal 2-le, seda parem.

