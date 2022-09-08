
--Parte II 


--5. Creazione schema:  


CREATE schema online_challenge_activity;
set search_path to online_challenge_activity;
set datestyle to 'DMY';


--Per vedere il numero di tuple e i blocchi occupati si usano queste interrogazioni:
--analyze;
--select nspname, oid from pg_namespace;
--select relname, relfilenode, relpages, reltuples from pg_class where relnamespace = OID order by relname;


CREATE TABLE Gioco
       (id   	  NUMERIC(4) PRIMARY KEY,
		nome 	  VARCHAR(100) NOT NULL,
        plancia   VARCHAR(100) NOT NULL, 
        maxsq     DECIMAL(4) NOT NULL,
		maxdadi	  INT NOT NULL
	   );
--num. tuple: 995 ,  num. blocchi occupati disco: 34 ,


CREATE TABLE Quiz
	(codQ 	NUMERIC(4) PRIMARY KEY,
	 testo	VARCHAR(200) NOT NULL,
	 imm 	VARCHAR(8)
	);
--num. tuple: 1 ,  num. blocchi occupati disco: 3 ,


CREATE TABLE Task
	(codT 	NUMERIC(4) PRIMARY KEY,
	 testo	VARCHAR(200) NOT NULL,
	 punt	INT NOT NULL
	);
--num. tuple: 5 ,  num. blocchi occupati disco: 3 ,


CREATE TABLE Casella
       (codC	  NUMERIC(4) PRIMARY KEY,
		nordine   NUMERIC(4),
		codG 	  NUMERIC(4) REFERENCES Gioco (id) ON UPDATE CASCADE NOT NULL,
        video     VARCHAR(8),
        tipologia CHAR(2) NOT NULL,
		CHECK (tipologia IN ('ST','AR','PP','SP','TP','NR','SE','SC')), 
		-- ST=START, AR=ARRIVO, PP=PRIMO POSTO, SP=SECONDO POSTO, TP=TERZO POSTO, NR=NORMALE, SE=SERPENTE, SC=SCALA
        casdes	  NUMERIC(4), 
        cx		  DECIMAL(15) NOT NULL,
        cy		  DECIMAL(15) NOT NULL,
		codQ      NUMERIC(4) REFERENCES Quiz (codQ) ON UPDATE CASCADE,
		codT 	  NUMERIC(4) REFERENCES Task (codT) ON UPDATE CASCADE,
		UNIQUE(codG, cx, cy)
	   );     
--num. tuple: 0 ,  num. blocchi occupati disco: 2 ,


CREATE TABLE  Icona
       (nomei 	 VARCHAR(15) PRIMARY KEY,
        set  	 VARCHAR(20) NOT NULL,
        dim 	 DECIMAL(5) NOT NULL
       );
--num. tuple: 12 ,  num. blocchi occupati disco: 3 ,


CREATE TABLE Squadra
       (nomesq  VARCHAR(15) PRIMARY KEY,
		nomei   VARCHAR(15) REFERENCES Icona (nomei) ON UPDATE CASCADE NOT NULL
	   );
--num. tuple: 8 ,  num. blocchi occupati disco: 3 ,
	      

CREATE TABLE Risposta
	(codR	NUMERIC(4) PRIMARY KEY,
	 punt	INT NOT NULL,
	 imm 	VARCHAR(8),
	 testo	VARCHAR(200) NOT NULL,
     codQ   NUMERIC(4) REFERENCES Quiz (codQ) ON UPDATE CASCADE
	);
--num. tuple: 3 ,  num. blocchi occupati disco: 3 ,


CREATE TABLE Sfida
	(codS 		NUMERIC(4) PRIMARY KEY,
	 durmax		TIME NOT NULL,
	 tiposfi	CHAR(2) NOT NULL,
	 CHECK (tiposfi IN ('MO','NM')),	-- MO=moderata, NM=non moderata
	 data 		DATE NOT NULL,
	 ora 		TIME NOT NULL,
	 CHECK (data >'01-01-1999'),
     codG		NUMERIC(4) REFERENCES Gioco (id) ON UPDATE CASCADE NOT NULL 
	);
--num. tuple: 991 ,  num. blocchi occupati disco: 29 ,


CREATE TABLE Dado
	(codD 	  NUMERIC(4) PRIMARY KEY,
	 valmin   NUMERIC(1) NOT NULL,
	 valmax   NUMERIC(1) NOT NULL,
	 CHECK (valmin > 0),
	 CHECK (valmax > 0),
	 CHECK (valmin < 6),
	 CHECK (valmax < 6),
	 CHECK (valmin < valmax)
	);
--num. tuple: 0 ,  num. blocchi occupati disco: 1 ,


CREATE TABLE Lancio
	(codL 	NUMERIC(4) PRIMARY KEY,
	 punt	DECIMAL(2,2) NOT NULL,
	 squad	VARCHAR(15) REFERENCES Squadra (nomesq) ON UPDATE CASCADE NOT NULL,
     codC	NUMERIC(4) REFERENCES Casella (codC) ON UPDATE CASCADE NOT NULL,
	 codS	NUMERIC(4) REFERENCES Sfida (codS) ON UPDATE CASCADE NOT NULL
	);
--num. tuple: 0 ,  num. blocchi occupati disco: 1 ,


CREATE TABLE Giocatore
	(nick	   VARCHAR(10) PRIMARY KEY,
	 email 	   VARCHAR(20) NOT NULL,
	 nome      VARCHAR(20),
     cognome   VARCHAR(20),
     dataN     DATE,
	 CHECK (dataN >'01-01-1900')
	);
--num. tuple: 8 ,  num. blocchi occupati disco: 3 ,


CREATE TABLE Admin
	(nickA	   VARCHAR(10) PRIMARY KEY,
	 email 	   VARCHAR(20) NOT NULL,
	 nome      VARCHAR(20),
     cognome   VARCHAR(20),
     dataN     DATE,
	 CHECK (dataN >'01-01-1900')	 
	);
--num. tuple: 1 ,  num. blocchi occupati disco: 3 ,


CREATE TABLE File
	(urlF	    VARCHAR(30) PRIMARY KEY,
	 valido     BOOLEAN DEFAULT FALSE NOT NULL, --FALSE= non validato da moderatore, TRUE=validato
     codT		NUMERIC(4) REFERENCES Task (codT) ON UPDATE CASCADE NOT NULL,
     nickgioc	VARCHAR(10) REFERENCES Giocatore (nick) ON UPDATE CASCADE NOT NULL,
     Admin		VARCHAR(10) REFERENCES Admin (nickA) ON UPDATE CASCADE,
	 tempo		TIME
	);
--num. tuple: 4 ,  num. blocchi occupati disco: 3 ,




CREATE TABLE Contiene
	(idG	NUMERIC(4) REFERENCES Gioco (id) ON UPDATE CASCADE NOT NULL,
     nomei	VARCHAR(15) REFERENCES Icona (nomei) ON UPDATE CASCADE NOT NULL,
	 PRIMARY KEY (idG, nomei)
	);
--num. tuple: 6 ,  num. blocchi occupati disco: 3 ,


CREATE TABLE Ha
	(idG		NUMERIC(4) REFERENCES Gioco (id) ON UPDATE CASCADE NOT NULL,
     codQ		NUMERIC(4) REFERENCES Quiz (codQ) ON UPDATE CASCADE NOT NULL,
	 tempomax	TIME NOT NULL,
 	 PRIMARY KEY (idG, codQ)
	);
--num. tuple: 0 ,  num. blocchi occupati disco: 1 ,
	
	
CREATE TABLE Tiene
	(idG		NUMERIC(4) REFERENCES Gioco (id) ON UPDATE CASCADE NOT NULL,
     codT		NUMERIC(4) REFERENCES Task (codT) ON UPDATE CASCADE NOT NULL,
	 tempomax	TIME NOT NULL,
 	 PRIMARY KEY (idG, codT)
	);
--num. tuple: 5 ,  num. blocchi occupati disco: 3 ,


CREATE TABLE Usa
	(codG	NUMERIC(4) REFERENCES Gioco (id) ON UPDATE CASCADE NOT NULL,
	 codD	NUMERIC(4) REFERENCES Dado (codD) ON UPDATE CASCADE NOT NULL,
	 PRIMARY KEY (codG, codD)
	);
--num. tuple: 0 ,  num. blocchi occupati disco: 1 ,
	

CREATE TABLE Puoavere
	(codC	NUMERIC(4) REFERENCES Casella (codC) ON UPDATE CASCADE NOT NULL,
	 codQ	NUMERIC(4) REFERENCES Quiz (codQ) ON UPDATE CASCADE NOT NULL,
	 PRIMARY KEY (codC, codQ)
	);
--num. tuple: 0 ,  num. blocchi occupati disco: 1 ,


CREATE TABLE Possiede
	(codD	NUMERIC(4) REFERENCES Dado (codD) ON UPDATE CASCADE NOT NULL,
     nomesq	VARCHAR(15) REFERENCES Squadra (nomesq) ON UPDATE CASCADE NOT NULL,
	 PRIMARY KEY (codD, nomesq)
	);
--num. tuple: 0 ,  num. blocchi occupati disco: 1 ,
	

CREATE TABLE Eseguito
	(codL	 NUMERIC(4) REFERENCES Lancio (codL) ON UPDATE CASCADE NOT NULL,
     codD	 NUMERIC(4) REFERENCES Dado (codD) ON UPDATE CASCADE NOT NULL,
	 PRIMARY KEY (codL,codD)
	);
--num. tuple: 0 ,  num. blocchi occupati disco: 1 ,


CREATE TABLE Partecipa
	(codS		 NUMERIC(4) REFERENCES Sfida (codS) ON UPDATE CASCADE NOT NULL,
     nomesq	     VARCHAR(15) REFERENCES Squadra (nomesq) ON UPDATE CASCADE NOT NULL,
	 punt 		 INT NOT NULL DEFAULT 0,
	 cpodio		 INT NOT NULL DEFAULT 0, 
	 CHECK (cpodio=1 OR cpodio=2 OR cpodio=3 OR cpodio=0), --cpodio=0 - la squadra non è nel podio
	 CHECK (punt >= 0),
	 PRIMARY KEY (codS, nomesq)
	);
--num. tuple: 8 ,  num. blocchi occupati disco: 3 ,


CREATE TABLE Vota
	(nickgioc	VARCHAR(10) REFERENCES Giocatore (nick) ON UPDATE CASCADE NOT NULL,
     codR		NUMERIC(4) REFERENCES Risposta (codR) ON UPDATE CASCADE NOT NULL,
	 tempo		TIME,
	 PRIMARY KEY (nickgioc, codR)
	);
--num. tuple: 4 ,  num. blocchi occupati disco: 3 ,


CREATE TABLE Gioca
	(nickgioc	VARCHAR(10) REFERENCES Giocatore (nick) ON UPDATE CASCADE NOT NULL,
     nomesq		VARCHAR(15) REFERENCES Squadra (nomesq) ON UPDATE CASCADE NOT NULL,
	 ruolo 		CHAR(2) NOT NULL, 
	 CHECK (ruolo IN ('UT','CO','CA')),	-- UT=utente, CO=Coach, CA=Caposquadra
	 PRIMARY KEY (nickgioc, nomesq)
	);
--num. tuple: 7 ,  num. blocchi occupati disco: 3 ,



--Popolamento:


insert into Gioco values('0001','scacchi','plancia1',2,0);
insert into Gioco values('0002','saltoinlungo','plancia2',5,2);
insert into Gioco values('0003','pallone','plancia3',4,3);
insert into Gioco values('0004','basket','plancia4',3,2);
insert into Gioco values('0005','minecraft','plancia5',4,1);


insert into Sfida values('0','00:20:03','MO','01-01-2021','00:00:03','0001');
insert into Sfida values('1','20:00:03','MO','01-01-2021','00:00:03','0001');
insert into Sfida values('2','00:40:03','MO','01-01-2021','00:00:03','0002');
insert into Sfida values('3','02:00:03','MO','01-01-2022','00:00:03','0004');
insert into Sfida values('4','00:20:03','MO','01-01-2021','00:00:03','0003');
insert into Sfida values('5','02:05:03','MO','01-01-2021','00:00:03','0004');
insert into Sfida values('6','00:40:03','MO','01-01-2021','00:00:03','0001');
insert into Sfida values('7','04:00:03','MO','01-01-2021','00:00:03','0005');
insert into Sfida values('8','16:00:03','MO','01-01-2021','00:00:03','0005');
insert into Sfida values('9','00:00:03','MO','01-01-2021','00:00:03','0005');



insert into Icona values('Zebra','Animale',50);
insert into Icona values('Koala','Animale',50);
insert into Icona values('Giraffa','Animale',50);
insert into Icona values('Maialino','Animale',50);
insert into Icona values('Moto','Veicolo',60);
insert into Icona values('Macchina','Veicolo',60);
insert into Icona values('Tram','Veicolo',60);
insert into Icona values('Treno','Veicolo',60);
insert into Icona values('Gallinagrossa','Dinosauro',70);
insert into Icona values('Triceratopo','Dinosauro',70);
insert into Icona values('Albertosauro','Dinosauro',70);
insert into Icona values('Trex','Dinosauro',70);



insert into Squadra values('Zabaione','Zebra');
insert into Squadra values('Caffeina','Koala');
insert into Squadra values('Fornaci','Giraffa');
insert into Squadra values('Clasher','Moto');
insert into Squadra values('greggio','Gallinagrossa');
insert into Squadra values('destro','Triceratopo');
insert into Squadra values('sinistro','Albertosauro');
insert into Squadra values('centrale','Trex');


insert into Admin values('pierpuzzo','pier.puzzo');


insert into Giocatore values('luigi','luigi.zabaione');
insert into Giocatore values('xessus','a.b');
insert into Giocatore values('sas','bu.ba');
insert into Giocatore values('yolox','ad.ndd');
insert into Giocatore values('ernesto','er.nesto');
insert into Giocatore values('mefisto','me.fisto');
insert into Giocatore values('pasquale','pasqua.le');
insert into Giocatore values('ezio','ezio.greggio');


insert into Task values('51','Fai un salto','99');
insert into Task values('52','fanne un altro','100');
insert into Task values('53','fai una giravolta','999');
insert into Task values('54','falla un altra volta','9999');
insert into Task values('55','dai un bacio a chi vuoi tu','2999');


insert into File values('aaaaa',true,'51','ernesto','pierpuzzo','00:00:01');
insert into File values('bbbbb',true,'51','mefisto','pierpuzzo','00:00:01');
insert into File values('ccccc',true,'52','pasquale','pierpuzzo','00:00:01');
insert into File values('ddddd',true,'53','ezio','pierpuzzo','00:00:01');


insert into Quiz values('101','Che colore era il cavallo nero di napoleone?'); 


insert into Risposta values('111','1','cavallo','verde','101');
insert into Risposta values('112','2','cavallo','nero','101');
insert into Risposta values('113','100','cavallo','non avevo un cavallo','101');


insert into Vota values('ezio','111','00:00:01');
insert into Vota values('mefisto','113','00:00:01');
insert into Vota values('pasquale','112','00:00:01');
insert into Vota values('ernesto','113','00:00:01');


insert into Partecipa values('3','Zabaione',999);
insert into Partecipa values('2','Caffeina',9);
insert into Partecipa values('3','Fornaci',909);
insert into Partecipa values('9','Clasher',99);
insert into Partecipa values('5','greggio');
insert into Partecipa values('5','sinistro');
insert into Partecipa values('5','destro');
insert into Partecipa values('5','centrale');


insert into Gioca values('luigi','Zabaione','UT');
insert into Gioca values('xessus','Zabaione','UT');
insert into Gioca values('yolox','Caffeina','UT');
insert into Gioca values('mefisto','sinistro','UT');
insert into Gioca values('pasquale','centrale','UT');
insert into Gioca values('ernesto','destro','UT');
insert into Gioca values('ezio','greggio','UT');


insert into Contiene values('0001','Zebra');
insert into Contiene values('0002','Zebra');
insert into Contiene values('0003','Koala');
insert into Contiene values('0005','Macchina');
insert into Contiene values('0005','Moto');
insert into Contiene values('0005','Treno');


insert into Tiene values('0001','51','00:01:00');
insert into Tiene values('0001','52','00:03:00');
insert into Tiene values('0001','53','00:05:00');
insert into Tiene values('0002','55','00:02:00');
insert into Tiene values('0004','51','00:01:00');



--Popolamento generato automaticamente:


INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (11,'zgeFVLQG4VpSR4ziYFqAI4a6rI3a3HGY2P2sPevFrb0CcBsDHAGSSxUo4p4pJNcfe7C2c84R4sfVFQRoViRLpUKxzDo','Q34zwy6YVva1q5HzEAaH21Tlep2ChcREulpus8JSQd2ychojgXcliMFY4q4dlFzieew05poESPOMOA7VHwbtHWNlcwQ',6,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (12,'m4CX5VQQoYVvm1v8c1uBt0R4xDkFPwIxdKMKHlrHWodpPr0EFgbc','woZu7wOPZfUUKoTnoH48xbIFWfyFE28aAqrVxA2JK',2,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (13,'k3YqlpiZqBmqUrAFhMYieAQOTqgnckOzR6nLvz7025fhK87pVkOsAwZzb7r1','ACsSMWsFzmqqD3hD7OH',8,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (14,'Q7jteDRZFCIBa7tcvwoxEjMJqUnkLcWHJwlibEngoMlpz','KjygYBR71MEDCc5KGK4L1DRFso7hLTMDNeBJXgRImTUZjU3yxQwOBIUiLBb5XWp7122pNh6RvtPLH2i0G1l6JG2REsQgS6xgz',4,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (15,'8oO46oCLS2rRx2SewzNo8CjyNJ6ODqHd7JYZf7MYikoGqTMSCKVbE8qCbE6M','1TLyEyiZMo2civlznFbEDV3njynZdS0WqJgSQ7qjS64RGqlRgugTUrn60ZI4mT43sr8PrTj4Eql4gW3LQph8QW',7,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (16,'UpHjCF7pxKvYFxBhngipBfaPACNvc5TRh3PJTrGWBW1RVIxwagHFqrv6Sn','VA8nHjVHPPTxaw4Amfu87g2hI7zXKCyHzx4nCXHAN4gMmB6y6c5qt2mdIUqBtJXZtKsuDOA6',7,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (17,'ytynjRY1Dwd3Q3uZourTVKHcEaNbQMPY53IiiMGxka1XqJOAB4xqCgZlNJVU8oIdYTzc0TZmqUdag2','iNsF23rdcS1pyloULggqJm',5,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (18,'3gOu34','KeKhF1kaqoBLFFOCzP7jjOjVyBanJUEi2NqLegLHORCim4KVVdkLTPDRwzmua3A6O8HRHDJtuSvwtP25PMHfCsZ',6,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (19,'S7dCoPpVvVM0MwpuSegcWDnz3gdrBIrVAjRn8j4oJyHxomgomevGrlR6aidJdkzGftooQwYrXuAcu','rMBJM11Uprz5bzrwQNs5lURBiTPMMu6abq5V6ag4FAOS1',6,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (20,'MGv13zkE6rK6uA2wWnrJADLHoqIypqTmcoBYRdNVY8ALpIyXyps17G5YVFSKIDJneUHGhSY0NyMdQ6WQ4UBt8uf3hvoGgBM','JivTryi4a3fKmF10elUPp05pN50pindksSo8OnpBx58M3eQ5OP',5,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (21,'fexrqGQ4fbEyz0kvXBKI0WthETZ3zKtPB1hhh4LUImUwyPUw1Ll85Fv7WW1acB8tfTOqZ41qweRhFQERe3Fn0BASyJcKvsc1','g1Dw6iBK3YeuQtrPd2NGS2oloFsKwVA66vvoU7q1J0wOcoaT8Ls16HddLkKJdNqV',7,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (22,'Ell8u0geZxvRiWlQqCuyn2XPQK6QbQIjBxtJN3iI6uc5e41ChjCTisdAaA','2vh4D2Oz1PYEqeX88SAYZvSCo23k2SQX25JgEz0GSigRz0nj',3,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (23,'HcIx5H5GPZwyBYMay6nnasLXxe8lCrdNcWdjwTdbCz74Ctxzj3HWwOHk05zvgl4o8p8yLnL','E0L0DrbisAOv0w4WDK71XrnNhhG4PnO4GDIA1WC6TFscPvzqvjnv5C73lCkIzP4VjJIeLC3txqrhgmMiLlMUiR',3,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (24,'jb28','r',8,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (25,'oeKAg0qIpqYzxhQfzK','8YDvEQZsKjFPaLCZIgGavB7QOZlevkTkUfcDTk5NplR7zNwy0CieR3dNaRWWiQvp',7,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (26,'BqHQoqmdwRxQcBgnkcI41qQfL4QEJI5IbciU0icU2mBrJK','nBg3uXXZCOPhqfmV7MhmVMk3qS',4,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (27,'YC1dCciHzs65dEGBum3L3eyRUtGitgNvTRXcQUmh4gzu7PyoFeFgHVukMf5H1ktjT3FlHP5','EOP10G0gDfeo7NMdEgY0V4dZ6Hm',9,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (28,'uQ3qGGCmo0GZjX7BvDz8j0vFqsmDvIJu7dvymSLHDtwqDketeggsnp8GVlO2D7Iib75bG','zEo1R1CVFkNwkJfSKQAjQNVlJ3LYB',7,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (29,'UeAVznzHmPh4ZINwQyOBYYhHAyzH','l1Khy8g0AfoBsThGR3nZaChCm',8,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (30,'yf4rErc7sYQQT13DkDA','FP1w3dngN2vFn8EtcFhav3b8SGvQ7dlLbGtt0P22yfrGtYYeLCWIJR2IZXv7vm01FLPuRyPREOKxbDtg7BUzg',9,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (31,'6JUK8FFdMVlSsFf6dJAimQSKyioehQnlUJjX1nr7pojqyyEh61cQhhXL88win73AlxgHxsCiCi6bVL','KiZz8LY2q23bbDe1GAumtMbyqMcLQegGEIca3ZR2VdCeCN8hsjuSeaJ4sUYxVvrejPzWKQVhWc',6,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (32,'PHqPyva1mqc4w','UCFu1I',2,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (33,'DZzvkT1C3Hr5','LapFRJwGaV5BRVBYNDli0oD6',5,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (34,'H','s3BnAtiWI',5,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (35,'DSWW1oed6ogk21ZqvAYZ7Q1ZwsSNuHxIL4CU3bA2ct1iXeXBdNl3BK6Ki3gIZqrNQxztntIuZpQk','A5ZQlwNsqxjuYRBE',3,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (36,'lp6F3TpL3xzHXbCFYBDv4q06zOuPnSQvX74c4vtpMyo0Pt7dnbgrblU1OVzx8NWZfeGKnnErYj','pNLAyW',5,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (37,'28gOYH5V8l8FaLvMdSHEPNqw8qrGGgeVCPDGf2O80a4OVUnuGmWkL','NThJTOHqqMjkMoQ6lIqby82QxgqWqOIS4zBxPspbNFwL1bXcgo1',7,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (38,'FaON3','36eScKJorHZEQwa4X32bj',8,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (39,'nkv','8Au44wia1ZHhWWxHOYbSSVKpIIXkGvBULq5hYjGpeYEcdGxpkz0vXGpBxjakaCMaPjaIMBb',7,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (40,'QzRCMpXamhYAwViqFCkkwWiEToyb7YkfoJ2WrEGlsyL','lRhwR6AnZT7HZK6ZbmidIMXPzBTTovyK7V8FQLj2lk00w2DEuPnmcN11EpvaKgC4y4VeDZZ4MGWleaZTv03SGl',4,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (41,'e3b5xsT5htXabu1MtEYekCu7UjaUh38j2ODVZiCKyk8VQYulJwdiHarEcUtlYzzP6p7sxxz4d7q6wH','3201uHYLJIjr85pQ5224AMbfuSteApPnM4ekZTObMRrxAVvE7whwP',7,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (42,'EjVfZDhAH0g0Jrr6SaGGib0OlNNZT6IHt4U2SL18GBUnfHU0POkk7ej6lE1Btxej','oqlQdxdeOqcWtbgi56sdHDZkfXImkufQGRHBM4JDeTXuN4AaG6FAepNixuMdoHfRqXMs2jl0l1NxRgjLBuUNvln',2,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (43,'UiRX2xid5rdpBH7ZGUdmqsJjElBrqAO30TeaFImLxENLgFJN8mQwzkI058JFqj6','rQOA3g66TLOBE56EFOz4ile4AqfmXlcEveie5JSeT3eIIQGilzqZeu8SGb31c6bpmmEkd3ZJfYavyjXc',9,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (44,'VzVJkSO4EJVfjAp7fAgsTTpynZaXbMh3kgxRWShLRdhrzOYALaRbrjmCnb2ept5HI1e1tVlMnzTonjDmIKbXRKH3H318S1KhL5','b58lyMohrKAxOJenlho4gmgoWQcIboMteZToGi4lWMnjqkJWFXxn0EYHcFPsLgJVTrt3yipbwXRVYO0q',2,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (45,'sceUKHSaKSzE7x3wsQUkA2ArH7Ee65xl8avZScnZP7fej6Hiuh3Me6W76rpr','M6',3,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (46,'cg116RfGwZoRobnnNliJgSTf','t27HD',5,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (47,'05FlxUQbr1kVbkyQ56jKiKIO5mgSgIoHlWcNTRBHJ27YztRUvVks3vPAJCec7ETfOpWS7MsXq76e6Q1VJL','V6SLVV8fg43F4QMwydGolVtdi',2,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (48,'Hg4uIPemLEo8rSZvts6RCGLPZI85HZo7nZBYriyg1rQF8I5pe0','1blOQWgB6EuBGbDajqVqDIt8A80bqkWdp2KZkmmQ5Q0urYfemyNnA3hqI63jZpYurkX2o8N6qIZ4ZrBfMisbFeN1U',2,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (49,'xPTuK8aOQDFDQHgbKDkk','TD22W',8,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (50,'ac8iuKWGfL4TuOzXwJY1Ph7plelglzssFdSUbr2KdcEYs3yxjU5JspidrvqCwMC1W1ysOdD','BZeg7uk37ZNa7p2muKGtqBmaMIKmF8xnjBQF14ygpcmbPzVgaYCSq2MFuRsTno1WjqbsYQkf0czzbRE0WCZzr',4,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (51,'wIGcosXrvTBBecqi3I4OxZoKt2PmLjEQOkuCvQNvIhN4Yv5qgUirb','GsAbgGW68iDh5X8MVTZryk3rIDPrCU76LHrxODjVe6XHkoqNPdKaMDF',5,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (52,'zKEkskEVJzbTXfjFspEh5ZCMCV4mFwb42H','lDwxJc',2,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (53,'xW8NOin0Pre4pbld6V2Lmx0ZvDgwx6w7v2SqWf4by','0PYYJVVbBfAwAfvaRbxjSxU7nYLGpY5YcO6',2,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (54,'xcyMG','B',3,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (55,'jni8gilPhygxI2dDwpimYNkTZUnWj4asiZUyuCbZN5oywvHvK8PjoeW7MH3d1nSvb8um5bZwfbGapxPxmpxKusLQS4TjOSZL5','RnXnACiv',6,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (56,'tTWkZRisT07q4qYcsgOiCzfXgS3Uu14cqugyGaJ62N52jREg34FjWD6uaSnlrV32wcn5DYABp51ODTGgm2ldvMgbT','8c25mAcM5hSXrjPyeCJwBampE3vRPTZAFX7haQLEdtBfcam4UW4UpFy8neTuP',3,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (57,'ZkfRhjm0uAa1','2MlDm8Ijt4GMqh260YwJOMdVSy1JO5tBowuY85vQECshkTkiOjCigFVKNaANT0TjknUQdbFTCSaBwEIZM',6,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (58,'FkYmDGinjZPnKqMh14HwVfKrKSZ6CJo8nlDxHr0EIYA','mCvuWvuF1sCm2Qvs80QW7qbwBy4utPUOZ3XbJJZUCxYvDykKZ0',3,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (59,'12fC8TLz3QHdUrAaqvOKOJpjwKnpQGA22Hmw7f','LMlwVg8ZAe',3,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (60,'haR1i50BLU5BQtc2YQKXZM2ID2B8cCCvmQLJSKV5XpuybFBTdwF5dXPqG7c2hQ25d','rpfxeDRkvM6PP8q3Z1N4WyhsrWrrkqAfc8L8gR',9,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (61,'Xv34D6roR8Joe7o6fnTOY3zpPzDt6PObDEtgJXERLaynryubQsowBsRH6UeBvLeAOnTlNHFCNiq80YBcO','1pzIfXJzNeLkGiNJFN',8,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (62,'Xyx','mYmrKaRoBjLXv3878bwkN1t6mpzmaXSapSmmo6VOevwpjwtLPWeqdRndNjcgEm4E6AG5xzLbGD5Uv4ajxo62VycEfSg3HV3',2,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (63,'uk6zFaJxvwYAmcsFkHr6b0eDpM4OKBXqpYqSJgYIF1guWuZqHjFcIMcVzYpnXwzElAJy4QeyIDyyZWul0rzHBKHxPxIcYrUHWXY','o6EXnHDfw6nfWrOpHCrpZk',5,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (64,'opWkmR8Xye8rxSkTQPibf6ndAMp3NK10TPgAHj1Jm','KvU1VlFWUsUfq',6,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (65,'x1CUUS1Jiq44nq4nXWqy1uyxLawj1YZFlEj62ooVQRCtcDwmqdY7iU7gcobZP1F7tQa','LcJEiPy8NaLHmNzYflX4E1xXUbBeTW2oist',9,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (66,'p7FeP','dNwJbzpIsCnw2cCtplrIf8bPIMXXgHe6i1unWKFpkSTsnySCqKrZGcS6lSV6grTDkXDUZfp5XKH7eUEfm3nNxlvqYnq',9,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (67,'gKPfxWFA0xar3NASiSdCpHKAg32','aZ7UTXbmZzeaBPc1uGFVqQFtEPabiCx2h8FmdmiI',5,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (68,'hv8eCEK8L4dw6oOt7GDQZo8s','AjEi8U72czghgKp0bzePQijJbHeAs471YGDRQD4l7WlUYoim',6,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (69,'Ua7uTj0mKqNnSWa1ZnqtWlfbzeA4Vmu6OiOqc6aILzDUSu','wVrPKZSyddydxH0sDDWBptsmwVOddTQuVWMxJS5pajYEqmXbd1K2gTpsPqqjXUP5zSonWOLNuryXNFpzFWUc4l',9,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (70,'rd8r1sxjvMsDIKfvthQgiUFoV0TgWZmrvxWVqu6','ZYbgXN0EUQke7lNAQvEbZ8BFQ5uumlPn3vsEJUOonAZkV66WxZWLo0gQQvbA8L0At6xjqRmxcQsocJ8B6HVI0',8,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (71,'p','U2bIUQ',3,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (72,'0o3','5knPC4sZGZk1UnwhshCmfQSoYDp0l8PbltIJm3Rr4zRMfaNK',3,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (73,'jWKlQvMgeN','r',8,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (74,'3y8f','bNpfyCnFswHIUt5ePcDCtHq4bOfTZbTqSaMjPOZyC8ttZ',2,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (75,'wp5PUqTdLoiORKALNHVOhn3fQHDLI2FQc1mBDbf3YzuO3d6oeI6l2eup0DLM8sVjNq2LUO7zOs8','GUAwAs8rGTCMvNGMKn4eOMslY3uwiBDhdIzoCNAf2I8Far416UxwUon1Ie6HMhSVw0m1XdCYFu1qMuL7',2,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (76,'Or1tdZ4wZTjrNL','pPRZqIcOQcJt4I4X0Wjg1LqbMfTXUQaRTfzqy3SsYrTJmrJ4hN1vO5tZeua5IB0D8TZxWG',9,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (77,'oo3vzH4fQQCnznOPcRhtdTlozZpbH2TmfHKnz2yr5BEfvBRg0BAQl5JCeOOksc7Chv7g15','G0f4dem1eWumz6v75zzvgaTjGZwGr3ZHgiAZCcH8vMlzfHHO8e1ALqUn',5,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (78,'Kn','to08Ytt8KoCBHlWjPzA2jJQKCxlgUXhAIxOP6uReGtt3Mas4KqrUKhRGyEzKQczhB5W2lkFrkblENZ4rJI7exEBXzR',4,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (79,'kDA6m3biy7utQO37vSg1KTlSH1ZragwEmvyFLjhsni','3fQocBWRu3SqqRjOPrhjEIw3O6hiegddQjQg2ozrJOKr7JA6gkG85yroYwZQf',3,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (80,'qyDyV1qzqCfNN3q6TXL3eVxPazMcO7gSJeW8BS042QT3TFBRyrL36QTt5aswCelanyYoB8PZa6tAnFchli488ieSgiU07VZhrab','7kPjshbjluFUfZ5L001tjGuTd3Xhbcl4eJXfI08zrGPzXBif2UvPA3vAAmY',9,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (81,'gncmGf6LpPktbDcUe5','zUyA8BnVyla8Jo4svMTvAd1n4hnU2xTK7S6pBN10O3hzsZpuBz8AN2wX4hEHHKOEeLZA4cnM5PhQKKpME3GKVKdINQwh',3,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (82,'KykAAyQbsYriwsOyWHCRayDclDoNN0vSPpCTjCRWgGclPMDcvq5kLIStwWHpARePL','ZhFpaE4XJeI1ayjEypUPPuOgxiD1sJGPwWP8afizEYC7OSG6ECVK7pTpFL1hL6bdBc',8,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (83,'By0cCoRSGW5Ecvly6pqcazlePBKaheqSVdrXvVo0SiDbxhWHEHmmAUz1avFu','FiagUcW',5,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (84,'IbGtGJcvaZpdHzXCLsKKLrIMNCnaZl0qwR','ttevv56w7Fjn',7,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (85,'Vkq24y2AfYNqy7kfqE4BSmqTYzNYztW4h2FHUz2ebSBpqAlmEXE7NuCZpubCbBmT4VRnYJ6T7RC7I','Jvu8ueYxhHJ8scmQK6KjQUTfmENpfAHQh4IgLf4hP2ETv',7,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (86,'wTZBW1JLojdWAJXmoEHODtMtGxV7gy0cAgFlYVXYmsBJ8u6jjUPjcX4iqGI5ozhxBNUqr','3T24KujK2YVmj0mU',3,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (87,'ytWSJ66gwbzHWP1nhGbACUv1oCNJ4z1Zj','DQloOQB',5,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (88,'CvqxlLtok0PKNYcAw4BYITRYQvbJtBZ7jyGQCiLVWxlYfbcj','O61qnXyrhyTkcRLcQBSB2W7kyCfUhk3Pzi5ViRo1',5,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (89,'sZcRUmY6XcpLPCUC6OjNvV2s0stctNLScyjgd4cH6BazTuhlhz8IH4RvzDDF04hqMXCx6z4cuYdjZUj1BWElMqrvSM4TR43cOB7','wiDdcvZQb2IHxGqXdrYoxaxv136jmtXjxxbbgOSjKwygnvGCCAcYIoAhs4JZhy4gYTL3C',9,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (90,'XeTABvzzGFdKSV2ZiIaMfw33','CKEyjaF7OVQ50TgBeMCJlSoA8l6ORHIcfAsuzbMU6MnTZIHiZ4pX0vtTOzk8UoaHz',3,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (91,'S4cIZ3qn1TpA0JmRVU74XRahqgg3','Z5AOfzXqxKrwge63KPPoHdVAoEUo0',4,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (92,'erOdviUwHVGobCh4QMl0c4pNtyY470k3hCOSQaPhJRAplS7AblBDSgpr3Rj64V2A2favRS','hzMV4EPwciz1VfDKlJuJgDvivUoGPTpvg3mxMevgxFAjknav62odJhxrxqG2OQSDxIPR5HhvypiTln67mKFcw',2,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (93,'x3WFyUP8SyrGojDdEo0qsEMPOjPYfYbas7ygdzsEYkBUbJQP2wH8ezTmpOKa7KSEe2pygX5UF1wS3nhf74YSMJ','xU8D4SsP05VGpbODrLmwk8LpuqhNe06n',4,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (94,'olHcJ60wbPhdSwu8nszXQzUEmale5ysSDTjGTsbwARpXTlGwhzanPhlHNPKAJx7vG2v2eJL2DPQTJ0nt','TAqppgyxJwDFQBf6WJrhDxpjyuV1RgqUega5mtZ412MrfGfJQkBkyLNd',9,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (95,'UFANAri6nPeIgNw48exRzOWTfYgotJsWVGRUevKmYJV','Gop6Dwbn1',9,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (96,'xoHBCKZG5sdYCEKscaQN6','IEki8pkX2f7JmYTFV7Ho0WgTW0PBvikNCb',4,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (97,'VQhm3gqrBiGG6YrFW6UFHX','8EChwOzEazrygSBkoJwh7nGNlZ5nrrHQvuIsy1PztNzWE7CuhrrQpPuTUUzQBaPcS4i1GYcwu3EmBnUu1faHdkzxtj',6,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (98,'INQ14j7kwxZovhaLFaBu8Nr3hIfPztuzim4z7myyhymNSVOhzF5ml2zstdCDI77mnwP5ZDAC0xCCQlvCBrwNVJvbalVZeBc','FH',4,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (99,'t8qhaUtdqMCyBeNAUeBLduNENvDNDyXyfqDWP3','6nQxd22W5iwD5PK4HYIkTo7eQ3Ed4bJOtlwu88EhAlo46WFfLJaUHGilwO',4,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (100,'oPi3','Q8kDME5FTBALhfBsDvEL3Oe6VlapGgbI4yDQMYzV7W5Ytzpqw0RdgBU6Y',5,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (101,'aHMWURi1NiBLSOfkB5YRVgoHSHnSFqg1fZBoM6pSY','B2MHN6wgeei3xG2Wp0RFHJhzhn3NsKBI4vOF5K',9,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (102,'NPHhrCIAR6Lum25Ry08EdM765G3fLCEqB3q','2HgdylKFeIE63XQcGLph1EpIBxe8JyyEbFX2H1VQjIx45uAMjg6kRjkGZKpriPiSgRakyvaVLnZKDG845cu8hXU',4,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (103,'2QjyBci24D7TCfkFogqICoQlyJxrYKDrYmXI87hxhYutKPg3z822wnBI8sF6WcMN7OMppAKmOXdWEeVW7eLVcuQUH6','Na2YDBbDmdIGCP0arUr1P2fi6BjB',8,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (104,'rtjFuOIFBCenVI3NCLT7C3WqtpZITMoVY','KCuVZVKztvOgP06uThLBKXC7dmocvOTQVsFuZvYeRoM3yNv7IUxWtuFAolMGUnVwmL8yQrY05Wicjgh5EgJJK',2,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (105,'jGPRqSuB3AxL58U6oA0UWzMbEunMUtxFRmQJ3SbU3yTHTaIMgojMJKBC5rECrO6vjOwoO53WRxfcPfoX0v3ZowfWejC','eiz2yzKQxa3Bubp5QkcHlIFvBzKYZDjHduAMIPcZmx4iMY7JKQ5QqHBWDigQKk1FDBJJn5zN72Xjnav5QJTFYTxjQc5',2,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (106,'QVUzXUKT88NRQpwryetxXIvOG4Ekzg0dLOE3s61lpvRmpu5XFzTYi','QEiHl8Nle2zdCG3MaGV3Zak0qdoT12BHEmDddwjD7OrcPAKY8q8l1P8LRohpeyV3qnB24FCrCh1r7WfnEkcuFVVD0vHkBR',8,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (107,'M8KxXyV7CZ6K1yn6oBjsIiBDgj4fOqaVEGf260OC0gUH5zxeuXvWbngXV0ufmMxHe7SxEoBLkZDnU7E8FsyEBldO','fqpDyyTWMWqHxE1l1oJIeZ0Kh6WFxq1N',2,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (108,'IWBdoCWxYJxhD2uCGVpM7wMrSpUWMcv','daFbIyYYcMsTvHqVa65okZvT1xnvv3NPsHISKc',5,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (109,'PI1hT86hCj6ewVOWbMsxPTLiAoi4pkqhD6xzQSDWLULj','tKAxg',5,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (110,'bZaJXGmgYcjYEZ16bZal7C8us7AIC2dMq','p57tJUvWFEqjI62xCbOLZW1IOwIGv4rxhQ8gJUbrVKf4GjNz3h2e4bzISNfLTYKNYnfdqCCwWCwgcEvhNug',4,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (111,'sbBPkPn3RblXeZlLipS1VpkJAfBJBcUtkcQJOMXkVmf','kU5oarhGdcsIVFanZ3t8jh7tWsab4OqAKbqOk6ajbGgzjGSNoooeh5GuHVRM1z8gGILzV0jnHkxM8D5oLt',4,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (112,'TzKb','ppQMEXlzt7Ud1a',9,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (113,'sfpmXNMz6xxZsoZH4OFZ6p1rTUHDNo3Ug1lvgDfbM18F4','4BiRND',6,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (114,'rP6YXTUA7DJ2OzwvDDf71y2','UhGAah6DjY4w6hiWNPtIMaeiq4yeV4JXw1WrnAzx7',2,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (115,'bRuVypPQWQ5NV84xAFFiO0z5mL6VuNFpy561WS5BapHB4h8HiCfl62oMM461OSONXQp7CvBo6i6YM4OE8wOsf30WOGMov2','4qWibQUXXYiQADBLclj8FOlvOYN5UgTWj3ZIe7kRQWHAMtj',8,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (116,'ysbRFbYubpINaPqbRUpVLlvrLsJs2W2GM6z2KRb1ahmK2YkGkt5hz3VzqGG53bG2UZp8','M2vtdDOQOauGTT1apfkvY3nR4BzX85fNMZTZIJkdoOADcd1jbtUSrwwAoJpEZ0yxgS8D6Ml',5,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (117,'ILSTJjCmvBzKZwp14Kv','Aaoxwf',5,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (118,'JjumY8O3FryvN3rWQgLjyGes0XelJRSvRWk03DuBqxeYhAaflgVnNQsdzzDkxt411DWu4HFNu1cpqfb63avLF2AOqZU','2Cpjw6h08EUgpi4cgBYf2IeYXD77cSbqoDslU1H',6,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (119,'JlgIkZM7EcdLJDsrUZgASEoE','Ert2VYlhHpBktcXwBsFN2pFLYGm2qzrXcEtCzWzxzPiNW1Qij0vtvaGQ6X5DSLY',6,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (120,'E7CkwZYNEp0aVVkpNy6xitZBQtqkuiDP6tBYHLuBKDgm','i6WX75NiIzMqEFDOiwzlQe6AqTCHsacj4aXFWQA36OFIruYZAVT38WTYkLZ6JQVztKJoL2ZbGM1GZvL20LyfZW57o',4,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (121,'K8LX6p3ipxd4F1ErzTOYxxHXNyl6TQY8OFmY7dH8WbBXAKArKYATHFKgLGU6M','OmW6AfntoCnMmtRignd3ruIDBbZbUaIkRiKTJePjeq8D8OfPezckj5zuRYB21RvSR1SbRYEEil',6,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (122,'1hsSIJ24qidejX5Pa8h8hu4RGYoxpHHrD8nKaDXzl2Tm1OMq8b8QGFkumY10HYOSNv2UnewJY03dZ','Yu7EQJXQy2AZiKV34E5FbGcxuqPD7wn3OtmAN1xvoGLJJNEYPWSNodqbHWutkPLzE4C23DuXTA7rmdt',5,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (123,'1kTGDlfnHennRSy7sSQWppKu2l3JnXh856QkWyz4peWlQGHVvvADaHXFrcNAds7ajGm8u5BE7CX4jV1JAL60CHY14Jg','BeTXk8uIswcGoLIXz8URN4HhWNELBjPcgFxAwbF5OoVpZC7eLmhRDicg8Ulry',2,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (124,'RHwrsSQQKsA7paVRxcOuvwmTV7BgJ','cSoQ2PSeOvNVHtTgNnaVy8IdLEgI4CctHHcaPzBbiddytbMdHuYz6PU1xFabzvVZ2Bw',9,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (125,'SspdLTzDeFtrkUK8mKpY68G22WuaOTvnuyXBPHcFK0ADMZ0ULOWMw3E4KUU65erYLmMHLceiuiVhVw','Fi',2,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (126,'rDYla2JLtXXLwAyWjrDttDwDzNKc0Z3EWyKZtVMtUuZ3rU6d','upnu0fAyQqHej8zoM6rC',9,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (127,'l4W2TNH48yMxuhAlAHZfSZOo7rgIBMbiaFqsD5ChAdoJBHhEGVKnM54YHgdQkkyZtpH0WuO80D3Mfs2PUjp3c7vcs','MhrxMX6',7,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (128,'7N4VhQAIaK7iz34wZBAqPMihJcwoQLsSrSe','uv17hjSyEOEgX6pTZh7HSbzbENqrymkubXp',4,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (129,'wWJ5IOoIe0JkotKlZjMGA7TnYMdHRLGelDrzLj05xBnFbpDGPe5dzPdEw7uMPZULVGGfLeV1efWC0Q6w','xOzUN5w8eHsbPMoVQ23JeFkCRLYKwoMm3TxZFh5Cy8vo1IRriEjqQdIyB61VOpRWN1dJ6HT',9,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (130,'BLaVBomMdWxcRyJ7DsAg','noOhZ3vMifGrB0eKdyNtk8MQrxyYIAfHfrFP7HSOqnMfkkt1hsqAafTcprGbN4YSuZx8SCK5GM6bNLD0UL14vyhSD3f3J0wxsSa8',7,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (131,'SexKIeTQiBbIRXREvlAMMWzzfJpe','iLnbFL2wBFLKDIQWzkuOL5AJzA4gYvB00U3cIdcweJOQ30TutPAYaFTHFW',7,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (132,'c7DFGhcrWBrG6Aw','3KbUQ7jg36a7F4I2P06wjcdTw6YdtUYrNxWvCdfyD662GXhbvdpK8QMAbknFzO4txVgTU7VE6n',6,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (133,'sMYRm6BXAxh1e3kr3bRJSEhAvIPhkuJ1NNV2L','mpvONtrPXb',4,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (134,'g10nHZSeBnFl5Q3Hs5DrCYm3C4DEPwOVRpV72bXLmykDS1Dlg5QWstWLTtrWmQ55Hhjuk5EueunPELvXcYnkA3ZOvkWaOzYTg','6YnQXLESZjrjQ8qUX7rQkO850h1yhKf3yMdawNDNph4P6rWvkM8zxTaU',6,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (135,'66ELTApL4hL5UQOW3aU4cuzYYN5YjL4ZhCR3Sai4UYis0omEtF3S3MmhXATcZhrzSMW1n0EMpZvCfr1qyq0vEti8cYk','sbyiz5lOm081TZh8Zlkpn1mDoFHR064SqFSvEwFQBg4SO2XyHc7Vl8k',5,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (136,'Zf1hyZ7puwdVQk687HktcktpP0l2ryNZwH5kT8JdyXHVra1zuISOy6Zr4rNvGEGr2NnkmbTp1hMczlZIQid','SawMqSCYLij1oOaHmHUWX5s2LpdLFLtGhQ5SCpE2hy8KMoButLgb0yvIlXCbKeNrcv5W4ybKV2ePxyYm8nU',9,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (137,'aAK1RNqLdkH1c5Fi3nJ','3gziGBHHcK1PkHfNQT7HTmu5ze4EoFgYAnryypDcMEsSiiwBuEUgOaU',2,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (138,'jZAVNq6MIpHnP1bhRDwR50ZGOd4MlrvrPZ1kk5zIjYraMIxEOR8TaWDGUmitqI1dA3PoIGonSe6j66qrc8','AnoHoOQskDYuF',6,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (139,'s1v3FCyrptMtRfi0vPGeVFAGxJoSrgvKHZs5ewa7r','ebK5y3L4KF6HBmKVCiPnggc2tHug4IGzOL8SK8rVoOWvz0JmDr2ZsZWbZFBtunbfoSxva5ZsOKlZFmDdto1I2SuLsJ',4,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (140,'qQjm7usipF1vswjIhJ','1UCIXc5G8sbVHKLdzgb7YRi',6,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (141,'KbqSrt3HtmKe7f0LrMqcSEhFN86B4fFXRZrOKMfRtriGFmTgwQWvKxkHdoBCzSYdYpBL6odBts5wvH','d6syekGMkT0KOM052twW5vZa4DSTA41XKAFh1hMsZE50rcdTG0D5',6,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (142,'SfObfViy3ybedF5i5BPKTvyMR6jweLOGlfLQweLvq51lsFX7krEwQraOvNpaZIMz71jCEbpRctAHBPVOVHLVZslxn','WDphPspxVBcdpckV4U23fftw4jFfUVCK',4,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (143,'ti8DxaNTS0lVfe','g5BlkuqHf',6,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (144,'VnNDxTsJmCz4D75aBy1zOLdDZBL4OUAu5wUlrdex8BSXIDBb5nIenMieCL7GRdBP','GMMFSmjTKM50CDxNmfnQI7mAy5WCvNNabeidFZyXdmwlmogFc1AvBfPrRR4YXfytrhuIXtlojigV',2,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (145,'ak4Fw4dWVCv6pD5xjQ4s07hnormEpN7TFtMvaZMUocHPkBbLncM','QGgZzDrDl4jDkH4cJ18R2wEu6YXqDSk5W0',8,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (146,'l0qSR3cb2iAo88Z71v8F13MGVPn4N5we20zyBh3hF2v2yoPHVRpa1tLXtDkX','R2vkOxO1IXhaSeyQYD6JZxukuLq4tF0ePXzTopnGDRi',8,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (147,'eux8HDxOtAelxHTlnKR5g4M6Il','QltHYNnnfIMeZIeFnm1mKuBaFMEOLxlHSFdhOAzBRG',3,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (148,'4l1QCExGlaokYmkpxi3dq6DygM2uytm0JRoXhf7RqoRa','Ph',3,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (149,'xPM8q3IYdJlJRm5MBqMh6eCpdcUt32qpIMvNtcxuGfGjxCFCBn4VBU8jRvb5NduRaneUylnIcAfJMuHenHCMi7c5Sa0ay1i','bNuhbfvChEFgOuwhs6brPLe4BKegbhcmNlLFU2T3xAqtMxXBc',5,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (150,'T0dzwRUdOsgHI6Vb','GjACXcXpoLP4y4tkk4cdeWZ0dDS1Kjedmbw2ZpfCY',5,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (151,'QQTsQele7u4MpNr1e37D6dIBfmTYVYXdDqTi7obNDKdy2qAUq57E8XU6cY7ouvFs0mJmam4FzwhPu1N5T8YP','mrB0AuKknsy',6,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (152,'WcyVmoUtQ3thkp6eIAekgAREENhWuQMbkXwztxfN','Ya4QoB4',6,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (153,'nKiiXqbLh3NtzqdSV7','DxzMxPyBKN0XpmrYpZclXwQUS7JrZ7QQbKZ8v7a',3,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (154,'zsnHF5Jwb0zcozJtyeI6RbDwnajla5BSEAMbatAkDQ5tAz88jBwYpoRTW2y0EzkkjfCCa','L7h0CmBRpbl2R4UQ7tGHyOK7uEUn0mfdLSGPVODRcvPG',9,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (155,'oxNJePEsPuXqjLzXIxEqwi0LIdfqHo','wxT1aZQke0gpQNw3BR4RPSeknIh8kEyTakmqjprFl2uAP1T5luMLVLKAW8emmmaIOqAPgfZ8STwKMvjXQniQiH1RSzhLNTHTzMs',3,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (156,'KjjTNaNxdHSR8eVJIcBHV','kCoVE6UZKIaQHp48vIYVxkttTJv3SkjZ2PLA4xHVTgG5q',7,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (157,'JWVRUEXxNRxFpWHrw6FYvXXJaQRcfJT4Qs6xBgS2nvvHTvLt78t3Xs5GAJQDA3Gr','xVWQSfBoWOzKL2BaWzi0YG0sS8FrfhQ',7,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (158,'pM','oh8k8JLjvtEG',2,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (159,'ku65ilrpLtW6i7B0ZR62ja0CkjPCxqdnVW8L2cRHT2oSXzFfOiklnMBiapEEqcFzaIqeQE2EZgHu7BkT1Z3W4BZDQdnF7F43cA','And7Yn',3,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (160,'r','cMXIQtSEE6swM0k2BlDtziFrKCfAycKvNDkCQBbkZtyzjEHEq1nCgGnwMKbvEDRobcg8NZJpWIdILVjH33',7,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (161,'PzAEi1mKqWMrjnujJIQDycKrEPjsukE1N7IKbD7HwFWXNy2mqIRqOGlJLckEmKOpkDoFvRNCfdBQu','85BBgBHCjkOfUmdwnWDEK2YFkRzS58tAklZPgFNj8JmR4JtuKzqjUROSzRuTflEGMGeF3OOyT3NPN2nFcepbJ8YhYFlI',4,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (162,'cQSeBREsl58PzsbPgLhcDKirJUMQlgJO51UrJrf6voYfJy4SwBuqmYq8uh4Xw6B6YUVqDKHMPC4lgYlTLZe0HTL5lGH','ZTMqxUvZjJWJYAogxR5zopXgECnAoZEveUYQpPaPPOCULvWbs0mMRl03i110QO81gICAj56lZhUDM5UrCkRPAq',6,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (163,'rkQ4m3DAETmig6fnEjRYBj6JZG6APyOL0ikqWXjdtGuJBh8UgvX8Xi1tChOEvBAaXmRP5ye42EWaWqF0','xfH4wbzwzCx6OeVDYzrlKv5kTNuQQFQZciHk6LLzqDh8E1Im3RXGk2oi4QUkyeYMFiyGJblewrZn8',5,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (164,'ye6kxpZTm6BM','PZAf4P31LyF1Zx4qqmVPi08PhtIClr0UlpO1fvr4mNZCHjcUIOA0gM',6,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (165,'7m6bK8UBt01iQbEsCbm3K11QxpOu4CR5jiXvdOxQGmVGpgKSXa','gVk3eModD2sZ0RSe1IUqC7uNDsAG',2,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (166,'RJPZv','Ngatvxa',4,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (167,'hN','DX',7,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (168,'XY3UJ5aBkXEwHKg32ybMebfo8rXB','nitudfj1Dt3TWvCTPuGRYW8Bxubgq',9,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (169,'J7dcWMyjftqPiYRVNQe01yqEDRm6yh6WBjZkSolQ4','gtNRjffaUrJuLz6g8s5Fqp2wUwhFxpXIfrO8NLMApJQOw5INysvk6tasPzvE34PGG4QWIyez',5,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (170,'iKRHgcaLSR7AIgDKWQ3aIcdr4ZeQzV2XHJPImuxP5T68Mpw3CP3Arf6xbulzoY7jE4Q3N4AyJD6cMr','xspliiLvOwRHdoAFi80JrcdQSiiRfFzjxOUz41ObvkXejQQb',7,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (171,'WLRjwd022AFtm2cIIxllGvcGeOWGlT6TjV85f6sHzTRa0Y7lY50eZBq77E0sbPcwljbJQH2HK5YUsmOcQcYabDT8nfWalj','EjhN0fRzrCV0iibu6xeJsVhC3t1cEpmSNwaRI4AYECCysG1Zcz4XlqgTmkvtsvOxyQ1EDXnjoOYfdpq1',5,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (172,'U2jrK','YDKK2HkRSVLCnwXPIL5jYtUxNNDosRTWrEJhdPWf8RgVk7OBjInqCi36Axij8Pw5OYwQ6aFXeTxUN8l07r3KNqd1rZzD',7,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (173,'Oi18gB3xpZ3R6Dd12uqel4ZPrdhmMxNBQyJ7CwcdoyJ7VatSt7Y6Uj2S0VCAIrodWJsB6IrZscofIDsbRnYVWS6GtOEwWIkRCFzf','xob1kWaIGcywPvsDVvWZYJvgitDRoxh4IKFaDFHxG1dmaJuzCWXkPOiKZNoYXKkGU6pmrWbILSCzkv0',8,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (174,'RH7P0unuKDhr5NqIndmV6F2WjWOrlhbFOGP2VSpsBj7PxgeAgDV','R5SmJJGFhZrfyxVrLb',6,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (175,'agtHhiE2HKdCoT3Eb5qyoxeEN0tsdxrsmL8cMewE0cxycwiHFUqzyfCXA4xIVSoN','rASrcsB40sWJ7QLGvlGbiy2NKdHpT61SAewuuJlg3kfyMNn4JSYUm',4,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (176,'EEfUHpweyvhWDk24gv7La7sokYeYvunWtOW1b2ncaFCARyVaNDzx','dQAzTm6Vl8EojVfrVD4cq50i5OC',4,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (177,'Xg5zcTglLUPz0AX1Uw0vzMtDBtDHF2CksLj3DZeg0gJASlxLOdYLQXExdSaDiMn1qXfhyHbYzBGX4CedVvlkGIEYvJuf','VEGO00Sk624PPIeQa3cZrpKDamBKna008UgrwYYbnpnY0dU5zEVMfl8S0H1uKMNfvFLSKB1',9,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (178,'fovZBHblgnYqDTLDcaYPb1fBS3cgWY6N8AVKRBPaKA0dGYftHBG5N7BGeaVxXca1DTQpSTUoLI1jd1O4FWGYO2ou','UxenDUotdDKCJsqPYcfGIpqZJKeLi2vGsbstFMF662Li1W8NoX',4,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (179,'ul2o85JDaEH70WXcWLN0kkitVjvfVizA7bjvRcdBGy0VzhQGEAFkunuJO7RTWrCslN2qmD0VTq5oef','VFUauHae11zr5rCbTKd',8,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (180,'QNK6m7JyDp0h3boCXrV2eSDCT1N4iDEekqM3o4aDWY4jhlv2DIVPJamPArst7TNrxb1ojdUSbtSNcs5CDO0YS4MLhalPTPtXy','faxKtMlnG7jOuozfvuJMUXtLSu3aPbDfCVp6juuQXTNq1hVTdrsTzhXSOedJmJDs1r1uNhVII6Kk2MCzHhGijC',6,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (181,'v5xzzl87DyQRAHQxIfIQU6wSA57rJVDr35Uuzyz8XYavEZxp4s6TwATECczcTj5Eg7G2Al8hIcj','DeI5NeWuC4FMWFoUtOEqg1H6kwREEU8RPptwLSwJ65cUEWUED3vVT7oQqHAwh4X5HYZ1NglAo3',9,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (182,'HbkzSiloacV2W3CEwClgstwVQexvPh6lM6uSemHKTFaPY','syzuXh2b3FaaeiUtaJcspzhgzAboy5I4XLjbljoHVHM7sfMBpcAYnCZlSaLY7nHjrcARoJy8Hzvvaq',4,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (183,'tZVeVQHv6nHHcbX6eHEVHTjEdpNtqSfcvtg7YGzAyjUXlRBURAbYJRqOQ8Rj3DDauiOd2trNLYz2GmctMk7DXm7OJR0LgbYf80Py','6iTrbgPNGHDosjSz285drp0MQPz1FeBRKnSMrqAOvcgEugVFSAHZirl2qJfPkGgZ2IDn',7,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (184,'ku57jBsNWwjJ1F7047Cu3ytLs1PF38wb00N3j2SCWaLwRTyAHHVEr5ZYQn7yMMxSiV7SyzDkLHSh7DyhnlpXJCReA20VoCL','XdYRo1A3P24RhYHkMOHfiohwVXVbbLzeoJI8alDyE0jmot1TmcjtyRVtkoMiuiWxd7dJvzP',9,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (185,'zzG3epCNHHgAPQ1PVJCVFPwGgjOuBHDBqmilvXohRnC6CVUiXmwfcY7rzNFPxSrK40ZNkI','W7pW2LrcywRS3p4fAZvofzHnerthO2T4nKfUflqjAu5ZktczRbFU3zef4qkNVDf7enhhYgS5luLyrT6w3sZknL6Xe3Goil5g',7,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (186,'tr8ZbLZCayOluadMiL08URhhv7PqlI4vepxLTjHv01DcxE3PlvkOyy8LGiDN3Z0qhKrFMIs2DdhI0fpV7Y6','5OHObElQskcCcCH8oqCBgZsW6KSX11K5CmtdpubLsftHLdN3SG1rJTBM2jcZI5TP0GLP3Ex25H8HIGxkqtCezV',7,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (187,'M2ktRg35swBjgfU1IHLHiJPQGODlMlSb5','oW1idEBckSNjwtUO7PjmyWD5E8d5r82h4yiyU',8,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (188,'1TVU','oiZIqQMRF25adgHNzAjVZLs2AftBhLot4ojPKmDnPDvTnq0PgbThmz7u7FAWLgqB1xU',8,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (189,'JaVb5wg7uyOZ671gp8ZuahGjRxbj6uSomyT1B5pWjGe3dbyVuEAbKLOyXy4eQfJws0l8JHoHwpJDpZx','FpZ',6,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (190,'hUuhpUcf2soPcBimolzXkLBeGoFKIeyhcLYU6xWzUD','Z',5,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (191,'s0mrYyYhRg7ZHdxwuhM8jM7UIVxLbL6narGMrdy7BJTaShT0WdoisKlk7Gospy3','8NHl0bKDLWl4pWIS2qcwoRUKZS2Nw',6,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (192,'Qjz0sIwPaoXY5','FOuuLAhUrDj6hTrSMNqnIUZHmw1QG87thzVp5RHrrSYkzyPMAuTpjVCtT',9,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (193,'1B3JMaQyleV3qFIechFHZFZYsPOmW3lOQ0csYa7lwakgzd8GMJJYkyOeGw5Bw33OwOt0UO6baE7icuID','JuRwgugCPVLxs',5,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (194,'y0B4Z1C4sudAZPBrb4txwgUhJHcQnOOa1fyJVwcioadfBcT','nogRu3RGeFjAaChvg8NuJZ7d7C63I8VOWvoPzZJqoeP8kPcMnokggHd3GNzMECcZaBpvH',7,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (195,'ZrhlSlm7PQ8ksiYoGQ','FoBvDDQmWGLuktJcbDRe6dty1kc4ouJq0ZMDj3Mo6xgimNCOvJzJZNKidX',5,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (196,'CzYEo04LyLKvQAQf1YL8jRihJWPwGImgSrDcbb','uPhcN4Ao6CpO5CIhfrlWhImKVnt3GlJS8IADW1VoaPXDpziJnDKnlknSKPOF2Dkjl4ERK7mqED4lEbIQEeOs',3,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (197,'eBKyVs3Rb6Cbha1UPD3RsC8DIJBOxezvcq8E0aFHLhYNL53p8kJiURIUd3TqALYfGEBUjmkVHLRTVOYFZOjMoHSG2wEo','xr8RtWy1EO0kN6p8iumZmhdS0GGCzyaaDBEFcn4OkpHvd3eWSIo',4,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (198,'H5i61gW1hzpKlRc1cgKVSAq405iXM2eyigzXrvzY88Ne5gdXztVIU4GtU0DRbSiVVmAq6ma3fii','vyeE',9,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (199,'W','5klrkXoidTDPfQyjdzltJ',7,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (200,'0mjZtUFS2SyLcDA3','HanIX3zAhtKZTqtByyIzXIdKRnigCBinqrzOpRytAlC6EaTfwFVp7n2tTxeJCf13VTiIhkBPRV5MCAzwFG',7,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (201,'O0MoRjp1Wwlo1hNLTYSWKx05GpUf6qJENQh37ZVYkm18ShIvNLkurAYTNUkCEAql8HrGQd3RtB2Tx01','gFcEby0scpSdUqNxrqplh58VG50E7pukVpjoOYlO58jCvQoZZceFjP3ypYcyQ7cvcKrA30FMUwoprMKNWoVcV7MDCl88I6O',3,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (202,'fdb63gkoxJwawkxq8OjlxrtTiiRUQogf','GIHdnVkVzW64yb5rVBiVFSJ14H0uY',5,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (203,'sI2IAGz1Qxjvkb2olEsWLWqFE71p5AlklFLQZQox8m3cUJLJFMvUdLJ5UoQbazfpdno6z00I5u26pMLreeVf4IEWlWDdMaPDEY','lnhWn0szMGc3d5hD7',7,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (204,'mb8hyf5yYBuwzFufUzizsSr4STbcQkAe3xssv0LRYqIFgeXD4QyWvgv1pK1BHSNSbdEg36smoF0HvkLFy4D8','mpglJyLuis8dMWpi',9,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (205,'K','ZhrSxLhcBp84RLC2Ufs7',9,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (206,'vlx5TbxZP04MSKUvlNgQvCW','Z4pf1sjmBAHlKo2G7TEOswDk',5,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (207,'rmQr5RlKxMjowySEDM6pC4sZSVyj4Paf6hFzXP1wRMmroZCoSFjW6hIrjls6VuHb1Uf76jrR0juxMn','jbnBXU788v81YBiUy2oWecw8dMvcFnB',5,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (208,'S81Z5bVFkPhEWS1RNHVrDY6sHPaoPpYWbA','v0sxIuz00ligvcWTFhfvGygqurwSbuRsPBhO5XrB5UEQH88unOp',3,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (209,'srzT1nuKo4lIhrkv8SOuF','1lAWhiq05VijKShNBZUJKs0FkCCrooa3sB0LNrHPiaDz2e78KQU',2,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (210,'78H8JxlP6gkX6Dwtg6mqqMrmgbwdUCLkBaz1gU6AZv4oOMjpiLU8m2Dp2T','SqjOORs2aFRismw',7,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (211,'pSevvV4GzwcZMLZcDKC7WeafWRrLmjSjpMzxGeoib8q7T','1TCJwr5yzogMMySWV754VJyM5AHlhe43je4gtTdQM7QN4XS20ekGV',4,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (212,'zT3xKSufKkq7PCLAdEYApyCuOdGzCacAJsFlZkH2gUB1YQC65HayBIlTBmk1nK1pfXvBCT','zAsZmJvMvaXF8xeSDxlkeTw1B4HhgIdnwzsdq8n4zl53FppR1KlS3RxkFw',5,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (213,'uDJA5a5ZFb71WrLHgIJjzVEoovc5ULfNHIicngbXW2yJUfcgmhZwN3AZoLjlEuEOdjjs7','QlWRuLEAqaI1CHCHyebkm5XgqnGLdQHLerURroIUIJlYKHDzOdi',4,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (214,'KpNMJai7ats0UHxtvheyiPinJS04zYbGsSjlCU51Ljl0Gk3xOCctWA0PdFyOjF1bnToxmBv1NjWda2DJHaZdutndNwWonb8Zdl','wNFRwUSa0LyYRz1ldRT7Vp646j2AxT2ndoNa0QJQekpZtoKwYNWUmxO7GXwKVgOxTfk4WLMDhp',7,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (215,'32nhLKFyNEyygSZR7CjMiqvahHf8orsAtN1SsMOKHCbNGZ0baMGOYvKuq17ZBIT7dLHH28Xy1K6NrXCpAHOCNDyWuqVJBffu','nbq82bJuYWlBUdyulGJPaDKnlhRAjVtlFj6B8wI53NC6oBI4Xbnve67GRiwloHehdmCBW',2,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (216,'jisB','7G84Zq7g1IFYDGmxgrXFTPiItoIfUBrU3z5',4,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (217,'pGAmX1t5h7K6O70PjKtTQTVUy6zWorOS1phMRJOL5FUn','5UyKIVm32LuBVQvw3XxiKNnUvVw3ZhDH3SAyTlj1211EsMWdfkdux',4,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (218,'KVwa4fhCitUR27yiM6iWKqFEI','TfU2ne2QxW3yXwtvh6L73zLrgeliQuKRJZI3zgqbi3rYOnHwswQrTa8',5,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (219,'fWBv0w5tyr1FnG2OxjHgz2EcKGOWfXT0NI6C4jAzzYdnvDLmfOcTe1UtZNA','UeRfkBSXIy3ZMdH2foHlHcSVAE3mkuPvP4cULbPSseIydj4Z7F6KwAx674XUMs8PKkYmaSvsMAFckYNAZ8X5mEukJmHBaRI',3,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (220,'hn7iCurVBlvQiHWd6NghG56K1m6pyBpxdueVloJ','8',9,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (221,'eGbAtzZQbRbFej4fCmFsLP5yKACJF072aFzbBlkTzBFxBLsMBXS1PE1rpBe8ePeUENqDE1kgDF3c0hW6FwmZCLDAxfsdTttDmebW','30ALAemAbmYwThqlU1DCAr416i5AWcGDcV6Ho',5,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (222,'eUBVfD5srSUH6qcUTdDJX3svFzrGJ4ArQq68mv','pjRg8DAWKFsjLnIMdAyeQsuc347WT',7,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (223,'cJywky7rjHl4wZajOkbAOM0trRbiY8ZEVj4oPiiCgEAtvbFidbWg6ssxIO4uxfdmMHyOSDbJGnixraYEBnij5QZtvzxeddo0Q5IQ','BPzBk2fKI0yQM2UIahbDN436Ik6aANBDuMXs7eJ4JAqVZ0XkgV4JdyunIfqmJePygGVRxXysSTzxJFOuKZriIznhcvmdC0Oh',8,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (224,'hlu7eujdLRQn8MZDwa7hB7Ch6OEUgYMGAw1LR0hfWaVqJoSfXkcwOtBwVq0K0p','6lc2Ns7B56u2hL72q5vTawAxGnPhu0ImqjVeAfTSS1g51hyYbLdZjvhbwml8Q',8,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (225,'E4AlbxEszu7uKT82cHNNYSyF8Zv1EvKbMnhffscx5N8PCPYzqZ','lawJVZtTy7wwZv6rUySxb4yVWWq2D4mxiVKGQ2qWpD1i5wmRct7Hm4spj3VA8cVaFDKTdy1pDOcTRNHcBrTZs',9,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (226,'JlLCIt','fH26TIIQYpdxyCJ26FaralB4lIsqABYEyK5Nv7TqjrUWJ4UXCh1kUSCj5REMdnWHYf',6,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (227,'CpZlWxx6heldpNWwxBWhPFlZGUO5GhecmSP6Hej2j45CAd7bz','B261OUH',6,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (228,'uQq83ia5oFvKSptpYyQduUrHnBjFOHbG7XKCLXz6LNObOyzVeioK74JbSHPSHE4yobGRegnH','hrr7C1fA7vrrDmN04UPQF2jQh2jtPtj0mNW1qgBRi126DmrIcTR5Xuss0vVxdFtG6fh8ErGODlkOdOgrNkhytYOfl3iSV',6,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (229,'qy0AiOsysNe8bBBxiKUCgC3hjC3mMCO1lUCZcwsX6TC5qvh2OHJBY','i7tXImhbeMGoXeBf8n5CExfLBFA4Z8ZNhkBRtYaGucqvGQKyEbzPtVE48VAaG6Q7dP30zLe7wcFHrLbfeFfjChBpfAzrop',5,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (230,'Ffbbr285jEjOx5DLDGt66Men3gH1qOVHdvFd6slh8tWcagJLneLUhF5H3jYgGYBaGIKaaMdYkBEmJ0dlziK1Jv','3hHFalVQtqREDCe8qw47NCsAZryzj3euHh52WobpGrly',4,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (231,'oTDcURb30pPyjs4RHDYXHIe6BPFqqPVncxtNlwhStrHNCmQoDRCPlrav8fI1guZJaAvlLJxXby4SrafGblrmUk3nfTUHAHq','fLATf700xTlCFDo',8,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (232,'iTtuDuNPDrUZpsIC2wTX8uvj4WFfB4CBltljyMUuf3PnyMj1LfqGLmLL4HHZGZvLz','tH',9,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (233,'nIzeYNqKb5iIWq32Mo3QBOx3AgPTKUOKoqkHkRTgHSBnx5j73tfdUQfugSzHjID3FVbV7KZcrW2WrXJuhm','xnvH1EaJgxj4wbiyWckeQN1wJs',9,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (234,'dSnig44vgHvj7EbNBA4WKEtzCsnJ8SXnjBTXumGRv58XtSfyijcNfI1W2bq4BDY5r8OIpBMKNGZK','hWvHxsXMB0SBetUV5ouoIRh4dAhWlFZnnuo1ieSkpkR2jiTCiUGgkrxBCNBAagZNLn6fbEUrPikeuou5WZnuvur72yP',4,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (235,'XICxff6bYhwXCWUMCCuyObzRQ8GzqcHEiV1NUa7M0RbisufUoDrIOknbtKTj4XVjpyYqMo5cuHki5CYfpslSr','8zUNkdLAidQFXW6mdytWRtjwfgzgZipIHSxfmbJGmE',3,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (236,'LJyqWYELqxOpWgR37C8vB47DJA2UDHdUyr1MLKQmUtgNJjV1CGQWopLgp7focMTmr7Xygtj4NTmn','ed10yEWjfseyhIk1SArZk48iLODWZHfJ5nNSbRVrOIvyXmgQQUy',2,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (237,'v6SvUMy6n7lGRgNAiNHixL2UIvPfeUDDCdnRVZpUrXqkwLNB6LfDPkW6y','sifphJqwF2TgN',4,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (238,'G0cZuMpWBoQwAjyrTlYmuYuX7UrIaJRcXJ6C55ovr4y8CAhqyLWe5AzNFcCpnf2dIkBiYs0Jkmeft4hpSuawrc','Hx537XBrceYI1MvAM6G78cWcXMrhdrXsN84BVUI04gkguFuB5qxEtXGTkUzHmzA',4,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (239,'CNd0ChpSl1QMuC2D6FHmgQRGMb8EgIPb6COT400SUoYMs3DvM','X1CyRqTNqVHH65bZFIyRbQsN3f5UJ1cb5Y6xcj',3,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (240,'jagtexZmHtNzNMQ1vPipDfnshW3YzKEK0y6jKPWBXXhAEqGADJmKH3AqB6wM7cAznooSp7ANq2VHTo55wdFFW','gEvUIQyBxmqCxZ7Ej0XeOwG7vz6ovHLpxbctvPnPWO5iS1HW0Aw4HdadNqqhFegqi1VJcAqyWsAwPMGVqivYzMUR6w38',5,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (241,'umnJW5nKATRwz8dCAVt7DGLmplYRBZp','uVESOuTX4OzbElTaCzeGVEtPAIVAQYmBo',9,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (242,'HOOgj1eizPswKVoeilEfl31yEA5U0OpDljzicoG6pQTqvUaOIUIK7iPQZ1c1CQMT','Jg1xsAoR3dH6eLPBkgIX0GDuhp86TRjZjWDPj3xSL2kTNqc8W46JGVn0J28MkD3k0tgzXcZv',5,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (243,'5cpkl36Fhx31wIjd78WlJpxIsmtaMLIpavg','IRkkWc2F5AEicT4MbJlpsgIrrk750N3zg1RagDAdt4Rq2lnr7FzVOL4ATF3wrKEBMjNDLDZa23TSJZ4iM4zqkWE6xS2tngh4',8,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (244,'dUDXBc6qExPxBn7inG31GTXrfXPgAPeVrfqZyYIPP0Err1ZlovPGErAlW2MnSSlcNksR2ogrygJZpi1O1hj','AWZWGWvoz3Ops883lbkYSSm2',8,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (245,'uKkrVcMEymPhyQ6K7vLIh1sxWvZusV2nENRsLMXGS80FZtczothRAHJdIe0rgUtiZbdj5TG','LADjTJnoVY3nec0sRb4YcFos12zRNx5vOMzp4uUosVAUg06FRbolyHaL3OdFLClo',5,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (246,'8r5iJLJKHFPkvdJzvo7KtkXiMCHIjLkctkOL0VucCAIuHs','ORWo5HGmNjHkUDPYi4QobxghQBr5RI5BypqqwhwtzqzAbKOIuKiim45tY8MpyLfNrEpJmnbdH46vG2k3X66X3',5,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (247,'vaC5GqsH3dyn1QZPVzAloAiASWyBmztB4CKvmRajvnNyDDdljAPPyTLs6t13DxKeYVowHetsy','znHtIH4QNewhldZhGVAl4l1ME4Vhf2ZwXifPkus1aS0kbbtnX2NFfeF8vbZ454bZtBPJQObTHUihAPmMhW8YGlvZNraeP2Qp',9,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (248,'OGXkGce7UGG27OMKXHQye3zBTTLk6GNnJUnHX7QIBDyXIocVScsmYhuDtTRugptIQ1x','NACatUvGz3PqXuBD8LruKZzINj0ENeQc8Bsx7TIXWWLkxkbrRjbwBpgRTZh',4,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (249,'CGWmJpXtaNpaj3V3Wkd3QVZSXCpnQIMgiYL0yxSC3ohnzFogt4ot','iAgo80DJD8puWdOSdn2wVVwTpnpShwwJgMkbdunu24Z1JKfYEAr',8,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (250,'glszuRPSXzaf4kI70vtJWijMKgaCIV3F1dmEw0wLFlpGarOtOfZs4gOuc18V','2',5,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (251,'xzHpeu2O43POn2vEQa8shqfLXOncq0b8WX','tMh6MerG0rDfiu1NaQzr8gc4Ya5SnJ4D30Km',9,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (252,'rsqDyd14ivMJgsdP0YEvGTfQAXw2chRuRakGsA4iYPbtmj2gwrJXCLz7XcXyqfNFPydqtDtOULZs3i','ILQnTDGpMDJYCUjkk4Je1vtHX8LBymcBr3r01qu55rq0MSJVFfYPuUdlRlFb6uRErAq0LOgpYPCQfzBtgvJpu3HB4ABb8TqVZ7r',5,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (253,'YyxSM3oVFnxoINCHzYIKGYRnQycJjgbVeIonXw4MLkkQuMkVdtOeo4nrX3doMRm37onsBZ3yv0R2J','WtiKFLLH3z5MpjzQgo1vffJlXAx5',4,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (254,'fe82m2cloT1b3HeM47Iul7yrTQdsY54NbF8maN8QU1jNbH5wUcwOqiLnIIjwSGNuHkOc0eOX7FOlAkb25GGjc','kNL4DCTLxuH0QsekytK77XKsz46Zer5gI2fmiIs8MM2HOF3RIfn',4,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (255,'Bad','2wiyOhhF2blV4z6JYfMxL6oy',8,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (256,'k','cn0Z7J7pD7aCNPCdAcA2dVbxNsbAygn7P11PWzprBA7WK7WRYwPcRQ6ZvIZ7GWHbJeIfJs8ZHjwlbTOGtXFGZqdd6cB',4,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (257,'AriwOguIedo7ei0ELaYxim5tNNdEPzmnHFk0V1','pVnCWyw2adkiKkdkHJliOfuxbi7UrbXXjNnywH8OmpTkjqdZn2CE1hcOF7aV',3,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (258,'b','sZV7DuRD5nVDZOLwaNRYhN113CYNtgSUQr7n6omGiBJ5',8,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (259,'oVZC4LnR0NxaXbWEsi6fhMoCH15kS1mNQVarikPdXHju8vlXNs76ezwh4Y53gNRIFgJf7SBU4po4huJlHzylPawjA1vLL1ZTv','wgcziBrleFkIdvelstNIH33njjH',7,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (260,'OtzvmQN8GEFoJ7fmuiiUCqJBibxjJoPU7NfTyyXEnhaa08NL7wZP7h0oZLMcgYAPXuUYpultXcmk1Fp','0HUDgedBvfBHL10IPgfqL4qxZHfPSyOQ64yJwLNfhwIApyyMGuy5dkw5vsNyKbAt7s7ju6R5GnKvlMuYJs',7,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (261,'a0H40MIb11iROjUZUZ3KbgGG1x5Ti','Fv3fLrzClXfLanatOQqFkcwbO2OCiJmhJfzcIZFB2eP',3,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (262,'U','FPBoNT4rJbwU7ytB6pVjlABwIqAWli48mIDCJw86uC64uQoH7Xz6tbAoEX1ZcY8kqMLODhA05hpSESa',9,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (263,'LTP4EVaLtoe5qyr02cdLo1Y3m6JcNerYLiaU8cXUKoWmVFQtiHkv3bvdFoDlMIGJtYRtRVpnYmnYU5NIGEz','eCVZptguyd766vldEAaiMPnBcSLJ5KRHdf24lQkk',4,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (264,'dtJdO03jHDlinWvwNH2M6TvBJEA58YvRCvBNergnsjxGWV7st6','lYrqp4i8VIOtF8WK2sTP',8,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (265,'zA5F14JxB1USsytg7QUaWmyC','mpe',8,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (266,'zlaoCrz6OR3','hzGWr0Ybjm5WIFIAtHDFyrMSY8p2TgZZa7OmBuFVEiQnWx',3,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (267,'F6ktdDsIpGVOfQo2zb0vWQYRDrOZSBlrJ6HPwA5N4kH6RikIu0lj8QwdL3f4h','djaVtG6FzQFq2k6ETww7Lpalo3boGwbiL7RquHZXai4gQ3hVdqg11dNOjeJPV5QpFhw2soBE8UBHSVoW6TMIcCT',4,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (268,'kMgtUCSoUOKkVXdNkyPD','c75GOzn2oL2Snui2w5iCxpqkiY6jMY4ythYKCWEUPGfazbGNcTdfnQTqhBSiaYmN4IO5e4cXTGtV',5,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (269,'N6AhTSwU4kGAKoJcLEqxjDnFpGVFIHxwPvEqd2Y6EwQKmUAunwLHdSFVEmfihPSSMs2v4FS2BqLZAOuE7AIYneMx1DA2dDPm2h5w','cGEWiXhMHW4T7hohfQ1mMS031lpuCFmrGZzEufeo8e2pxPD6SPALIEhh7tY4b5LQxPPYDhsLhT1sggVONoo7rZ',4,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (270,'j2yC5GkG7NfEef0Fc1S0j6PHH6DUm1KCi','k8ClAiDdx1fINYNG0ebMCW4qnv2U2j0KCQZKW0lrkwA8NzB7GxkLnQyrvdg',2,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (271,'1ytsnaclNzuaTMbph17Fk2DER6ni6ucJe0mkr8SEJCBNJRU1hBVCbPCRt05I3dSGSMAvVq8C','GvvZkyLLTpjN2duxqzUEbN8gAksj8apO4cwHN18ra5Hcoi5rJw2',4,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (272,'TW7F1fWxFLDJZLLvIXVLEtvQWU0eivWe6TqVKEGw','PE2nAS5Rqdlvqx7gc7tD2fQtAOBIyjZadnZkeUptbUb4C8VOlMLY6JRxcAw11j8mAlrjKO2Ta3iZK2rwZjcTWjTia613sjrj',4,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (273,'k4m2czVuGaVHcc7RlbsVfkqY2mdXrhR3QMxzZO','q8I3eqPfOQADGbwolxTIvQKblNGJM3lVaOlhr4KbyBYz8vYpAWBurj6xgdC4Qi8n8NlUpY0mIb0y8D1yvAj',5,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (274,'hJMeT3ROF8zdUEMHobfNbrucLcxDBkevZ6DO2deKRnuT4z3bt6cDAMT6','oTFqbL4nf2N3Bs6hilM6RENsTURw',7,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (275,'gBwUvkLwdDG4TdTWxpE','b7lUesbsIms53',9,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (276,'zQvKd','t3TjwVNwfVAviFpxvshpT3JyTSq5hDb6lQS2R0vGhCyZeYSjAMunbF1UTUsxT3zVjvhHNnL6IZ0vc0st',4,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (277,'Aem0wFc24OO4mVfHP5Z7JQ8mow1PfNygJFctYyDobLt45DYSVIiaT3osTnrAURFCHOSGJcCZLAokMSg3q0TYyOGjPE','0L0iIpR8UIfdD0mYY0xFLkucmBuUbYVcrJsyksGdrx062FOkw',9,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (278,'yJzAvYQqd','tUgQc6MtOJKNwQ7s7md85dqHTmmBYN81gBEpCCv1eOB63OExntPdwbkiUhPS6rwFnLLjyiaaCIdqfTeXIerUSs6',8,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (279,'Y5UtJWNavmPYpuyY053cK7rPAvLwGoWejHgfTiY','HmkURS88',4,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (280,'DhV','KlOc1xMma8W181pjqkhocYLYf30BpxpUbIRZmXQbWk45k',4,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (281,'K','VPSPxNQzsNaWBDbQCQbn0jbjlhWeVgSJ6WR6IxzCCHkp8Mz3hA6zu18ZZSCMvuLNhr2CsCag8OcQzrVMp207QSoPV0tKFJGlDV',3,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (282,'7appUMySVGivi2z7ZcmuvD2Rfm1Y5ok5GwF30vnrLPmHYfveDkusVyNpRqhlfYL7X','36uvBWCAwz6aI2zDU0K1ZSi50zdMOOJAplIakOer3MV',4,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (283,'hfJmxVOu7JRqUvELTZS8HKOMPDynAsepV18Lm','sGon6',4,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (284,'dkXvNuNoQeaStkVXlL5DEuzMlyGdoyXFomJjjl0rs2Rz7daWRA5r1bBCzQBQgirwvVieAKu4byCHrF6qYwtvqOs8wCbATy6Q','452fx7LsdRZ4mIQDtsMRFXMFeATRYO7RqYAEDpLvyeDIkpTgIKkBetrwQFti3HFF5ZYUTPIvL3Ul7K0',9,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (285,'mF6DHkXkK','2fFzeDUxRihcAL5i56iOtjPNY4Zdad6kUz5TxmQ6xKLnPPSbzu1fkvRcuSq5o87qZmsWyq',6,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (286,'pRvY0zyvtOAUdTvL1T4MfsvXi2gtbryGTWTwAWkLC28EJ5aPnwByPryRHkk11EkdmlYLahG6fh6RN0HMz4uyzNzY3Kdg','Wqusl6kksVDVv',4,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (287,'xU5VokuGdA7qTPSiekJ2mWeD6s8FyN38B4hmdh7JKcgKd2DqR8YJRq33h2EgBDqCrK3CJOv6UaprMZQuFXNPZ3','xYBq7sRtdz0oy54iTpxc7Tko0oYRPMyqoc1ObkOmGrG0ZxiWjN1IyKhKpMW55mFpYoVsKHDhewCSch76fU',6,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (288,'4yv1ixoyJlFqau3EeFHhoAKomFdtDXrLfekFnnNOW4S0bGShKAcwrFMnE4t6','6HgOgaNTO0T',8,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (289,'Fcaap7l1od5EsOARPPuXqjZc6NlAxhh7eNG0m','sFxbWBZLYZhiRQpOpnD2mPkN31mMBEa4sb3563v7IOaoG4gReQJtJ',5,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (290,'rRxyGGK1QTjzgbklIdngm8jWdGxVoNBRdBcF','HzkQqbUls8nerXQACe3JmjAfKmu0LybiDr6hH7MShBbdhggHUMnpyisd8U8jQ2NkE',8,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (291,'cHLi3X3pqlnXIv','fCN1YZ1E7gk3',7,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (292,'kWHsQX8B5cwqIqHbA','eesqWgaZJdSXpcc0HI1kEvSLRgI0H8ndRUqGxpKaC6ZoMT4MKngBPXrKQvwLoji6tseRpUum1Wm',9,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (293,'cn','D52wvsXtzBOQ20WOmEGUuER5wNTAt8k22DDYEqsh3E1LgmEEDNPJfxmAQdkrT73wPxSfFFkUrcYODZnthfNfZ0drb7pna4bg1k',2,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (294,'Orv0llZXDKGefAMmQHRmktoY2X4UL1ghdM2Dx7YbSthQm','QMlGLegpFmGhC0FO6m2MpAysrY3glx1biYIpDF2v',3,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (295,'TVb0z040y3xjFoiJym3WsxRpizmtn4QFrGnRZ5pAoesiMd7lNoFAFJwOPbvhp7zVnPqhzPeGoKy','vHfzGLrwdYGs1mPOIakbQcla1gAIQ0By',5,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (296,'Zo2qkhWKjlgjMz688Shv3NQDVCQhf4nOooBw8Me','IoMlYorD2XFiFNLaW5nzwKjk1gfDpCDS3chfhWnG03rBwsfcroQmtwWc4JnPkqwM7PAg5w',8,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (297,'5wDQjsCnFzt1t7gAEZSeSP2ZmaFJvc0HOmBOVGsrmW7vnCHLxit3xqfrTYJl8KomwNAyhPxGTM5PXLuFX0koKo658nOHN2rmfhLr','JJr6skSUflZzjPC02PonA5JtsoF3CDw2PfxaMPSfewtQXqvRyqDYRZgqcMMGGQr5Xl10CPHbc7',3,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (298,'qNnDHEota5EAU2z8ZHFBzyAfqDHVVuE','lLWhCKffWxeC6NgMsYTrOfOGLJqydDg8zDJsLryK6H7LaYoh8bYXX6PlevFm6DgbLYYoOSHjFOIL71BplMZavcsGoYcl8',6,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (299,'7azDNAVTDmw5PffX8p4eZUYhydd8uS8LpNcERinWDHCndECIIPpVNR0PiZUWpHmpV','x5GimYvZaWiC3zZVQBDE0nK0GA1vSSsaBaBobHXTl6YUbkEbCSR',8,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (300,'N4ni','2khSBYJxq8ZpsIQjGpo3H5rPTIvcAFPTc4QP',6,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (301,'gWnx0SKS3pXZeMv0YWeT31XCXZVGImlpso0thxrbqq4fjAZn36EKr','ezAT5cOrsxfylXzD6YUqCYsXN30mp0opOcw',6,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (302,'C1mwd1sCyZ2y','upSGVpGakivl5bew61T01sbAXEHxF7oVL0mSjUGlYBjK4AuWxXrSsIMTZJFS4r1Skg1cu40',8,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (303,'jh3jb2NNH5A23I1Ym7WL4m37ukKtEdDNC4DqCjAfcUTpp0Z5n08CbdX8KrlsLTXzdDSmEUM5OEmkqkNmcnwFYg4OKCuag','FTGCddsgPq3ITeAmmgayWIXTMFgyOtPzLbnElPOxiNPJ7hEVOU5iSkmEsYtVu',7,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (304,'XVRknykerEiqMY2tk','nmsKe2VG4gprI5hbxtrd7oXra0VuaIklIlgLAsnrJnNxWZzBhrUaXYhEmZa2wxpL0a5R5IS7YuxJZth3odbsmOhY',9,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (305,'VIcXvRnBvKeXe0pJ7aaSA5Xzd1LPBGN2CriaXskYAHPQtsCgHeqq5jbUNvrXijFWgYS2TX1hBZYPGFVHxEUxgFIKQa1Z6q56vcZ5','f7OFWbTeV0Jnqv5ptiOFZd12forcKkIuee3aPiuFsZmf73bpyOZUZxiLfBVjOB8cjwA',2,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (306,'imjzamQjvJ2CAp4oEvISfAZVDQT14LEfzulkUsqnSELyVa6plerxflcU2AFNSHUZk10SI3IKQQh8PlZuDPtdf3H7XlpT05v','kx',9,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (307,'BktdgHVj4YrmRVpQGqOHcXeGYpZpNxzQxxRMwgViQPv5do3FqHbkub6g12xwOhzkIdl8YFciAiSOfSxtkp5j2y1xDF5PUTRp','b1XgVJNqD8CD8aw2ZJhLnR2xWPIyxMRKUhChQUrSa28PEdOw3VbgV7yN7OGGvcEAnd',2,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (308,'1JU7HxPyUZhixDS5nlIcSVA5yq3sZbHFF0yevalRY3RdjGiEOkiSauQEtYocUIhO7w1uYT783fYx2JmtIDlfyhFX4WjPzylhLE','QHBxaBgcWnGYLDRxhpqWA2qDQk88FrXQmvDTTijphIev1xcyqodbJqg',8,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (309,'vMRKoA7EUUfyI6ZbE','u71XQCt6',7,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (310,'JHx4kpOmKEQe8rsexSeNUBaJ5QFMH6lsAE2ArVg16MeSe4KOZxmraW1eFkrQfrO','3xhXK0LNQ6l5ua4zQVaAR6M8J0beVpMdxE2DLBGfde5YwqoKXJoAUG5ZPGTBAtW6mOUXjkGtZxEGN',9,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (311,'YrerDjpwX6jgwSLstoonR3quUFSl2jNIpmVyqwKxJx7YqhIu','CQTS6s3yXlEbSL8FS06vIJAjzeatPtMlhWGZY7FsAz817bZmzxAh5QL5HuO7KZsFkSOaDb1mKn',6,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (312,'7kVY7hGsmwkWArGId7fS3xLm3kM4sF2foc86wuSoyFayGsxMfVtzQKSqNrVqpfZJ5eWcLOqTqX','LJ1YRN6RV11RrT1AWiQdRvonDuRUcipOCia2X3GLz7W5nUGxV',8,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (313,'FLJ4aBdVsWNc2LrQOnLvYa70kglgzXmIzgNO','URMKy1kRZWKdweDjM6a4a3J8VPLim3tmXoT7cWy1eWgRH08exFev3JBUcgwixLdKGQHelm8P7jiz1rUGSfpkLv14zzeD',6,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (314,'E5jJ3C3AYy53QyI5JdyiKL6LdGBdbMjwYHiU2HTEa3JJTyUZKIWtXCC6r7NGz3Jgdqq20mrgrG0mINs4NPLiFSXsO','wpAsJDqJJ0fQFE1pcebJnvcwnw5RrE33Nw5HrvR51xdkqf1tONpZk6A73jeVTb4mr2n8LOjjd51KPi3wlllGaSq5Si',7,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (315,'vbMQtDkypIYhbR0gFCUhtN0Fm8Lye6YOYZCiKvH6LVGhzN7HkryNn24SFvKDFgK52DuMw','2EsPIhjlM6FuXkSNrAPphl',4,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (316,'0dPB7kbz2sE4mytDIaHSEJW6XEJjYPvkijajAyA7ewvmEdCOtpaCC','gCIYuhZhYWGztQ8Y2HJG2QXAY0DPLVWnY3aJhnEiZY0WFPx1PQJVQspyk2wSiHQxx8FUAQyJIfcbE81N68ZjevpnYzltgE',3,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (317,'BFzASm0AaTx68Qg2veTfCoow2nhfGESbb2kDFOe6FMgV','sSm4gj',6,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (318,'dIJR8fu3C0ptCcc5MntcBA4fDOoITqZQjxJR0CeYlPO6BWM0tEE','cs2pcl',2,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (319,'ka6FC75JRdmKl4ejqYZiq8CWLEd8XBaCPWgf55xm8XchXHgJLidwg4WoQiTh','H7TJWzuMTaQI4ueQPXgZzrom0XrWunSCVHjOVKHVqAvTcnK6Lm4KffCnqiyPkCb7MpseIs',7,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (320,'2SHVXu4OnpvNIJC5sqIkKvfL4MhVidc1ZeRITMGt0YCknWCFmzJxIfelLS2BbW3yCjlLrspxuu4kFQ','J2TEoK3thmM2Bpz0S2jDpnvkgYiHC1u4IV4SSM61Rm6aDExAJyx2nzZJs8GW6wYxJQxCTveSmHgrcHAHOn',5,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (321,'CGiuZrzvbQDi2PjS7fqV0xxE41E80NIgudR4fZSTe1Mxi','sGHlH33jdNKsGy3iQ6Yrho1hMxYT2I7ngRjamKcO1ieXE7aGoK1D1qcCjpnzlv',4,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (322,'61KYrbR8Awpr5FtWjrvvf5WT7ODEdyHloiOsLzEWKIrXMjm42ofD4NskaJWPbB4zlcEsrQYBnuRF6AuLeQE','C7ICIcvUB4wayGEIUjOKjKBlJLMjdpFnwv1Tjv7fvLB2z4i0AXMoPObQ3GoNqgBDXRCbaB2FzE4Q3GE',5,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (323,'mhrABBnsWsxUd8suSX4XMxzKY4iuLP3xpBVNk8MweDV2mDMwXopg6EEzLAgubVClzEARXE1ncnDRoEh2Hep7da','F',2,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (324,'faKefwWqhDz','3FDW0oHmA2BG1j8v0WLfLA7uW6PNMj8ZoHfnAhMTeLswcqQ4yXUtqVgl7bnnKIStg8IR7h2c0fULr8lT87CMHWDKr',5,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (325,'w0Hho','baRWWhHzIUgYyhw6swuCHlzBZfGnsr1Sh8sARZtgsbo5nm6glB',6,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (326,'jgTPBN6ctpBXTNRaqoWlRn417W2Wq3wxUr8DsJuGXuhQQpJJKoywEH6Vndp3Bcn7','KX34RIcyizR38DNtT3nDYTdZZ0LHWbE4BceIH4AvPgqK',6,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (327,'v7Pc5ArfeSrFtAdcL6HHmwOCHUapPYWz2BYyJLBwIYEuxJ4zXE0qFF0dZ8FiNODPt43w7rnI','pE8stg0wLYM664lqY2P7sxxemlguA2PNdjCNhPPm0450N6b0RPbp',8,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (328,'BdS','IyW2dIaNnAi8lzCGgMjla2GMd',8,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (329,'eXngR','ZDQstlpiN41SYxsl1KnVMHFmmmgtbujT7BTuXblgu8KEmmkzKiamk5TeFSoJNVz2Z7CEWZkpyo3oa3iJYcKEASmJALrOdqhTNhZ',9,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (330,'IybYomcnlPd8uP8Jl3ghxNFbgYFx2AC1oUpYNSRYOCnmVcw0Mhq6RNXJYLt6','VBqG2jMktoSvOU0gxhDkmllgaR3g7zWrmNtNZ',4,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (331,'kEo4yFQl25FjCQISoW0kriNGuxbLZeSeyA0TWUAcB43LWQaBanzl2JBeOhoOHOTkCg6Q1Zh3R2iBXzDaaStjhbbvXI','ruKogVlmYI8sKrblAIrd80Po6Y0dN3yzyBdWxHnZrYbm0koIj8S4ciIqZ5fd406bS5HyMu148JTjZPy3rLMDa6',6,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (332,'wOWtQMGrCTM3ZTV6nliwnElLS0gY1HwFlXOHeOctr4jyZTU8OcwkbcbvJ7uufyp2','TXWEm0zel0LzE1Q6I0JSGVWMydoEQGsOXMVShEIdnstATwX5fv',8,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (333,'iXtCdnNBd','V4ZO8UM6JFIQaBmneOOwp45uI0qQNEOfoR8GUWJHRTHvOAFD1N0lF70E5bnKOwZ3Iz1bBZwLVCiDzxDb32yrft',4,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (334,'vuGTu','uYxWX8uvQbJsOPW1PXZMrrJE1mtphW3KyOqVx0AM6wbK6WtCPNwQb2Rtr1Co8rzGudoU',3,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (335,'hUDDzs0LLCWAeGQD37revAqIA','kEEwCQIKln5JGUcyEkkAfKqcoKqy0e4DF3a6rCFeoAOzEO7KJoTfn7CFW6eiyQljSn0golt60HLIrRxhWmbVCor3HjdpzVUBg',2,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (336,'1RGJSBkQzBE8W8IMJN3tGyuWOrvOLfJoaH8bwo42vWvDH','G3qdinCszGR7lF4kXiKAIar3l8z2iKOAlejEZ3B3AnSeoPNf1iNzA0WsLOoQoIKKUeW8DvIYgcvAFW',2,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (337,'JroLY53JpewYXZnUmxbuxs5YEHZbhBYKzdMOsrtLqkU7QK2MVal3o71u6','ATZwUYYfuJ2k0kFnKzIe8iizciWNHDfGI50dPX5Vw7LhchbhX58UOgHXfPcPm08Va2jyl6tGvLlYiCMxrjLbR0SAxDI7DN',9,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (338,'LNkbfVHMNTsk8BhZCaIb3rCahFlNYfG6y5euUfiHyT8WuEoCl','IevUcPxt1mxPGRfvy46aSaEZWdCKL1E1aLDOPCpHfQXYPlom0Wl7XJ3x4V7FjTI4ysoBFpLCK8so8F2VZwdi1d3g',6,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (339,'pp4s44srEHSYimjhGXFPyZth7oAcLAk8exwaho1kHV47JvqhA4SjsTgoCWFWwO4ZLAxNS1aOPWmoaKXf7myZz5XGJSlsc0i','jWEEE3Nodav0HSsMpOWjHRA20FnucwQS2EtBhVWvj3F1MYkRZFpTmlYqyebGy0V3rg46bBWZdfKMJyvyUqZEGxyv',8,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (340,'iQmlbzBnaru6oiAhVk','zYqNFEkX',5,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (341,'2mu17LcGw3bTC4p3OyxmQ28yN0FXXqpj3WWrXo4Wu0vUo','bNt8LGz',3,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (342,'BFpaMbnfucsp0Jfzdm5uMbi6n','EUARxUhl1IQfiZZ5Njczi',3,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (343,'hoxSVVhvCyFrvD2B','zhpSN0kQvHH6q2JSBsQC4xxJIqrbqm',7,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (344,'SrnlTXho7ekICOSvuHRdLDMnrGcmGpSMBstGt7ok8ls','EXDFkcm86yy7Xj4cLKx54sLSkBELL7PAUcUHpM8WFTIz2wLBVr1tP',5,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (345,'7VRrwsHmwIqjYN7DbUvtIHUQv6RM7eaFfJ62pIBk6EtJ8NO4gQR3sQm3v7','fRecvz04e1qdqMKs4ik4ZOLb6yOWsgM',7,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (346,'gBerPjWCfp3fP4rXcI35dKpbN4KrpL8DKjsoRz41l82OvyfsC5NZEFqiBTrK2pzIlgI8A1totR','MYkj',8,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (347,'BtoiZ0q8EEccGab7SkPEhzxiV4NoaLiF5zAGoIdBOWtnmuSjukwmL43mGvErdcaL81lA4SPlNzAtHOwxSLLe25lK','UWEudmZ20IFF2xXGQAdID28xofa2Ukxf7',4,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (348,'JKIlSmxwwtf4YwXaSQ4WXevuviTwp0fy','lEN7zdmRvyAvulZN4hhj4LvxxlQv3JLb2WfJ0sVacg3h3W',4,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (349,'ZtVj7zMN2HGs2JyPlDTxYV5aZArlC7DaNHvAzrXPs4BilX62SvCzRD71l','MpotmxdcOqj1iTnzZdD7',3,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (350,'mIrOoZwadOGmYhzgbThHV5MbWjDNC44ehoserFS5J','cBdunkqVa7AVu7Onw1LT1v',8,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (351,'s3rlI','ayuwnk',2,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (352,'dxthb2OXb43vSxzg5zSlPfpsktu1eiuCsl0XBdwfKqmVIHKXPtXmlwzupj8ERuIaw40lnwsruRIjENR','g1lc08K6USvxVZCZtMZtvg0izydf4mymqMjfq',3,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (353,'ehA0kl2OanIO4MbYWt4DVIBBP7mpAQaymRpHFiOGErIEb82gdPWb6bwEu7Hcz4y0A','VnWCjvXogsioXQ46LaFFpL4urzb7yxvqtxeloAYntTBopmuaYil2Ms8T6vxJSlR',4,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (354,'kMsDV1Bv2c4g6vEtplcHTuR5fg3FZeFWVGNYPCa2kKeZNKA','txD0ZIjiLAKTArzQnmy8kghJfGl8eXtqJxlMoFqtcnHFKzCPhORzJrbkDHPxFAU6HjUvMuOolWiFkP8Z',2,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (355,'IbWvpeWtNApGnFl7Y2CAXwgviWSU86rIx1','bJv841AZF0vsA8y7BXghym75uUu3Qq4sEkRFKBlS2XDTH0JiuPKN4zjyYqChiWBrm',5,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (356,'0XRJMqQgI3TApBs4bqLtbYswsyhpXGbxbXT2ZYTApyzEZMz6kUyGExu4nRBSZ07Q3Zn37FWWWN27ei','L151C7GD123X24pF2u3nX5zzVV3YQiMZLp8zQTQJxiUptlYOmXihe54b5dlRlWfMzdpakO8WqaGrnzMGYB5d3skfOvdur1vbGzSJ',5,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (357,'8C0UiZ8SIcGeyXKDGOwXjDbaB1gH2LatHx','KDCV3FAje4S4KUZxXPvzVIQFQVhVSVNAHv8wZM4QqlDoNBT6YXypDIGyLafafb4gPNvbi5BOjJI8OEe1bOf0C',4,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (358,'TI4vM4oIShIBS3LGawAMNhzC4PzopAC13ypM2X0XmnalxqZYxARVRFGiCcnvfvi3rPbGOqpv86N3nwuLmJJMmxUNau32R5','4sFPog27PpWeG6eqGfSGH2pXbfMS1ZKzloCdNPhTABBln7gcgtAzfURxdo5dkDfW5lboOFS',6,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (359,'rJh8XM5KwJhmTBdibNSucjHCLWCyc7GXJ2','XUmv6AAcHHJZOZq6s3gBoXNFRqBtoPi1sHnmdzFm',4,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (360,'V1eVQZj0YTxjdtQn8qh7e4','Vh30cpXloXl6r3avU3F08zKo6af5XfJ8LLIYQqUutXYIUMd8upcOEYxfu6QAdVyryd1pfmezKY4xVS',8,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (361,'T8z8Bbr47Eji7A','lKYVi5FkZZviyxRqsqCixWj47MjjBb22dfjiy2Ij0VFe6sxwk06iQQ4db57FRy',5,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (362,'fDlt1BXAONqCFXHh0wyV0oVfFOjIHPYh6jqZjN','FaJOT4RkP1PIEzN5k0LaGFufyoi2trtBgemBg30',4,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (363,'nmjaLYJEtXQLOcbzqhnuhjjlMzSM6HMaHRY2s4XFXHmkzJnrBcdlenRkFUzKejDiLIP','EkpL5Fjw170FuWo3J8C2uuPuvmdAvcCU4wIXon4WjjWQpOD7MyBa6L',9,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (364,'qZXFpr8zrcMyPQaN23OD2bhWZC1UlYCzIBEoOajwcJbzKp3o3OxS2M0Ig','bisQwTjiQEAZRJSPqsepW1hw0xx1JYRY5OESCpKrqfDRUPIxMfUgv2J66FXM8ga00zezLRby56C3QHc24vRS5lqiVxn7rjI4',3,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (365,'a4BXca5bzFZCot','Cwc7b4ikhb3zkYu08roILZxVyUM8elduUoOnDxGgU',3,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (366,'74pGwMZeEvN','uoAtESi0vFCYWIS5VI8yscgbYtqtL7IeiSh0Bb8',7,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (367,'HMSadOxmVIGvL1cU0es4BM3DKA8','JFpCvBnfLc77ROkaFd4w3hokuSKPC3KUGOLaXOGu6KonJn2jp7qqUbXm3JagYTt7nmVyBb4S1y5HzMxzcwB',8,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (368,'HZh17LJXtjYX1cCbuyM7tOcG7mDWa5ye3Ck3EIIJLZI8Lrz3WCsjo87i3An8aUb','RKZZAQG71vSCIcXuqHhlGQWdBfnTjk8ajNWcOpv4RXsbwOqkHirqKiiObKe4XGDqJ8uaBNItTSieAMrE0wRVDIqtvUigX6pAFFk',8,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (369,'KJ2TutxE0xT7ALVRk1xylIXONYlhic8K3IyKanz7HlnFQOqRP1rbF58nipKJAqN3pKH7FWYkp7kZOWdppuswXAUSLRY','Zk5UmDKV6MX3RCxHN5rjB5Yoh4kabFvTxz2SNipEbjPVWusybhQFmaKGOE1OmLQJm1ngUn5weDsRWa84ZsWt5',4,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (370,'4DVXDjZmvnEVr7kM5Y5mpkcLjbbnCbcToPm3d4drMrb3utNIzsZ3eyMESZW5DwsprEQ4a34mqJyl3e8LyI3qC1uE6doK03L','BLQWpoq2s0LWhS1BGDwmaOoTZHkqoYKUDRWKGeNsvzm2kYcwDsob3IsK8jNaAjF',9,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (371,'YtWqcpelk','vtWHD1CPSXPnlFDZIC8gPEgGGWCBoPxyBQ6Joz8JyF2lhJ2EHs0gKa0FExp',8,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (372,'SlFIyrPG3ZFM2Yr6FLL5c2retY5g8GQPUwJnv','IONSrqdapDLkG3FR1tvfoUIXo32Ty8CIKmwhC0ASM0Cia8gl5Hd7',9,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (373,'LZa4jgR1izzXKKt','PB1PWfVD7mCC2UU5uTAvCBdBZBNAcySpfP302nTzFzA7qCWzOEaGxuujc24R3Zji',2,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (374,'w','tVQ0mgLdcUB4GYZp5HKwjIaPePRZe0TuZrC7jAmDI51oPWqZ4uniZaAZqJZtJiiHhK6wWxiez6ghfBgcBa4YIujPdDdpbkBj1',5,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (375,'AwrZmGCKp0yGeyW5SZJSMBKHpcbIBhqMK6MFLLvBw1D37uO7SK','d6QO4z8RqIVfu7Y5PfqbtOipBq',5,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (376,'YhRN4WPtmzRW0seyO3MYdeQPWzFnMQmHIE4xa5EFUZ4Dcc5uqLvfqEoEXI4OSCnFFjIZz1Ehw5q','QGS1LPR0E',5,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (377,'bFybcOkMIir5Ym','2WSIEx3zNIGAPEGRz4UiTYQuiwI6ZGiz7GeS4OpXNj0BIYS',7,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (378,'N67BhmcDNkRE66qTHEGmGGNm5bM53r4xn7GAgIWAYQzGlVum','IMyLkM2Y8Mr3quSsXIiRipCHSoBLG10eDv3GmV5LXYjuKQWXIKtnEtHAXE2etAO8fArrU5vYGmL',5,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (379,'3SjIzJF2llbVYZ0MgM6wR1muEoHUGuSOAsErOKpfTgPj2KAKPq6VRRpj4pwF7zV','wAAQcoLOA8lqcgrByhfFIi5y1dX3bzN',5,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (380,'74nj','XAmUY0Nb7avzyxc3yjZyRIJKVyhxQGODCUllEnCcHka2RmNj61QNxJLJUBXI81d0sM7GX3skMgW2uRDVDr1DWJOpXFsrGXAagt',8,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (381,'ScxAuagxNk5cG4NCscG7fJWC8iMhR0XR4ma8iquAxJmM7w0Q2aGoDJvpEYF6fNBwc5DtIt5F3r','yAiQmxsvOhFl44dqkES2RWwpRYQ1Sy',5,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (382,'z1LEPIFeIp0yh6NiqBjyWm1hYqnlLVLHA7HPahN6VXEIBgKFGVeRAj6eamJZ0b1OB6VlQGYis1tFfzOtaAZpU','mjDu3RHbhPZY3IEfdH2kLF4cUw7cI72s7vRehn5OqmeCtDwUx0WDkOYakHmH5uwqc0XoJsPcNjgcG',4,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (383,'7NAxjLv8MXGGu12lv1j7nD326Ckj7346QbXhRWscNu','GCrLPOPjPnlo228tCQ5jWKMHpKJSPATogxVP6dy2Cv5PrwtGxy21Ecz04xSknDMw3g8Zho62AxqTi3pEx1L',5,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (384,'XjYUSre5vWcoJhkp5Npp2xFdvWqeSdkNVOk','FlEEU4BQoVDwJeRuQE7oDFtrFtyrlrEdsmpwjGiG7JhzKOMCRVoLru7FJXgLSFZhJs4yMgtkjNlpIEOfpieD0l4',2,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (385,'3wuS3v4sq6YNcxtwyKSBSfZtmK8Th18btK3npuQ4rLDMDJkJ8FFOjaTjULoOgTBYy2','giRrGcV44WwnLdX5GGdLgzTecJa7fd',3,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (386,'VFI6sysMgzO','bGLbdliqrdbJipZroL2IrOkVmquQE8CK0KgdVPJK1E',9,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (387,'QHxup7','JaGW2WUqx6IQCT7hWjW20838bJTgXvo2WrkKazrvxNNlzFZSxXoTLlEQMqxVCMM8ZmhrIsPl7oCHIFHOpFIOGlkgs6v3qJu',9,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (388,'VwCzKgX','FWhyYx7',3,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (389,'GHapdmr1ePiauLNfuL','DZkCinAMmfDQQYh',3,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (390,'za4BDxSrR4Q','LXfFeGfSoaTAV4nDixDX4spGRUVRZDWuwfzHYpkuseA3jVUJH7vtBckZptGiHQ4Lydhx',7,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (391,'UbXHXILUehsKS4wnH1aOPZhY85D','egLtpsiEE8RQesGkNwaFOQa0qkTPMZWwRYjuA5Jk0l43U2JcSUK',8,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (392,'RBivkLetH3ubL2CQSF4NFvIDW8dCOuJvnyGs','XlkgmmR7DbivBJPIQQ',6,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (393,'vhJqgA4qutjv3KoP1wE4ALgKS3YUofIVhxLoMqsZ28IZqrt8dYriIYRQMbrxLsdt0kCuMhjYlVu6uzovX','vfmVDhqvKXmPf2Vy8GbwwKYhgPbgxUom',9,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (394,'H1yQViezmssjWe4bw1KhKiXbBeTbOIQXdsqg6SpuZFJ6i2iHQVoLSe7uBaRb0AWFEcCUhEuTlA','MNx7PtQqJECEDX1joKfdTvGxoaN7Nzifdx5Hon6OlpGE8fBI',7,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (395,'FL4YXDxd6i1hLXHYZtHqr7r3xYZLNPoNr61IxKeQS1z','s61pbNiGgXYF',8,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (396,'jfVcVtr1IDVHfKTxglLKGy7dnc2na3GXaSyEquOUbYk','GnwdhtOdOsDuXrUzLxEg46VkeiF4LlwAYpr4y0rljQPdW3SDvmPhzG7YQfIMQJxktCxOwWsksaQXO',9,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (397,'rDWwU4RFEcpmelOauV5hi2CBnip4hadnNPkHvWebbf3jf3kRmSK3bdPWipTGCsqnFxn8Fs8kPC4Hz','lLhixizuqabP3MpeKzQYlcKRY',3,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (398,'cqWm7gmZdXNWM7zjXvQidefXWW1ZeODPKej8M5reXgZzQtdfPTZSXd6VcEo1ljiwich3IXrHZ1Te8kydhVttgILLm7gyPwLcJw','U2e0zET2tDPJbSGh0QP7uxMxAVZ4nbgiXf6n4YT61OxXKjSZ3CKOCoUB',9,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (399,'ZqvUwRDeJN715el5','HlVFgf0BsgfbqZMLs1ygdrAiGSiXWD0TiOl8nlFPpHcpgBlEvnMMRyx4FCkMd0yGZz1bbwsKexadVEMMBJRBqYqoJWfKB',4,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (400,'N4causf1NqILYFJWSwqXwwj541oODr0gClpC3jtMkgca2VQMhbyjohTJwefLXigXhbpAIkdF56YlieuTgRfPjk','4Ptjwo',3,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (401,'FwHKUSuyHujs5e6OzLgTxYjdVCBMsXDcujPvH5duwIuC5KWVEMjp7ePRuDbKIc6UvzgKJmoxJG0vk','28rHt0uR2e7u7vrwxbFEyh27laWHTdr05JMfPW4zEYR0VaWMeTG4qZ3oz8if5ki74qunouqFXO',9,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (402,'le86VCzsHu7fGjrbhu3IL6Isg','Q07NFUq5Mv5wV0UKkjtfKe8W',3,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (403,'tbCTcrEx1HVt60DTHxtnEAm0GOZlIfY3nSsWO2SJFiJrvt3qGngl4F1vFqJoVo','zLyxXcrMY4rSGNpWa2alpl2Gkvd3UhMB',6,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (404,'CakHBGWhNNVEO562vnNuPEChhETZLhM1WKxL7Jr','PTaBP1b35j6ASI',4,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (405,'VEye0FbM6HB0cFpK7NPsxDIuVSypf7g655lwI1BG4lT5S70rWYCN5DUc1JpBugJ0JFjAWeSm','QAGM',3,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (406,'dSNBGZRz4QnNBhGVFc8lDu6yK','6Z0BFwswRq08HR6PRe0mHOIl2t754kLhpl8K26yipz7at6hCz6Bm3peDdJcnc7kkfXUlR0GuLFk2Ymo7Ajotdrn4',6,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (407,'Qj5yEaAbfbiWETdC5601CMeJ4DleK6XSbJ','TtJ5hPup22wnWbwG8fJv',9,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (408,'mAuYaTaeHyXPW2m2wKI5YKPr6XOdHBQ5ctZdqgWaPdfCX2lK5f','VFoFk3RqQcyCpVyQ41CUu8sUvkdyMMaGatw7K8ICTef8SvZyd2QlxGGwuolPdWwtQBmp7XFXF',3,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (409,'YEEoR3SzxoB6uWD6zkEU4dcCJvyFLRarDtRHR4K2CtoDMxtjbA8HzlWx5HiVwVIyEQI1B','fzh8pyjKp2dfSI6XYzMmcjWgVDKHFIV2AHWpKYH2ATbq4t',3,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (410,'ea043Fv1Ul1xCP5x5n8csB4ClrIYCA7LJ4Z','6i2rLOFDgjsKgACZKDaj3',4,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (411,'dtjgS5oudTDNk7UO7hjf87B4sFSne2vN4gki152df2PlUELlf33apCxlds12ysiWR','nV4eAVeLxrlLNIqnxuI6g2478ToMSc3vxz3lA1ROHjdzvxcs',3,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (412,'4g0a221hJXpbs0lNzXadAhWOK8Ruo0FCK4gwN3PVCZhxlBaQxmgzTiZreVRx','xDiCVJzr46WPJciqlXMdnusG7UTHNM2sH3XUcFWQIVS4hRbhRLDAv0TUQGTRFqEoC2scMz6T1EAplebsUCKyJvohPIUKqVbz',5,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (413,'TRU6I8wLqsSJWkPbtHrs6i7lSQeubTD22bFVOGNPCN5cOF5WWc8pt1M8XQtOucjbuB1yPNQ62MLKsH','4IUrS8FdStnJfYzSBfocIWSVUagdCVVHrCsmkCT3lWG12yOZI',4,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (414,'3PpxraSGzxXMK7XTc8rEmXAEGpICkWvAAX7KHwfOwGK','whkoOie1om43EaDUi',8,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (415,'Drx','vkZSwzLPuKGucRSWO0koSnHGhztDubsGqiYoGtexkkiAPlyXxWLHmw2JrG7HPjDW3eztCzWmkZp',4,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (416,'mJaJtxv3jlZhcDjRtoyjc6l5rARl5GnXkmsmc3Bxds2Ebe71suXi','kapuy8CqBP7th4dXq5FaSBiUdBqhs7WGUzYNhZEyzS5wpVCiUFwTftwoNV1SebTESBdEabRxHWcu8hRZ6HuN65aPZ',4,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (417,'MlGrP0Rfdf1YE2yn','QRcH8eohCkNzUT1lYr5RIJupd1TQdTMLQHzshjbYhGeNuOz1Ow6gVy1BfYvW1SGW6syD35G2soQY3wWVUWxEAq1bd86tmR8sfn',3,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (418,'hpmaicLeuWfK4Jb7MZxRsfx5CaofXRSDZZ6flHjA2vpLuxrMXv8grftINLle6s7VuLwChksbjdU2','F6KwmLRAZwHXcwNAQjLPBelxlo3UVjaVN14jFxE74YQeHzqZuCaCcFc7kHbCt7q87tiIYVRnf1H4E3Uy8foAxFQH',3,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (419,'i6bdwgsaejVsYcyYSf12KV2xbuyefPy1ajZL0UlV6aKKtotCscr80i7UCg1Zf0DySSomdO0WArImImCWbpOBMlduQRvTfIVe4m','ZJnI',9,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (420,'0qjsoYpmzwMFl3YaaXqF7CBYL2OcvDdzD1V8hrPpySXFGbo0DJYe75Ft8awEk2G','Q7qGrDvMjKYVuKmy0kzP7bWBJ1snEHT5wY1QA8prSx76McSE5gDDJpElDs51IRzGjolxVqk0bbTkmQaG7OPxKRDSodA5RI5Ut',2,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (421,'ZV1TF3aJJXxdZkSmJPbi370PFv7W8nz3vWdbVW','3Iga4ABuezJKyajsQkBmRbGgCaJTu',8,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (422,'wG1RcajS7qjiZsLqOHxxsZ6dFH1j2fsUBlpxDlkeQks1k0OPfSsg7xzf','hwtFgSqfDZqQapwS7oPc2rZFQRTHy2Jrqik',9,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (423,'dxbisAPyPhxevzBQ1oJUHPtcSa0jV1i0bjMxFWrSU7WGGGJ3P8','CHv7JtZW4xwQh7I2QqR1VBJKnWM0ZynwNN7Ru',3,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (424,'mCta2mxgMmeD1L0NNlK1zqgjSMkZnQP51eNRDv6Gu6v8vqowV14I1FUM7bVFqqoevaXlciSLpZbUwfxL','2mlqvYzs6dF81IzY4ao1UiRZcW',7,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (425,'d7uQtOmVI62RbrYASXIHVFLcy8xFtFKwzSZmtyg7TcQxnriPlEXuQL8pCmaNINMGTXEu0','EGaNMjqwOxb4JAT1NQM6xSfDHnXNmYzg8UFjjIxtEsng6YVQ5yJ2dn1UvSKsp2FuNgo4Mpn',4,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (426,'UEngwV5pxsiMoYeLVnbjQ1mG48LEicUiI5WNdGaTcDaJc4ISqWBXNsVZbZz','WjgTZw0eI4tRuRUfphHZP8K7oTRt',9,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (427,'zoPBObwlYzt3hQ','mbY1IiVtkjSnEPUVbc3ZZuPSIXsENRwG2mCE7Ghvubh3My2awMohALIxUQfjrOQLXENfQAGCDmM7gSUQGoAzWjQaaAEgs2Xy',2,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (428,'TyIca8nWGrTITEZdIaRH70HuNgZ0K81rQtJO8t58d8hfIEgHmvPRJQB3pi3qmrMzcY4BwazVCZldMc7RBBAhA8Fa','jEMDb0Yxhsj45COKxYQqWn8DPCOOcp4dJbE3pXoJiIElNmuehQXrlfkrCRmmurkE4s5jMJz36ycLepnTPt1TCYrnTts6O6Oi8q',6,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (429,'hL','LOYNiQj7HDg0rH40jddRT5OyM848A1XiLMguV3Xgm8lq8weMfXQE6qV2',9,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (430,'svjgIFT62LMfVZItRV5a16hUd3JrucbEssSamRMUVoBNsaphj4fhoFMCGpOm1UQmiho6mrYmRxQdjiRLpXEgZNq0xuo7WWOZON','nnpRZWn2BistH',6,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (431,'BePtlKKnaANtiZna0h1ztYKzK0BW6ztUgyIjsP8vHDmzu4S0bVTJB4c3vLV0axs6xlimd5KF4vefK5sRlKxsv2dGt','RT2fz0QD1FCzmgCGBFap1hEGnjtTAM7Fgn8HMWm1CzJ1NofLXgRyp0kas',6,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (432,'XvGllpIMQZCztwW','nlg3vUmdIVDAI8jFGPH4Z2VteR3vBsEJtopdf732eOveeUMe2wpjwPOqwgBlL3wDf64IKxUVSXIxX11IXs5TsvyM',2,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (433,'hk1d4ezNI6vseojCUeGISHkJykVWKfjUyKvskZIMawSeA8TuWzoFVuB2kofnTOkBd3UYnTabNYFtyguU0c4FHfOypSw8Bf','5M5wxQMaoRh7FMcMJbifIGM5gNdrf8JdOTaiqTc3N33g0HvcJ232UoNZhasjC1y1L5xCyXLoeS5dT75atIcEeYas7MXCrNr',9,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (434,'OxmJ7v3HNyPjL0CmrHh20fk0BpLMvxP4KKDu7vBhpB2oxYh','RgCiKLFlX15lksGmrbS0rTaDbPV5f53NpXOri',9,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (435,'ZnN4Qg7uLA6UfOA','8KPWY7KpEy71WVOF5UbIQQ5qlNQu5zVivISee3zsX0gy3XitnhOc7A8U2UR17PGZKVo0NRfAlvhlhrYcLwTnzcouE',2,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (436,'dRTXvBHOJcv1pOR7KJAgB2HpSKCfYozd0cz3X3pQB6pOXL3PTnw7yreFYnjIbWoM5','gl7h0ubDfPZWlE6jqD20fn',6,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (437,'DNQZYjdDdjEcGWVtnJrFJZMTfbJmmlhw1VjCb6IOvuEIoIMJ36BaIXRmGFgXjqeLbUsFo0y2sJn8','GcDzitwqTYae6VgMQS2DjBjMo7rk6uZoXPpguVLipho0DkgRvdR0y3lrYa7Uyrr33dWeGqOET4g',2,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (438,'AGmmr3crMzS7eDvbXgkG1x6Qp0SXw02EAghAwW','SMnr1gTVbz7h3DU8q',5,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (439,'qT4uuNjkOJpfs5X0X4kb6g7RASW5VKcvyK8zZ3iCNXnMP0Ohjrc0SHcgmxMf5r00fTktc','Spm7Z0HNMOqrhMMa7Hf4yJvJkQsRhPTISR6sMR0Qr5lnJ0HGVT5B1ODd8HxY',4,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (440,'p61RzX45uXQYRqUhSsvGiDOULPdfAMjf2OIsfxWbeqgTtwKkW2lbdT2jw4df','zm1s5tOPi2Wzf0OATPBVU0JyZuWI85Kcbe4dVpykOXFNJiIGaaMucVi1XDqfn7x',4,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (441,'hEe0aI1Vu3NbfKkfwzvBIQisG8NCzesXXtTU3nkelIVeSXRDkozWwtUI','BiMCbznlc',3,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (442,'k2fYMSA3tPNa6zrQtqnuWvc1apDBZaazTpz30hkJpbGTrlzLsXtznzyXRRODSxUxZ7GqKsgDAg844VbFFnluDKRhZZiJ','MQysN8xjKzpqui5m0JlQB0lC',3,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (443,'tEA6gqdpRGAQf1GVBYL0','PkBaa',4,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (444,'C1E1F','HlKcyHHoaAUy8BsiIkSzecmWMiwOLZNAMgoGuKKziOrNoK3Oi4CZlyrcKDlVRH',7,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (445,'Qjlww2JgRHIuftyYKaiZI2l8S4fcyYoawDVIy1OYrixrutx6B4ezVBtw2qfDJC','RXWw0HdUD5cRJkRve4A4WMMA4e2STW7br7KZaH2QhgcXcpZgEce4Q8LYl3',3,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (446,'eohWGtxg5fme0CW0VPVNnPaJgOolcsDfEecbBmNHb2IvmqAduDTOrKgGaUV7QXPcsMUT4UVUkUEslHUJGa4fGRNZzl','SbRR4Z',8,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (447,'TqIG','nEU4yP7Ax3pnCtTNt21DqhyrppRK0FD',9,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (448,'GzCeNMaLjP2UobQvl8bV2bxB5Q7hbeMtFc4nmYeBhvZkc6Cenmw1mg40dn3DbpOlWExiEg8oN2kSGtR2GbD2zl1Z4u637','q',5,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (449,'LGB5KVO','nxT8FJpx3CiPMNY2dLV0fw20xj7jZkmlULzZB2i7YFr1',9,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (450,'HhrXmuEpTolVVXps4gwiHRBuBjnymFAQTkLxLSKyvHhVDwyPTnUWhY27mDc76FmOMDa','zlDYU2gqlsdgsC',8,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (451,'Ej5LM8hS3iyHoJxqpvRDuJye7eWePzHmAkaeXqkv4LSm0soV1hplF','qoB3PZfxmq8vMqGmcCuRjC6qQ01jliXa',8,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (452,'8jbcHczBLdVf1wKR4oHpXM','X1SIHiDS0TJ5YBfXEWGDC8R831BwY0i8PGBmAwkAVctY2ctrZUM5ZmZgwBtLCIXqfno7wvZJtaQUz6unGvJXi',5,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (453,'BpcWVUpLJYocPu4M','KuTmpOBjAvhn7XZzha3L4sKekycCZbksNd5HNVcWbzVFoHjdThzDyxbNljtGapJPDY6Nv0q6xQKPQMzH8mG04mUxCb4FplQc6EX',8,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (454,'CsBxoROUmZhB','wKTLRbFLD76yOzzVVaPCaVz4tgFmVonKGwfrIUjOZkXZsrERLI0K38SadgWurs4BNJglDzdW0vEJRm0CJqwgTzYKy80kWjKkfOSj',5,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (455,'UnKHy48RY3J0T3Gto1BpMt3ffqeJOio','YIlMA1oTGiye5a8b6vvkq7E060Zf4RO5CwwLIxE2xw8thBBEv2FGZddAfIPcxpyCRqVgny52W',7,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (456,'ZLLv4NHZHX7T75RG5XZqLDKSZxNS8cWGdGgd4f','HoODe',8,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (457,'74q3mONAFksoml15G2Kkmp6se5b','dZN5Pjz7cZHG4hAedHxR0qTh2r4BG7aan2l4nBusCmCpmTMexsAqB5P41E2iqSuJu7l5x0mL',8,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (458,'BoBUkrzJV4Az45sONFmcBjJoUy87z','OlTuIGwptscONKAsTPKFQNYHdumYiYwGaxHajhy2kPjXaY',9,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (459,'5tKOLDE5HQMoEw0Yj3lNRgkbFLavu6w0Ao2KRaeokYZ08ot28ZuFXClSB','roofA',5,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (460,'tz2zHQKyM7KDYl5kA7FWKcDF0sH6RxWfdlqS6DvBUXTZzEIAvGPLPpGmV1nCjbznxwho2StQRCx','jRT6',9,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (461,'OvJEb','UygMpRmO87CmNoUQsYdiRbcQWsEcDOlVhcYPvByIouml2CJowO84uevfKBIBFinn1npkp3KtsnwN2Vpx46naLj',9,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (462,'YFkaXxXEanPnxVgDlBVlcRt1a6PTKZuJUtmvScvaUyYrL13Qbx','r3rJ1quJxekeCgIfrEpgTovHVz7Wv1LJWDIu4Uf6UcCz6HBfs8R5125SHkkJ0BDfTOWHvcGr501jvnMhceisyPl',9,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (463,'qgJ2J13l43wIYPPNMec3RBKMLlqLeBU2vKTGL3iSbKeVKFozU17Y','QkQnu2hZ1FiznAcfUM6Gk1tBn5DmJaR4ZgJiQ5GGKBE7',8,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (464,'c22RY4CMlrTsph0i3kE2HXTmyKJrhSE1Al8DLOiD3','sr1w6RLlPCI5iO3ZuMuSwToc06',8,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (465,'Y0l','b0Fb15drAmf7WaTtVIRWumaBxwcOX8Nw6vZNhSoPVissyT8HTIBjvw74nQwZXQHuNRXpAyl6',6,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (466,'NMwIpb1Hj0MAIjpp0LqOv8erCX7SS4Ih8C5jwjpJTow6CTwu1q0WgrSQZyM2CTqsRR80FXKSLtai14rAs8pjxuin','SeyZMjlFLjVBKj2DqlymsBzJ7K803NkX78Rdlg2vBBe',3,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (467,'3vM1JX8HVVgwhSJAK','SkA726yFT7limczSSnV4ECv4xffDktkeiGpMQdJLpWI6GROxBOPNsW2vT4ZLCAQvsZ0GarDuQZsqa0mawfGnza',7,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (468,'twtxdCMAWyUD0Q5SvV16FMjsmQud8gbnK3SSSlYgQUoZM3ukWoxQwo1a8Y7QwOIrQpO5KqrHukH3OczbufZdv5F4luWT','uFwlMHtUrDBTmevUiBehY6cRfLywWgLTZP3Pvb6aK1OQ2heXaKVu0Wpd8GkADaoE8gL1RLKLkCZRQQUCwrJymx',3,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (469,'tfAfRB3l7wgnKksKa8F3fSBCs5Dn41Oh73tTaton','uwLR63WPe5yi0dGdDzeTOM6EcFhvx3e8TOKC37pGIII7PEmuQDl4cUS6yJ1',6,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (470,'36OkemyiU8fcWFZ0w0UitK0bT3lK2n7tQJqgNoWaVlqzPNvGjrVN6aRhtw0IWPDk01W6iHl0rWdyMzX5T0EnCh','UzwRBffs6s8',6,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (471,'ao1AcVBnr7a1QVaF8C620pxlzCVgNUCRYJF8JyGd5crxN83bzlIJzZTDiJvmTBinXqUrdauVR3g','77V6fgQJ5j77s74',6,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (472,'vjlScUKRyfCpMbZKsBmNhR3S7UrBoGDcJcPZPr3F4szPPBzDzoTX2mvMuDZJTiKHrzAAPMRuqBsAspLD7d1yk32HNmrP','BjjUb2LxGG16qkAuPeVa7JRdMfJmjhBiKDTPLXW5qfPhoCvm',3,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (473,'x2RSCAtre4wywi1rTg6JqnWlqu51sDS','apmP8BU082fGir8sCsj',5,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (474,'b28LMGy3wl6WxRonC2fJBSNR','AaszxlzDYbExVVHcTYPf5nOH3kuulVtb8OnmTiSpwIdwJ1EaEBFCL2UzLHQXazA',8,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (475,'uuVG0r6zaXTMN2SkS7Exxmz5HWM34pNWzNpUSK','IZYVRynQ8UQRSkIxkxIZ8JHgXstI3oR13lL6at',5,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (476,'FVOPoom1rR1Blik652erbKXtbaJz6eFmCC7USQAiVYJf','JN8fIX2MEM3DFqCeKJHZcgv4pWECjDzK2qNQmWwX7olMArLgowIa3jpQT48hh7N3mkoV4iXEz',4,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (477,'517HgUcnS467knS7y45C6LdwzkX','pqD4VxAWVglhvYZlirT3bpvfoUkpsH3jOT7BNPnx7WLQsLOTc5ZSbmZLZGxlW3AbP7CgcRS62ttmvdOMfJbSHrUiA',4,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (478,'B7b0uWTZzRXEaWdKYn1xPFE5Va3g3dw2pHHmhO2','Zp3E3HlFtonPY7X2Krmo4aomOZ7On4XwBZxRSlLpgxTsr',2,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (479,'Uqmk7OKf6pYEr5lX4VIqNg7TZbAelWMHY5VqdAIFIBYch71GtecfVpT8ocVgDWl18JNvh5FLH','vBbimk7yc4VwB0OQMxm5rHJz',9,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (480,'3d6wFfkqMSU02duKhhPLd6NqlhdwO0YzGivlpq2DtmRbqGDeGIyqUVeriR2a0J8mHZa64Adv3jbBWmMFhmj','JYv6Oewh8OM7dDqnpmlqiQFRJuZoCVGLXNs4GvS4wiiC3PBVj5cZTqW00085v1i27W',5,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (481,'O4JUYE6H1M1SPuHV1TNvZmGiNEMui4S2OsTEgP4kV6B6ltcmXspVVBLjxnqIbbhCsC','yiO0qRayE47ygMCyNTgtlWxvUbKoMZ2ViULjKfo6F3IWbSjDJXLJRvE8N',3,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (482,'KVQluUAsNeB54ZW0miidqcOJagXiSjvaSBnbC3YjxdhD88UNMxDQ3G3IbO1XFElQRWI7oRd6xJ6OrO1S7u7oKYY','zFhxZE4Q7WO7YdjYM',6,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (483,'DzBAKn2gd3b2l6ARSXeTiZoFkACoqlGOpUia4KaKx1DanpJn','olug5oCdnlDrCSS0wm4rlxNZP8EBrpqWfmSiAOPGhfqMuzBjyKK4aDZIEsjQ70XD8JTAKNpJezywbFvA4oo10fepcAzolpr2jS5',8,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (484,'O6r6jCMb1E7','ZRoVscfR1YKgmKX1fzpEVOT0hPO62OFV4ClYA4H2IiSSuC20SK',6,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (485,'cjFtNifMLLjwUpY0l0iCcEGX1grQPZBSqMsKe1pZ4HsyUiQjq3PaVqUNX76cwq7VQEO5eoCA','VSm3lrOc',8,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (486,'b33KBj8ZxltjaIveN6Y','05wp8xIIx8zdZBVwon',3,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (487,'HNk0AACkQcnoYD8IlWZ810o6upylaICoy8hlbZVao0SGtDYsgOcMLAS2jJEEPJ0pp','XFTBDLhoWRQlgwi8GD8fo0PvB0ma3cwtKH',5,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (488,'sJYu7JkiwYmnN7G4iex8wheHfesgbgUcfhiYPZjZvOOgWQe2NK60neVlIKEouk1YQFxjZlfY0ahdfApxQOxqePdJofe','aJASXB0vUySgArBQU0XSO1C',7,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (489,'zDbZCdS42onSKmw5YBw07DBPtx0oRz2QQiRihahUiznsHwgFO7i','iEBXLXdOcl5rPSmSh4r64g8ybjULVk2002haOEya8IfMRQyGhMjEVQhGuRVOE1R2oUUHQSGb1zYA',7,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (490,'5tQpB2ema2RotDj6NeztYsbv2','QgvUgW2KFvVzfjoKvS27qFyCbvBpCMFLr01PaHFt',7,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (491,'FJcn','yoMWu8k0XdEfQccPt5HeiPJXOoCo0BFpY',2,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (492,'qCffMMZd1v1aYDj3C7q6cCWkKWxtNv31vk7nWAjJzfEJDxLauyRHG3dqIa5oVzu3yHMHdSF5e','IvkZD5stLsBA3UuRLlsvnt3FFiNvPvKZ4iU5SfmVbGqMqZnbtcz20AbJnRI3H1g5e',4,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (493,'675j58gXrKdqhTj5JCdsho0W0X67DqfjyC8zFw4nlSAsdeqYRszkSMnhuX1TjvBpETxSe','H8X3O3AlHVrntuQEcb14u6LDpU2Fuvu0BTsKbieS5mWejaljew2dvv81H6pnz5YZdVCxZQzcUQGQAaYymdc1Kbdg4',9,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (494,'MH0cFpQPeW3hhGZU4rh820nUzJ1RlwTaLGrkGW1dBSJ7FzNbnSA05RPUyr5wx4i5clHGQdNhhgiG0U','zJARJrCQZkqSlFk3QHrPGxQHFU5SbQtKlt',7,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (495,'KgOiItpCS5CLpauKAiKmYDhbKio333N2LAGWNURFnq3ZRzcXAiwc8DWraUWKILcUKzyCffjPuKGrFExAN1IbAuj','iFKsgJztwTagkbAkunFp7',5,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (496,'0YhZUeq','6su1ZkLWTASNhANXa',6,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (497,'sQDBOjrQg73J8mtlvUg6bzVuTLv43c0GMygXAEbxxe03ygpvzRuZ1QbgSMslAoIdBBr70WZV5ITxgConnmseKF84kQmKj','GY3aK',9,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (498,'cKshIemXmYyuh3laY8afxKzeoIAzSLULPnrUM4F','4yi4yCvXzjuKuTffyLQb3TyWtNHGlool6stpR7TKHZG',7,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (499,'n2e24gCvcQ235CCHstbcCGR4h8tG','LGtUAAtbsEfYlPwA0ZdFz2hsiPAXAecLkxvjVowFDVusk6K03CC2jW8lS4qM3Txamwr5O7AtJzoBtoq0uQS3eQFnpRbxcvPa3Q',5,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (500,'SEV2yrkvvJzotlfZdlqUUfzGUIlo17ZSKyPLcCF2SEgyFQ51UgZJ4KhW4y1YTI24TFqc5rNi7okv7vM3n1a4HgF26ILVTQiYnz','FOoOTyKGBN0tYEvcRUn5fsS',5,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (501,'VJXCUYPU6tcaicx4jzG71eDCO3leob5421kjVMSM7it64wC4gXJxZsg4Qtq','bhm0MvN768Qi4GzImZi4JdxNBehpUS3phuKxFoDrktBu8Tvi6tP30PLebt',6,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (502,'gFgwScIFZxfJqj2b0xj1n1Jix0SJIasRnZmKTzQFa0KpdzlYFkDARzhsWQU0LBc4MVghuGzoPKbol3A7pCCXN','EqFiBE8ccboPqafjepZTIasmwroO1jcE4QAjQprh6JXz',2,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (503,'Q1VLzP44nSj0QcU1hnnoyECKE','tZtSn2bYh5IYHfetuxpIUkt6Y5',7,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (504,'Krz7xCkJXnwIM8CVXRyotCaOepB1zwbIwDGDTUlvT2Q7SBJN3mANmg0CVdYepm','NhuoXf7ENREpO8DegceBQXWHawclIAGYmCfH1nPmsHGkD32USWu1W1lvfQ3sndWQrEgt5h',4,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (505,'u','Wt5thu5NBM8hOKzASldoiLwrcsZRwQR',2,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (506,'HaLWU27wciPexi6fRLEef86MyX6A1ySHUyfoVO2kl4CGSNqFWJileaTdR0Okzfdi4neeliQ4bhtVwOumaUDm3Hy3Y','hERHQBzfoVDlLEYAfdOoSl3WWIuZfnG1ysXRCflv7Fhla',2,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (507,'F','zG4ybOWXwHmtGtTqAIPPbUvYBm4Bjge1CsLg5RR6GTeYIkAm8CwrEzxG2mT',5,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (508,'Pd05rWaIDh8HnRVKPYkWLOxYMpzlbBz','hfiJb5soSNKtVPJsYeDFLloQtPAEqYNZMvs1saOzS2YkvftbSca',3,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (509,'sjF8EFvpdFaqhOUMLhvTJE4yNSsqQyZZRjkWiLkppmucbVduSeGeetEMeJgqJWfdOZ1hOkcL6gS','Hhq4XbFXvVVTJmsNqa2Kkkg3jq1VwDrcbERmOIAPe2rfELSMjy2vtbDs8gbj0RXzIi2d8Kl',7,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (510,'da7yhdfuN4mNa13OyrteQresnO65bPQtFG0i7bJrfnFqovGcfjtufDaqGnfdTMA','Z4YsKpVqsGdVHg',8,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (511,'UprBSLpsvd7hONZ5WH5L33','EpkGAqQzZ5cq7AmOfoRqBVl2MI81aDWtuQea0qIjKuC7lTBtcpui0n4QViQUzD71E0rAV48YokEI0Mbb85UeuilHyMl',8,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (512,'eeoCOROFywuEpEkzXo3JNYxs1wVBBbq7NM2iqcbGeUOJ5MDR3nc6ZQeA','rmohpEJ5YAQtoWnQMytMENWy5EsvT5JRFOWrbQ',6,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (513,'Ig3YbvjERIJ4YyTxGTLz2UbRBrtkWVMbKat6c3p1KYKsDdv5uhmuC25NjMrO6DF1GMcV','d64O7T5YfRoZ6d3p3qANZq6K5A',5,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (514,'GhcaIL31KUElHdht6qqmdQ4bkHudmqHB1JYno3tTiVC1fAqlyPIrR8hUYP5OgiyycoMxmK807tT0kRvI','g81AcbAZVVcQQVHHxYKOL7js2YQzMCLxDZ4pxLUgmPNF2y5yjLvtTw0NWsbSa2pbIhxoHTavjFCv7IPntHf1Y',5,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (515,'minbGmnq8k2iSuFM5GqI7SppShldRjcrDUXBlRWgQrszBNXcMm16RmErZUe7BYr','Xs',3,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (516,'hGywa3OSYKzFiqQFoPxssayX1Pgatobxp4EAbWoOMUNW05WlIHFWfyflUnw','GwPGpNtkXEYF0ol',4,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (517,'I7De8Nh75AnpppB1mRKSWTACIhlRXYFAOSu2ycUgz6ZroGvP4fTGNDr6RHY8no8gx2zWY54YxSAMu1fdV','mqqdm4vyGaEqyZDiBZmO8iUP5MI2SkHrkplz6xcUCIErPZEGsfN3aIabbhTriwmcq6qBZ6jYEPvYREw1pKBEJnouw',3,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (518,'hevOKbjJZDo4UA0tMJpEQlEGmilDZyEvWNXqtDyIXJ72SeM8mu088g47YmtRK8K1','faRu2n2gmyZ4wRsvrQDnTAxLu8W32iqM2kdhkuyTmibWly7UIkbw4wxd4dwqezqdHCWcM1brr',3,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (519,'a6vB0vHlYxkzzg','ojbNGxADSoBOn4ATfOu8gSJYcoPmWTHyva8nuHyKUikXsT4WGcGoEqFuCL',2,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (520,'P1cWrhRIEPUXEP2OTmy0gfzOYnf2XvefJso1ecEH','GRV5yGxo1UKChBZJZk7jVxDvpjmMj4NvL',7,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (521,'bRgoTVY2suH1YiaTwMIVKcAh6Vz8EN6tAgXn4gtR0p73mfVG','SLq2sNdMce7wiZbAcjVgWx6EWhbW4xI3p8AKLcDrzWHIndqce0lluO31OdseJBSPgqjRwxJlYUQ',2,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (522,'UujBnpzOyyASYJrWUiqAwbhdWCbqq4CbUVZuxCYBvAxvf2ZXhSNrIQ4AD6iTrPKtm5a0kE','apKlUmqbm4q0wC8T7u5qWctw7qN6S76QCirOI',5,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (523,'QiyLNsQemSxVzqKmXkpMRgAQyldliZA4blexxnIag0R','bXON1Hz1nAyPotne5Dldtn11xl5bRS4d2YhMjMF4XImkYrnn0qgHEXljcVyljVdroagdUa2pr2EkJ6Yn3',3,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (524,'xxeZg3v50nmNV6IcUfJQ3cRdTuouD8nSVHYru5lME3JoDIv68Fl0szx3Ecz','GA6Ngk4WRrIGoVhp1eOszakOZKjfUOXgq6QgpEgHOsijUdeF0NPysuYZ0CwXlAicCAZE38J0fEeAJdNgq',3,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (525,'si4WqbkLgZ4gKvGVyNb','fzGwNiv4WcuCST4ytiOdgVONgkS6QneN7qUveslxDPfzrl361rRYzaKrV7FEpW2HTpn5VyouCYrrDEv4T8qCiPDFJWGgM',3,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (526,'0Tx7SVhMsIu1poEfZaPkQnm8gaiIRiOLapImvr4WogUBMcJIstNv55cnbgMX0lx4gX64HR','4bfg4gYbaa401uwUcmTqmIkP0pBxfFTpzTfwoxn5qP',4,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (527,'sgqmao43Cgjr00wpxKcPWSBbanolPPer00s8yAiON6uuUt7MrBRdVOC3hW1hp0YD','4EfDJxQN6UEO4HyPk0EGbzHRQZv',3,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (528,'rLLSlGEs4xL','KuApzweQaX5lQOcZ0pvg4D5ngJXoN22lPVHIm8U7YWyH2BdljRFgLSbwBfiqqcwHZ1dZmejaqxKVf',5,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (529,'K1gNBXzpdsSW6ovSBbokx8rLh2ULvi5U5mEk2zrB18Qx6','kPNhzHOqOgxtE6G1xSwRk0y4NNZ2UqABZ',9,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (530,'54fUU6wKF8ClZSygqywsGIIHyaBbw0x3apyGeLViKn1Q5tu73iPUhz7gz5Hz8sCooEGOKAMok4lCpAskW5fp7xRhLh07yazV','SOL1K2NLDhZly2usCyhHsZcRmBdn1p',8,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (531,'O','Yq6ISqigjUUnQ53GGL17CikrpkRFwZxmLS2',9,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (532,'COjVustu','1CZBGQNyPIRlcpdClmDOCRfJgif5NnKNpTOCRTMRTSCyHahARE00daYKg4czJnW0',8,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (533,'AiCdr6a8xznUXaMZnPzYxkBxSiq0JgIxmpmpi2GLoHTD4fYCTmvLtZbV6s1v8ayIvA6avPxGT4lW8HRKHbN4KO8pO','UbQFzi1R8td7Q4gln5j26UovdDz3KGNBhbK4q0b5RDB3clCFzPlOCbygWvJLZdFYhjXGSBcoNOo7SlwcEf5',4,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (534,'q0IWNQbQ2FmBZaskbXY4G1ovmogkLi1cLoP3NhToWmGzRmnGwQiDh6LVnTmHhO1pUvNda0AakQh','WJt',4,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (535,'YMBHKQFqXldAQHtIdpqbYyE47P8rBjOIPnYligUKmfyhEQyeI1SjDid0mu5bG8kbSGkDTuwJBG5dOsKRHjJbUfaJ2DNjulh2p','UbN40OcFuewnPrZyRIKCBTdeUa',9,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (536,'YSL8FoHvZEIOsAZ0K4lksBEMWPFKrCKmC7IA6CqD5C2Xnm','6jfA0Y1vH5BxCXFAtCmXwxWjxaOmMwYub3dqaZiATkFQvQORGo0zVMcC12oqsWGc',8,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (537,'1WjdpvjWCLPendelaegKp1igmr','qeuvjzJDeelhEQkMzmoI2ywWsRpRjxjFrtEdtIuy44TEhqVIXMNZEdm4aG7T55Tb1eW8NkCyYy',3,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (538,'d','61Y0zoI34NKEdekZci1wvJbgSZvOxO1r57Hunst3CvKlNCQ1hND1qTqIGsn0VJmMq5LJVKbB',4,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (539,'MM1a8oLLv','JSfFFZq4B6uRPus6rf0P6FLUPja52oSuKYwFr2ZNWz6ilRXZTpeCFqwh2Zi48cEwsCtefaZi',7,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (540,'tHfQeprkbvdEIpwDecinpbD6','FCIt5ZwglCw3orHTdMLHwLngBlZRXd6WDG6VK7R',5,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (541,'dYW1','iWGCV5mNyhiqCAN3AdjkLURMIGS3a2ig6D7X1eKkjZfmV1L5gdE2DwHFN8E5nx7KC6E5FjudowkkPxacWYSc8ZAABEMr',9,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (542,'Bq8qnIkja3uybP5Oz82','vVOXA0S4yxEdTmRqmSZcOHud3EdJoYYXheZz6TguWt23TV6Q47VEsah0lumWQ6CpyuiOndKtagYyGBUp',8,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (543,'FKufp1bd2gykkcY8uxDiMyYdruvntlpTgaVzUWg6Qg3Md7Pd7LpUEoEk4cKN3yhi62wy5Lncp5C4','MC4SCrbIffuZh',4,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (544,'UdTXtxx3JJnhlqcJmezcFLqv77aYcZzHEmjsMXond2Fad5y5SAu2MQj4h4yMIWB1xDbtZ7d6bUFFgq','NcXGkizpT4AIqeBefkMG0BR1U8BlJjMGznNQ7Ir64pg0LTm0',2,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (545,'TFD3boACxgTKavgT5ZfQcEVEBDhrOq0nmQKUqfccOpbG2LAJS6kVpHNrqhH','uaxwD41WsqgAWycRXKDIq7AHq6UUidTP0aatSWsZ',5,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (546,'efPuNWdjSpmdNBZ78RNkRjw','v4OrFztdmVHQ20xBQE06Vr6HQugumOZWQ00nB8TGGpGkIHaCqm73bMlilsGS27kINlBhkG752G2RiY8YnpHOlDUw',9,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (547,'1hCAi28AaKMPfNpZLChtpxXMUhrjXIjK','6RZv25VMMtv',7,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (548,'Yaxg5yxM47oEjfyTXBsteL5ojfLnNgkzRhOJBafMBQRt5dyiavFNPHc6KzgaLZkPwR5pM','7repK0sqp0bDvuLmh8jqElGMnsoJyPmvGPS',7,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (549,'4yDdATROprlY1FDceOJ5EpOCnO3','RFQ2aWiA1',5,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (550,'AG7o4VRRLwChuykXXukAt6','3G0tEqLTWxvHM2IDX3xonmIHkRyGXlQOxDPvrshzwfpwMoGdIet5zHlN2',9,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (551,'mHjS1NZGgoQhznhx6EhLBAv1Hvix3vLKFXcC4r4JG2SNbGGIwfTqy7oIpsfJPxETDGsHQQoa1m0XBXY1Q','T1N7RbKG8mk6rxcv5q',8,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (552,'auTvSGoHDYYHoyawMsFgiAPmhXIjaMunXVtlQO0REcFDzEWF4USdBCuqiLHBQL2eKCbOA','q0aVJKLqiej7ALLgZRotNVsRC4qVIWro6Em2hX5lEOqhOI24Sk1PsfVVO7Tw3DvdrwdDJQDDkpfUXL6wN5z5X4C',5,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (553,'oyeCrJx56ifA74z0mGSdMUeM1lICzAqqg68p3kkQVWWMegaZqt6A62hp7xOPmeHs0Hi8phM27lhWfObDN8XJoyxQMolyMZ1','wGbWnqt3zuDGSCai0ZQLclidqV3bBubAsAelTqrQPtc1qkbZI2FILZUv6tzGdqOxjQK7QLw0RirS57Q2CgQFHFYhoAxkD1bh',3,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (554,'QDf4J7dUSkl123oaZfsP5JAZmDxci2fZ4geVNiyW4oIMJhW2LZGmKTIF','LIY7Z23Ue1qENNlR8l3Q2bhPRajZ1EXViHT54zquOjRotcdDNkwNLjkY',3,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (555,'wYkq7sLLHFvBIzFQcbuVe83XK2XI0DJWW1fcTcJKfn8o4','iHoE0LKP111l3hINZdhHQiTYSsUNwwK2XYtkOTGDl4ZI',6,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (556,'IxX','5zzgOvpIejbwHsVqkaQGpI6D1n3zNgQRkYsR2MlQGBMiJVu',5,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (557,'FDLXKQoMJwp2DYMdKsRVTYPvQQg5oma8qhCygTDoomd2','devMxTuwdHApjhczREkDZxECYXvP8gzGWmAsWRvWmfSQznP6MIQNictp0Q',8,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (558,'f3','0GP6jzQVQMnTu7HtcbbJiXb8Ft3IuZyTVhjTtb0ePotEOqMxcwU7h7GlTLmv0gFel46wQOXMtLTHMxRhGu7B',8,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (559,'oHprUoLF6oNLdOQ3xfDxNLb72zNjX','jmBTBWpe',9,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (560,'RrAJz82Sbbdi8szpKJqieaB','eiPJFpaEqZy4',8,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (561,'FOUUEtLyGJb6ZeO3QEI6k5N63BOMJpmpfb','dHcUQaookSOYPIS',8,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (562,'3LaRpHoCBh2ukQsdGbdd1mujgk0W6PVS3JgkncLRnfbZ4LjbKyph','kBKxY1D6nJR3F6eic5yu8nu5K3pXT38hRSEUd6AOX21AkKCEM',3,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (563,'OXqiCjIIZcKjUySSTUDgardshM4Fgj1VRqD0jqz7EUXRVsmEBnVIwNUMMVldlUaJG6i8Qp7EhqGG1b4Na4OODRqAaTZP7y','pFE',6,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (564,'3PBY','6QliaCAkl0MPKbyZUXBXuMohjKTaXgrTakPicNGy1xhBxy4tncAL0HnHdY0zco2ULY2ySWa7PxOMTxH0sHvmyTvSyv8OAYO',7,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (565,'kSK1L00obiDhOO0tv2S7YG2hDA20IMxlebFcqhAMKe6N7BaDsXl4KMvI0ba0AErVXxj2kR8uK5J0sMpePUZFkSNkoM','1hPni5kYSNnuNBWZrGhIhxRpcga7b6VRUbMWqoQhcV6CQewnnofgjljSecNdjb2GFpURdqbvKyx',8,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (566,'WiZDbin','fWfqF3tLebyI7RhuDyUZYAMMuZ15kBG08ukliXdXNiqEADJqVSLFZSvYteklYnp33kMEoBScGUuThWdNAftOCv2iErt',7,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (567,'l2q7x5','FZGYMEwZLLHO1s73xS1yD2wTDD0iS5Wejtnjr1svlhFudccZsNcKKAnap',6,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (568,'QkCqb1h2Nhprcye7wD2TRvXcjhrtWwYhuCV7PPaMy47acTc5zj5','d1c6jil0yZhgb8G0EneJyyJ36vCHTn6ZRkMhOXqe7UjLMFR4XZuA00fDliNA50THKQ1jZiclHqsVsdNqeQ0qtUWZ1oX3dsJa',6,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (569,'ubRziVQllVVUCZuJtDzXOZSJ4FpotFncY2S2FQo8o','eTvm1BNMXjFfdM6s8pWHTpUf32',4,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (570,'1aJRrDYV4iZ3BByrgW2zkbxpxoAkkxU6ZVnFqeOnFO','WiLS20B8zn31rKA3tqEbNdrx',2,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (571,'ZMTfHwy1Ktl7QIVz1aCuvtgerVFsqZfDjyQKTc8KKgLeUvts5XtmvX6YTf4amlOiLYoK2cYV42Y2wcgg5jrpzX4P1l5','nDsqs6Tk2GDTgJ1X35dR2eTPOpcZHwT2qx8fy0HWFjz8kmFnVmcfyimwUbmzjUeS03c3pzwkcSEsSwmrM8Ywda6BJlkcBrCmaCtU',8,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (572,'6VIARTCLqHgRIhDawHxqIuKamVWETlBwSjjcVw4SIlRwCZq','J2G5850kuFCIcKv1sNCGtQsTxgPxQDIFjxEYcCYalcI6LdT8mR1qHeepwuYJU',7,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (573,'OD3fCGbo884XK66heKJU','KVA4jpQO4dfrUdt6gUhAJr',7,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (574,'cI7Zlf7QmOrDSQXaFuQqLQON5xDXOnTjYE7rOACE6LToG4eEE4EdQNDIImKfGeSW0N1qyGSORgmoJ7Yj','5naeF1kBLoGtDkov1DRjDnHSYMy372UxFXB4lsMKZhkBY65B5',9,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (575,'RqkA7RPJ07WKZOyt3cDDGc4vwsMYZj2YJeCghBthwtp6kvyaMogoiyIlN8','dQ46zzYGXlPBd6tYx7FrFgMIKSV4VHggBS04ZrW2a5llTdqY4pnLRVc2bzLxLMP8fJPwRiiJydOomgF45NubUGM52',2,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (576,'TmtRVririrFCc18KRYzVKX3UEKJIiU2vM5kBZ','A3otGsVMAWx6o5j1XihHEcPrqX6ysTtBEnZh8NseVpiwDyAR6NOH24wipq3OdrwHkL23s4byRJaO18I',3,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (577,'UFtw4ZMPtYmfqrGolQPDxJsBPF1bsq4qtNzvZmsnldA7jivtQOslX2jp6pzAxEmDysfrt0OOFmx0vWaUQjUDq54El8UeDwmVVU','835CVoddXiMRbralNI4yaq',2,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (578,'1KsDTcG5zxpdI5MKoass4QEU8f7EwvjomaLwxPObdceakTWQjMya4vmUIRwDbGovPwXkaIJ3wmtRfcr2Ve7i4u3CgeRdKdHm8ZU','JyuoDamT760nsEbeBSDsIOPLOxYHE0vqOCHCPB1QSev5p22zEDoBDjiFqFOswNFXvqiLoeCWFAmuUtfXKDC0xMYkIetA3sM6',9,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (579,'kerUt2soQCyIx3XGgTKMoGFgIEYZ5cRLJOfSzWd3iBvgrEyKD7jWa2srOgkSHq7hKMcTjrh5y76VOiDSEUltTm6FBeMRkxbqQDi','gXUmwy0PTQrim3USEaYfzEqFuRAIDfXze3TiNqpxWK0p2md0NbXHxuDVRQhSBvuz3t8TPP7a6rbX6NfECT4UzADq',9,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (580,'inUfUu','DAGPGYzVynR7',5,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (581,'IrX0nL3EoektobjbahGPiyTKaY4GHOG6A72kawjW4aGiUPZS7bUI1rQyjmOlqiaUmAHrfLWcPrbZ6BygqQ4CKvTQD0o','VBI1JoXgcG1sTnbWxI5cd76PIRWxSAVyBEREy6o1uWuFOTEsBPPhYPufyKaui5YHpkc7xWj7BOMipfcv1q6R38d3CaGLOBg',9,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (582,'k5ZdwF1fhDZc6IBBMo6MJLsv3YnhYndsZvzi2BwNiV7McCrdT0pQDJgJ','LGmksul3kc1EgP4Hzkmy3JHXlRhkJwgVKUnpz4lU5r33dVrvHwrsmVXreLCMdKm4wHq4aWzgL',2,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (583,'z63wLMZtzZHNm8oPq0z1qwETckWg3j8kkKmiiN4osFKTCmUr7TWuAjZEl0Qi8t2bzPkbot6akktyZe7CdIosZOCS','RkgGspwmah05GsdRgIZ6n8XJQIh5CJ1Bb3UFA02yzvg0LqPOMJZLOJ651ot1ZJSmYyov3FDjue0Wv3uhf4IutCpM1LwEbw',2,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (584,'l7aZLb37KWZm5jgTJB8TeCHQsVIrHCgomz65','hvgbM7dShUE5z5JfOBZgsasFlAGq5bFYdbdaXh7uNTLuCeVsYeQToa4kdX8C',6,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (585,'I5AZTZUzqsq1','lxmD5bT11XYwTJi7tBqcg1GHh25MxPSlBgjXaBuGydQWpWfgZxZ4gnfQLvwFBZ2m2MaSQO6rqL0NMHYzY',3,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (586,'iFNLbtSeE34Ph6lS6e0tE1UBWJEiW2Ojfs4ulzXAnzyVqZgjTv7iIcXnI5IdDw71ry5aWL7o3vMb','4sU66cn84Upm7',2,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (587,'2lhFuAuy5IyLDreihhfMrUN8LLgwVLAax5IpVET5sCHG','mHhNMWyfU8Kq42NI2KYDB64bgNIe5a4u6bTGQ8LrBmw3G4DQ50e',5,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (588,'mZd8KxZXAy6jNLv1Bp5AZrFfp7','ULUeYmhZuazj6VeJlLizS2Cn3Kze1r64iNF',3,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (589,'kEcBewlIySBrKfIaCVCmeZXivEEdusbmJQhoky6h717zB','ibVqgpPuUsxhlnzeWy2t6kwsj4ZssPX4VlmPU4KGzsw0QeACI',3,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (590,'zoR87hkdQulEyt8JheVhY2PI7ZkxM7KGE','vpHeJ3yaiYR2RFNcsbk',2,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (591,'TTuTjGhwD26KElCt1U5EGPh','FC0iQncUEQPqOTezPN3hc30vRuApDRcdrENdVbNKZUBGECPCnH1SqEgb3DBD4JOlNMErq2mQOgXXkAdTDK4YM',5,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (592,'wt3bZa2bbiBJWnYNEwEMxAltsdesGaOgZYMjcCkcShwWj42pHK','bAVPJx6JckWo1ZVflIkTPrxAXb2HM0O4SlunHRWzA1EdVTsJGP7oth82oOut4R1RHPfEm3tfiNaBoqUNq8nTyC0',5,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (593,'1uoR4kwyzzoLCfrbSRTra','VZyWc3I3eh0yvG2SVSlTUuNhJvTWGDexwKBjncIidzYNB8iJ7ZTiETJf8481dFqHisvHnzy',7,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (594,'svUvWUNQgrYJF6pGHnQvAjxfqc13N7711f4oITZDe1wE7nmGQYDdXyFYS0G3qoFsSi1MxhAc5vNEmF1GeT58Ztdy5BywNmEzzuf','UMmdNzKtMWdzZNEF5PFI2d',5,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (595,'mJ8YMMJm6lob55EdgzBzhNPyz881br1fLCKaR8fzHk5pgeB5tvDfc8JhjykSax','zV8Fg3Zz7LzNrLIZv6pFiJzs0k7EtWEsGjMejB4wq6w8Rt4ECvWbrdCXVVxLCCVuG',7,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (596,'Bigp5SfDz2Eo77EnXi5i6c3','g4zz1cTWUZFj5X0FqWA',6,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (597,'7sBurGLnSlXyzhrQHY1Xb3JMOy1rXYCb4hpQ5RHpj4Qq8ImOejW6GU','GjwGzoBDMMKo6f',9,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (598,'Ux7hvqTegymnaxmPHDfKw1NJdPY','sCgA7phKOv5SMhae3wCsbN4F0lxNmeVGZ5naINmAauHwWiwpUT7H5I3',2,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (599,'63MlTJKRLeIcVQVA6vGGETIBYPQqWailjgycrp2c6HBkB','tSU1APMeEKtwkxMwhoh1SoU1CQmuxCV5IZssnil8tFPbhvGlwhNlrSjbfXOEiKOH1uVRcm68KpfkK4hHc',3,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (600,'DKMO3LxWlUyK0A2EWulgnqCzuFyp8vr8BWaFrpLMuCQZjgYYrs5qr1v7vEDcAieOFj6M65ay6eaFFZcr','LA3QDw1YwD3TeodmwTt4iIktF6imOnmkRJxb8pEFgAVm7IcjXBK2AlL7DH3rRDHJjzdvIDWsGg6udEfpSSKzp',5,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (601,'pK3Jatk6nBCB4YTQmb7B04kEjRHr1Mbbx0ytHwiYyicB6GTdkYs0qo87bpc3PkoAz27d7nwcSVP4','AOzZtu1eNTH2DRqQTzp3szfJS5WK6a61mhV0MKofKvOPjKqDGN08UMejdEkLHg4A4jKVr',7,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (602,'VoNxpNFFZUYrax5051P2cpjUOoNzKbhXZmO5bFl3cqYz6INnnZCQPdSjjagSBLCtB4vin4','AaoijX3BMP5cwm4K0X3EztiM4xKlBGbTW1VTftvHh2q8kCm6SPW7fgDBZbxyVowz1bN42nJ82Tq1K',5,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (603,'zR8p6uG26Vptc5CoZmpcpafU0KsQescAoG8zxKD6CnOttzbFnjKFbSSJkObYz2WYoJMYMQQF6tFVhcKkvcmAX25yoQQmPTy2o4','5fj4PYdijq7',9,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (604,'UqpNo15nOP0PN47ylU8zF3qedMBNIKJLzElv0HBQnLUkE0Sk26I30jAZYtmoumWZ6kLDRHWvuVhE51yejKymU0wvpN4VEuz','AOBNeIo5fwtIWjTgMwHmzxPNGsVciCdZxaXxlRKCV3zFcjw',9,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (605,'SA4a6rIZ7NWyVfZ','JZdAmjdHTgp3UCrfNmcjRCO2WTa8jjHsIU3NhS4iT2gUbFtnrIN38LuFgk7t',4,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (606,'JIv6PabwFlBjsKgenRuL','jbZWY5Y0AepyvNpDBiqDFfFViPlonE40fNjBLoDdFynBhtsQB6rZxXfW56fGaJj20iAJJGZvmLutdvcq3qY45MGVg6SUbrih1jR',3,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (607,'4Fdhf2IIdlP8XlVHN84onznQ8ER7KVd2M','RHVL3h',6,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (608,'Rvwyqa8ku7wKrgjWVQRwTvxenVkUxeoj5n4CyGevAeCrlknSl','FmSakB01r8Ewo8HX3JzzLIq4eiEo3UBL0VceAlrRr1ODXAVyQ4g6RVOKHpoCuIUyzwhIcFyBJ67lHvis4U0x',9,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (609,'tq0DYvxyg8fpvNpXMP27','3rt0XUsHYB4itwAqwJyMJOldDA55Ln8EpH7K0wpCtJtjx3wG0VGcdqnfH2H33YswnJz7dE1j1uIWcLKMIvPeF',7,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (610,'J7sdyNjfEKadm3mwq8ujI3si0Nph4CeiZIZz3FdU7','B',8,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (611,'REKdBzlO3zP8zXAc47BeT','NyA0gEc5wWqZKgh4toOEh0gmR4Lm3yAN8T8bDGZOwGssZdRyBcyDbtWUP2ljFb83g',6,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (612,'8zLppRlgS6WA1VBB6Taqfj0O6JfyzZG1r37VwuXlYJI5GcAT08CNDqG2xk7Oo2p','QbaduacCQzVV6LkFpSprO',2,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (613,'2ztk7VJZXOGqP8dQqRAffCHdpUHkGRfkhfIDdeOGt0cyyXNuU0gdEAanWUDV','pdTHAzziwkVRymTg1AIf7q6W65amoX0fxONwfdKDTUMaK7oQHoxqBKLQG',9,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (614,'3wasenCVWY3MoEWOyH2JBDnjAtrdPoRa1PNey07MVFTiabJ0XIJUHtWtzBgHtgBUnSbx0xf0cljq4','xf67J7RVN3rwkNyHlQa53HfTJsV6n',8,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (615,'GA2A4JEClvrCeR8jBBahBLUfeplnRSrePIe6RRlyJzUGvhFiq5GiAFiyP7biFumbCG5oVH7amnlsEFalXuIrt5RjBfmZU','VJnHNzg2Z8HPY5DyibsNLnbkxjFx6CwV7MrcZUjvl',5,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (616,'MMfw7NU0xNe5o2dCwDXXLJcRSYy3OukdoH0WVPFb20lePgo5GUqqxGzAhZLc','s8kbbt8DLUE3eM4Bh',7,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (617,'nYXJ0Q50H2pOoeYBtgx7TywuocGQ1Mcrrap6Tre1wzb345KTcV0nM','C4vFUoSwvfhNL5LcHqI7kVeKOPUlfEXAERWDnSlQHKUbVPw41OLG2HSb51EnYwQgj46FBqOWy4ILZaCpmqCLV1fdtVfX3c82oI',5,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (618,'mLL0hVrnzf75PepD2JEQeeFtYv3XiFcPmsw','LTgb8wqiZ7KtuHwT',9,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (619,'rdspR1TYRqVilB5PehNmP','BdVf5v8aFdPLRnHFsMrSiGTG00JcO1tZv4vDKqDW',8,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (620,'r','BM1sqZEcetXEuOaF55NeGYdyQYrbx3erH3OwD',5,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (621,'wTybMQeAnkg7LS0GiovlenIBC0ZKZOHqTqLF67TatbtrnQjVwZVZV2pm36ATvMG3OzN2mfDWWzwu4Y1TeHr','lijQlAXFqpErhRdyREp8T2QC7q1H5V2rRIWWQukkKA2d',7,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (622,'fV48ZTPdWmumOtRkqmvNl','uwVPxjLdrumi7natP3IIewKUvLzB1PWer1BNMmHziFH',4,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (623,'oW5ZPM6jlT6DH4Q3q1cSni7PQGAxJFDg','oXK6g4tOaR4ZDMf7pnlJYTIrWKR37NTVmkRYFMwPoC4Pj4EammgQ8ZKLFJqoeaazw2lvuB8KRjpSdIgneg',6,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (624,'gtBfUQUuMjUmG7zo2vLc1r8fDrxsJCjQkN20RHlXDwmocoAzGtXci6lghyWqjWgbeCfs','D',6,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (625,'W83ygn0IKg5YheE4gLAyJVUKtN0bPSLUg51cO8JasA1KjwcPj6YxRB42xFepYaOrlVZfDAxQ2PsdEZ','iv0NrS15plkzkaqSmTFnwQrfE5IieUW6iLQ7RcyE2sVkmgWNs54ck5ffvsLr7GqtO0qt55SCb7eS51n8c8bBZdyIsjiYT',8,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (626,'Uk0wGZI5EKp3Ml0vliIzhJM5OApXQ8RgZhKUNV2Cpz1yvfwoCOrpisuPhMCFr8TXBgFQKafucg27sX7wAmbP2XXqhvlLGewvj','c5GmQwuSTLOoi0sVlpFKAujYMkr0ib6fumwrLFjErgloK1jraSRvBGZWAlTCVT5U0RoXC8nFiyHu5BB682Tf7E4a5W',6,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (627,'SWd4bjPy2CbOY80MwIWpMZehCYvpjtovI6vZobI1NbGGolmPWfBZFOnHruYEC8f0GvdpB7YhiX4rboQiNGwfrxVvlEsdFrG7','kfOBwFtQt',9,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (628,'GvkNv4B1k1XT2LhGOPPPIppj5yLSZoMm6uT0D0AR3FRyfPMVeqOLdgTazSyxarvCZF3cYJThfELf0QClr2gK6rnm5jAZxAO','IzZl',8,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (629,'A32V3GlyJmtCPkAWRgJBIoIPRLgZMJCkYk4bcu1WGeOlfUUILWly7WHtxDDMrDASSDjrtqg8zbfJmvTMDY2KKVPUIqfBT4EhFF','TNimADhPRuxEjlZmQK0ojprj6rNezYCf6zSHIgKagS3hA5svYNNY81otG6PKLlulleuOmQ7OGDYbQ4UZ0NkoFeM7',9,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (630,'haRD3RK1uuTxEjIadVgr2zzJPF8kF3oNRWWfC65J0B3rRecJppmcG0moWlIvrmo5MD','STJBcgXtcDVfVbN3pCMPJ',2,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (631,'zkxWOzL1dVXWoCwM0MbtVZhUmAsMsR4jdJHDZhSOSkH0XcqohBr3u6Htx','pxwEL1IkiWjxgXre4LHOT45VbQ4Jp02y',4,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (632,'keYJ1SDyb0lQZdp0idROSzlYw32JviFQncL2igUDtmtGsGNSi2n6mzTasSHnBu8hqqYvnImrpj6zY7P','jyprbzXQTqMu3WbKgsDs47mTh1yDSBHQrmJtnu1RALY362EjcQXpZomAOSirGTS47175pSk8KlzpUMtQDLI2LZ5PMHu',6,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (633,'ms0aiGsjQPzdHYnACOKkuEgOv73MMZauq1tvSMJ1FvqyIQaW3BennckEUjEuVe7P6nPEHfeu4EdsP6sSdV16','qZjlOOyBv07kV0Zwz',3,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (634,'0ulL7OzKUcJYmMRFKzGDV7N3Up4lAROAOKkmnHJPWDJU8YiKyWf0yfunvnoMHBOWPqiMVcTgfPEzrtUg','bkuUkEVhM5fvyMhZjmMM1KcUHVGtCzexgLYgZ8mhPolxI1gA',7,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (635,'UeQjo7qQzxgZkmzLtUQUbeIpMm5kGBWAO8CQNNlcMHxQrhM4LLNnXE4hoEhAks','SuBOaxJyq5XyXfiEo',9,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (636,'2Ct87jm71OK6zYCC7QYmHfHZK5DePbM7HBi','nb4TJAzgj3dFLnlYO7YwDG3ZQ3PqL60a2AJ1dqzY8UTclRLuOsb1kd3K5g6c',7,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (637,'1RtEosRKiSyyF4txQhfOzNzBtwTGfglMwlpLhtJYbjfuYI8irKoJ5xL02d5IhnWB87UYgbTBbzT8vEATrE6SA1lxfaysK6oK5V','ALKXdt0QGCtKXTcNzhYuqFnwOkEiKbHTKWrjthdgS5DYvN1rN',6,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (638,'SRPupbAasagHdXVPYKMVSkLiCasfDaEXmikNiyf','RRAk0SwSk70KoiWrWq5YSd6aodvfOBunCEGxbCD0MGDvmekRfVkBunTnKLLlWHBk2ALHBCgXjSak',9,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (639,'0PcsnL5t20eAlXv078kphObITVfTVW4vmtRX5AyRh2Apf4f0TQeS2RSphzfOAhoZjPgDaXHCfhEU1wzjjz16qfbvoQkOAMcYai','6GbnVqYvNPLqzWH3t53oFUUktAAnjojV1ee',3,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (640,'oFoIEfW1irglHaXd8NA5OzKOeG0bgKCq8h8Zih8jrUecD85IJHHJoiEsWAZYj','jDi3k4UCjfzDVPkMBjlh253jF7oOyIb4BDu3gWpcsHOwXAvF882R',3,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (641,'8ieHbp5dDGivWMXj0SUXoKbU02afX8VMR0sWeNsXK12ceqWnDqezrwZKEFmdiqSOlWJVmCisJqLVOqFjq08UDnFOPW','y62wpNiZ7MqDp7dYYqhurKdcF2EuDGwXcXQLvSsPHAlnTPf',2,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (642,'5OJyah0F7I3PlQEDJPR3O83a6fzknU3jIjyUP','Rr5ip0HFWVkBbSuv73DQFos5FiHgfSCTGGUlqoroI',5,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (643,'G3PDvZehMMbbdDmrxkoypLpaerYfDzk2uBq4ERVnYXLyIteXyp6X3zgclK61Ez5bcZVbh','H8uupYlTSvcexI4QaRCKdZBc71mHkDm8U5Jt2KyrfvyHhlKT',7,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (644,'3mZsJPSsCwFCgkQtgyrvGKRF3OnuxVXkSLJdwxFckh1SIVIlFagwNBUtlE1jPUi2mGd1PNtkruAyva','Q4e7iKUJ3BJPXQ5zOT1Lh6Nj6cFG',3,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (645,'0kHQE0QwjTQ2bsWrODoKWoiEpUKRO6MwhOhM8s7xiPALReqkYgTDHEQPUiC6BDEWFkinGqSfjbCEwi6dcba5fLncYBtT','FAhnPMvIwLwxQztT',3,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (646,'pmtHgQbYedseNsgg8BxJ0Czf7eXBkyBxCJwNYvBKtrxeVwFgUFQBA0Nsol','JdTQlxPYvajp6YErkwg3rkbsl3H0FwOJ8xMkRbF0Cq3Hz1Jd5KTJtIv0nsdRLFFTxdHDiEPVYI2KRaDUDgVv0DyujSa0hT6VCS',3,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (647,'im5iFB31LGnxW2f1r','qiaxXSY43FBoXtysnVmPJrwoC4i3pS24JWDnEU0iHD4egVvwdmlMKhibKhVH0gkXxeBDlkpYIsi4p47dAPsUETdHFCXiKywK3pX',9,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (648,'tmaGlXo5vZGM','fmehWjFZcA3bcCmBJatKFKrjYtmPMNNO2t7sWZQXIp3CUKEGS71fwfdPybAk75YTpy4EQR',9,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (649,'wkjEYPE88hBvlDzCVx','Hp8cOb6Sep35olJbc4NH',4,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (650,'t1Ek4v4UYVGUaWmKfHSZW5sAQ32nC5i5UVChOCK5AllQrXTMid1nDplPOUvUxOXrfhMJmUHx5n','I1IXSrveJojqwzF7PXoIpMXGjghgAgSjwMDFtGysJRHDRt6SMK8SXQaN1CSaOqz1LDmQKBD6AsM5Y6qkkQ',9,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (651,'DOABbG7YK5gRMbTFOGMCz','F1oa',6,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (652,'BLHXHonjPCV7VoEABONjrNZWzEIUtOYaAXi6GPO7yAmPmBmeUhFvu1Nt6','fM17DRTvuks42oyIjYZ',3,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (653,'FAsqUxf3feHZoWtz1pPseWEf40Ja1Hp26PPwvoORYFZaMBWl1rjLVni8MYpVxogYDNuPqas7VU3xmi5od5Qiw5S3pbtn7sRYQ2','ctEOAOrsoFxB8qlB1Dm1mRRCWG0zwcGLafuIYtxKp1wfQF5ZHYss5dSLaJZyAGxruukn1xvCJ7ldIC6jEALjBRmUW',2,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (654,'6nmhXZp7VXk2GNzNwzBAdchv51MnhIB4pIBzGarXxeKyQhW','kOubWBaCNXdjCvU3qdw3Yongu5FZfdDOq',4,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (655,'mKCfuERYuv4TfXYoPfG6P8lDPI8LUBDVxtzlDUIgA3MkHCHZnna0ZsBoJdcG2dLCHjdcZ1UGawMF1Ny4WIK67sNilN','J5Sw4IqqMImtzINmRhGmGUrtURQP1G5Dj8uYD4Nfc2FvL5KQvYtTzbeM6s3VImlLIAHlKM8ySjUgd',3,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (656,'O1dHLQRVJiBaL7ukTQImsOJT3Peq1GKZW0R3f3fZceIKshd3SnY','1xqqZBLjtNlIR1vUE3sFsgT8VKLRuKYQZ',7,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (657,'Z0wFz5raC7TrFjW4KKZyaXGlW5iPPYHgQYdeNuesm','iRygjqe1O8XHBCLkaiTLOjWbAdvD2WGfpg8FvPks82Mf3hJuLy',6,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (658,'0L3RaSGrQWHZM3pEeWbHeQI','YebolfjPhnLLCUelSFfv3hifnreSjHqkxCrMfRGEZNId5sxKplFWhX7y76oRHGsvcotCEuK',9,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (659,'GLHUq78gkGlYw3JZRKmATX8dE6DU3rTIkEWgtebHuJPKHMnNkrzQEXjYvmEnkGRoKKlJtxfeyK','FQ5ZgqJrYfSwO2kV',8,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (660,'IezzBkNlXnVnPz2qHfMDl5UzdmBGipFnLBn5yjUIJoVY0u2rN67b3qBbXj85fG3UTwx3','LE2txvUwjDlaH2qeqJW3LPl2QRIIoZxTSGmUq3lL7cXizPRiLT0JwiludPTYrOS2rsgtuOT',2,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (661,'ooUeSz3h8R6q2o7T','byOuOjGyfff8xXHXQuRTC8cVm2hrdbtYpWGQdKuXSnoa0DezqIXARdA43arkTTKMuv5g1cwqhStUIeILEhUURiN4UtZZCzpqa6V',3,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (662,'fMH33Ac0PAOYcXiJRAnkYarEFYvX8x4e0X3ptGs','in1YWjxJmrYpYcgqtTKQjTPDAuoMG0mesyPQD3SpHDgRDcAYsGaTJT5FdGLSgKdMktuguIFfbK53ILswAC3Hm2knS5UH',2,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (663,'A725E8NMVbRJ3El2YBiM4fFq1i5N05','G1PvJGqvMhEhHf8TNB3w2s81Wfo0nWJcPO4',6,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (664,'dMxRsh2dDM5WNVTSUU6AHbr0p6Lf','aRYelGAHmdQClywXDOY60SCcjHjhty3',5,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (665,'bYtXGKvTl1wbuIEwl2BLlaadbY7AMff','RAYPSlQFBApUuXKQm3koYXxbOg',6,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (666,'zErcR1bOgCIDrOaw7q8WElB8rW7IuPLDK45oCZrmKy4rjcu7ci5CiDpGnX8tbUt8aOIDEVfNGYAQeOaRXwx5qaBR','rcoYlozwVchtERMVmOYKZnSilYRo2i7pASnyJW5c2',7,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (667,'wnQzDTjRob5Drvkp746JLF0s74nsLvbfSWTepUPtzYgzNZQWR6gywuGkUBc0vnZ6w2FrHAOb1XosqCPCU14BFpYQvk7moFGuwcQ','P',8,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (668,'wOPJLARjjoxf3EVF4EBpQj6DVwHjzvX4eYURYkct7SzmA6WhidHwLTxuTjys3POLvsBROxGDgXS4T0R0yH','M7hQqyDWXbgTYn30x6jo1ODkE8v323U6lkk6pY',9,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (669,'bvuNsjA38B2SKUuGPmYaTzjeDeX1L','qGpjbOJKDSWs0tmDyJ1vOTpkKlCkGbyaSfQwTFrrDx7sTlx2K0ThLtQqtZds6LwALAOzlx6GKO',6,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (670,'fwX86RdCw1G3V7zotYrxKH','ASW2lWNN1NXQ0Ydcas0KZHhreZWL4LWguL4u7diDP86ksfRDUSTzDk4utSejNzNBgOaoWAmcBRYjHNoGMP4',4,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (671,'trf8AE2Nwe10HyHMpgoWX74MdX','MtYOBsrat7dDkmx5gzGC2MCBNTDMiaJHU3PbRxzrsixT1LOIuUQRn0YcVAfFzAJ3MS0dTwjRfypguM681HtFR',7,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (672,'AffIFPBfCrCQnPygb1xjLvyYqZbSMqTTmuaMHNfHMjrohyYzMHwIInsAHey','3635ch2qoDTBptvMr0mDKHc4OcofKebPEYZcueUJD2TC4YsyMpRWF7ysgfzie',2,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (673,'B7lXXwv2sAxltcZcWbtG','C8uJPARICAvpYbCHrzN0GNjJ4q6bN5dYXV2dxRZWRU3rxlrwrJW2ioXXfnS',5,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (674,'Ki2mMY','QVehngQ0M5hE483XIuMCq1ln',4,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (675,'U2w2ETeDV1CODbOPQZzrFzbVBd7bulMWxe3Y7vHcQl','75yBXGZGxXUJr0GSUKcopb0c3tkBLvoGsHwjvr8epPjEvgOLfJo7WGuYLOqPzFR1spWG4SgCaCG5PKBua5i26FiWiESL',3,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (676,'3bEMDB3aThg4Vpx1epOSqvNuHyYJgTE0gdqNQJ3zJsV4lcsDWZI6FzJlQqQUFfFgwaNV7CBjCt','eAaEj65q2OOVX1rQ4mDRhrSTqOuJ5fSBrnEbiyKGYgFVu6c4d',8,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (677,'tHW2hgjo5CObOis5zBuuVF30rgScW6tHCd2rCjCIzM0rgefBtKZero4brvO8mpeBNM4s','CtValsXKu5fLLV0Afh7hFivaSewBqQoN1PzV6zBRkNuS0cgFYMNbgwbrY0G',8,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (678,'xdlU30bdkRWJq4h8aag7HIjPGevQMzAGH1VGKlMUwGTJaThtBBImBlhoLmUEMusDuOg1M2QeNBHak32O4SE61EF0g0vjZ','uhAQcgbWkDq3MORhYLAjjbWgEfvD7L4knyCaWF3uBBy60K1bc5O5VkOotzT8IpJ35Ne8Q',4,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (679,'CB7J1Y6QKlvTsJ4u1dfxfczmzWSX0zWlxyqQFnvPJ7XvUCAAljAHqiwxUChR7IJC4yyptRZYJE08PsR1','HQq6actPTGdVRi4FiluIJrZFc5UOZiPEDtB4FcCZCopL3sNgLLO017AF3XZUXz',8,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (680,'FNEmYmuwuA3rHW1f0','g3iD4E7sOF2tszdn7ojNm0Vl1o2PRsngHCHz8hPtBYDaabzm6PvawloIViUj4ZgVZV6amDgAn7HTvV584PXCQkCMwl6DCgwb',5,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (681,'hf','FD',2,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (682,'c7wauaRZHX6zFK0LQmIs2CfiSTcoBCYigjaMh8GDsF3HJOuYW8IxJSSgsJp0M0rGtFN5jl','xQm8THEO80jEKeXSn',3,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (683,'V0fgU3mJ6TVEWSWrIZygoiu6yR8EromJBDhvPcluiVoSY','8KM0wZzzY2Lvs1LPsGMSJVtVgOhDukwhn8Q',5,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (684,'GZHaUBDUec','tQ7BBsaDUNtpLy6rWO56ypjWzfOkVanhqHbUXiIQqSGht04oxV5neUe04dRVYC1MA13184',6,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (685,'X2iLPY87fj2sYdFSMnx4zwaRxFZSeKbjUXOugAJkfTHhKjeiaHYBkTQ6fQn4Fc12nNLIdBt','yMAOoYOVjU63c8EH0FWkGyCFrWD0VJs7V37FV3UagfhMixV7xOIBi5DrWg1wb1ETeujLfqahnkIEaQkpRhRcPT0tBsLj',5,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (686,'iXT8ARcSKNijfE4DdQy7CoASy6q6jyCJjvsOBZ6QdaF1huwQClgoIiAoULBESwItA2c','Kmbl',9,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (687,'Wf3gn3illcBLdvoTVhzIpbSkyl8ul05ug4TQE1xmqAU','62QrdAGHuAyVSDEqrKyfRjEgmPq6UukAhYofSM1MX6mO0oZPWATinjgK4tVwFO3QdFJp',7,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (688,'AGLgk8wGaV0kA1qZXyNj8uEEI3','yI667sUJqfVZWUZ4gyeZwMuB3ixzkJilxPag1loTD4SFWRoQIkSsufk2XEk',8,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (689,'xlG6hDCXNEU8ZUF0p56mMxyRBfcRAnyL','WY1oVFx3Ee1jMg70plf74',2,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (690,'8MeYxVEcjQCKyOWyvZX3pCxe1VP','B5RQTBBixiFAWt0ObBJExQqU4ZnTGCTrCWgM1gPEJOz46fCb7omhSlt2JP1U8NhimEXd8nkiSayuygLqWc1GVohE',2,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (691,'sAHvvCDio78aYqUQJyY30IcaatuSmKHQbBOj0WEOAjcwgIctbie8J','DiFMksfhHeK4j5YGrWmINv0VrbkW',5,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (692,'4iNhUQ1iOCV4i1anM1AJdtrVEOHgFtDBxCyufwlKStwDPjsjsmb56sRX0KIQp45k5itYx1mTUhUHhqmWlizVo','V304J07uEqDKK6UuownGhO2JfHzEfpE2JSThJaGktghEasuem2KI0OvFYkgbidlS2hfFNB63a0TB2x8agNzuNNKMHs8kbEF8uz',3,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (693,'SMZgOATUvlywF0x8PBoitbYQGiNYqDodkEOpne15QVBP1c7BPbrkIu1ON0YMi','mxalxrZyTbB1xFjxRRYLz4za3htywhECrjCXYkF',8,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (694,'efwc8zgCHTZom7kInCFeOdF1DjxidDUjUfgtoMJqvCFNJ0cpgkFzy6DY6x8hRpiGWfU5pz8oxwHs6KuP0jAlgdV8popy38AqKsV6','0JvvJatjtajbOYUUBa16Z8ZVoV1ulJHpTVpD4AlL2uQHuoewTjqWMNzU7YAs0IpCpCdATFXYRWwIr2bc1wTqXg4AkTkvjn3IFIT',7,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (695,'4OFBUD4DXWMKxE6KOfWN2o8rKHYzs0R2j','pkefycrAOjYA5BtcqMMoXsoNRpm',6,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (696,'yzLlb3HSFTu3ncnBACLup0bfOLVIKlGS3TpbVFdbLncdXOHPxxHbail7kqkJViZHq7baggt44TEWgiNjhsDjxir7hT6lgwI1t78b','v4xdWiw8VrBTVhu3ixbANbokir4oKkOjv4xmckP0OSgOPeilej4bunz0XhFJlnyalXpkVd',2,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (697,'Fc3dcuPP3U1ikWWo5P0aoB5DHEVvybkJfpiCG7uEg1o4Xh4ZCqQgCHZgxWMYr1dZgFERLCGDvo','E0tiudSwqNQ2ViF0Hrausw3d1yRwlc3mDqv',2,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (698,'AD82jrSbfamhwc8nTgyfHhBHJA4fnkQNreC8ml8MXU','NiIF6TF3gBZ618NHcchKFj4UBFj8uVPsaVuIMk3I5kIILPqJaVjPerLmP3j5own3gFbvJ3SM1J77QsuHG',4,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (699,'sKQD4yKNJvPSEXNYvoWKzBor7vJTy3MxvMnTtrN2mydThDZLSA0lpmAUOko6WB','Uk18BQwkqlQeBgb7pU1bO2SnJeDJqlkL8PcGcBz',6,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (700,'ZqVQY78DsF5Xgl5WQsnIDMBYZrJNQbg3hhOfnXVjgCbZv5gqJLJX3DUEv','l4inXo1cxsLUKqxxe6Apv3dTvoTgg8TxUTa5nssKpBLSEXy0nkcxg678V3bwcJ4E87UiTkongOFVJj88HaSCsjccYlSGj4j07kL',8,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (701,'o','61drqzPCI4GqawccPxjcC8oY00s0BbkeEBnyfaUc0Wr6z8mhqCz3ovyxHSLi7sBfG8lc5T6Ht25KSAAn1gHpGTAMfgdMHHcAr8',3,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (702,'yVJOaEaY','sEuDxCxKpWOpHTQsvdR2mKTkmJlTBELCdiBBADDFu2qeKdcg7KfnwFdt8SSIN',5,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (703,'o4lra6KgOOaE2GeyoqhTXQtD','RM8sGfk3wYCiXnXwBC616VUuZzi5kusBUBlBwvIXNkC5klD',8,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (704,'CuxcgW1oXGuaK6CsR4WmytNw2AaE7TXxExpNpoACSki0LY3T8qeTlFXE6A4Do','rRrsxbY6UpSXba6OzPzhlACQy63eOpbfS07IGH8oibJWgXwq8fX5rL5RsclWkVMFoK1SYSh6dUYAs6rxCD1HVijN0QQgm8izaXJ4',2,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (705,'wSTg10HGEYEQSpdGh3vDv4n0daSxSXqtaP0jrseAJwDEhRdd6Y4FVmzQIOue0K4cJvOnGnMmqLHvi3X','30LabrrMEq3IDCIg5MxpZHg3MJhugEbCWOo2wuxQtw8KUVAbZNH3T16RYnd3jbAGxajvXYxinPFKB1',5,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (706,'0MjOdthN','vIy4qGsw4L6VmvibwxjsDyv28UwLhavpn8f5Q7rtCgB6mXU7TFTzRpcAs4fXog1dhfSaDad',9,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (707,'PCjiYk1gyoNGYisNt','vGNYWzgnIqUaXV5LRKl10vvFM47kfg5QxYdrOOKPCZtg',5,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (708,'w88pcFtw','Us6CFBu',8,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (709,'6LfAIEYzBkfeEQN','0xGY4RyRlKbhpKbuOpWApA1zIucg2pXhlQvKuATqzM4xOu0IWsqvepdHgSGQH2KT6vPWttZidDKACrlF0852YQvT2MNBM',5,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (710,'EWvQVJqpyjPMNvFQDq87mLUWlXCwdlXpr364vLnzKboR2X3doVlqBseZ','SiTfM5gbDYQyLFHWpRr2dNAYPklwi2Ej17fyovHHrpq7uDaG0iPKn1QHRgKaWUdegCLIdMZum0VZCMPgo3HQuF3IxkfeAqEDHjh',6,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (711,'CscPmMeDl','XS7Xv',8,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (712,'WOFtOmJVDbvdjBXqyqcMw6ILijdCHc7ZrtbD4WrpZhd0YnOajGmJVwyAPScXeaDsjOSGum70zlxh35','PrawXaM7jrV6XuJHhiiy5aRGNbDDA4BQccwwi7',3,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (713,'iKu1BeY5ihvd2K5XitMS6','evw1teD0DRGWB1qOelxiok6orwP0AR2HGIcLidXcTuxiSpb7kwVmIYul7YOhfOXMHSEx6z5aUe206hO0fd3Eae',9,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (714,'THZEfowIauElQefq348gCXggngX6PvybSZ2','IjtSStCqPy7ICJUKNraZlcj',6,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (715,'oiEPNGzg4avNVa3XJoXuwvSwtMJyCLnEKOjXkeW0qalGroo1SrqPMIefl0MxuM6MEykrw7ePkTZGpserjgAXA4Q7I1uHHU0FI','DrlFQMctGYCUa7DxpCgsTSwGK',6,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (716,'hdk74kHsQW7e47v0dZK0xAQsMYd1SEmz02aTbqspWTPMKs0gu3QnJQhZGYFMxtnOYoO1XbKWzqvtVkto2Wg5','vFFQub2mZYPyFNl5khWBpuXiRyfP4DfB4uHNe8jpatyhjeYvbjVqLJ6XQ2Mw7ZWqTIMNHhl',4,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (717,'I75ZilFbzfkHNiWd4nRb1mvQVraj84zOz2rLBIXnTJfqY7GdConjA0nqcM3YqPx1Zh','LFRQkS2eeoCmO4jV2234nYx2bRSmmNTgOnm4LrdE0eLTKIwDUyIJ',5,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (718,'dtGSCnpCRQT5LOSROHnJ2FCS8yS3fd0yvUZ3li2WxHVGRsVdzIXZyw8iPv2dDxJojDjh','RIfQFgKUzwqgjs',3,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (719,'7qJVl08kkrOpBtVS','JaDGjWRTm7xuSCtIY40J0uMQkHwgPOgZ1PVhykhqAbsSK',8,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (720,'RNrbpOQpZzFsVm3cRKEKAgrG','LV08huD6PHcU0ILoHN0nNSMw7ayfkEAsNvwwwQ6LY7fCUCJwaSp8YOu3bCPNrtPenOtxfgWLLsWaxCV2EfRIXugTuMETgj4p3K5',8,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (721,'g3KOtWpRwvOVDXrPW1p6b5bV78ByQXuuBQde2bTqYMgIvPFBBpHxJDZeVnO','qXpwmhEQayxnz6AHTsAX17S3LdPlJtmUnRHAleOjR1oQf6',7,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (722,'eDcrx523iqDwRlRTcnqeKiTWcFVftDGuSNdZmCAmYxcRP','FfgdRacO64vvRfv6wCcrXqHZmX1',4,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (723,'R1w1u58iaHVTFUFDJmwVgHEu','5njbblKQZyjm6K2IP5',3,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (724,'JQEg2D4n1W1pLlcX3fnO0CmoJxD','le2wusxZyJBKm57gfsW1TnPQUwIZCp3Umo08yPBZhs76zeyhFrPUVrPSFz2HAGY',5,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (725,'bSHfzJovkbppf4JECMVk0wwzGNUJANMaOluRWdNkODKaY0FH','mKp13MrilQKwkqp8Y7uqeVchkpd4hsAM6EgdqJAtit6h5KRcz4sX00YQL6QFNbWQSdixRCMfUa20C',4,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (726,'vBye1SOydluhagOwP6U6M8Wq2JzRqvhNvT','I7ZRROk44ZnXKfYLR5dF4KO4mlhEEs6Z5ZadqynditvEUxGzfyeIxofWsW5RSpJFT1yhpRsynpu2m8bAbIO3q',4,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (727,'CeUjTGJVF5pW3aEupjC1tirEstUZ15pVVVc7ljzXrvRUMC8QvhcqnLYkYegTLmoYuapMPbpDFfVugQibhibWFOwqLaNhhTLBE','ZPfks7JYF6cYqVcGiWnm2iScotaVdaVjnE8CPKrYH51zFcQxnMoYLmAHriDNJ6uW2vPtNegGEw4iZUzvRqfOvtVE',6,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (728,'rkSdIKYNGUn','Hs4oVJeSd53K4U3so2Ft2dSqdYjayrxs3OCOe6LH2scIBSzOuzmoARPrsvsJ',8,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (729,'0lJYYzG0m0OpFmwTgcaGxCijvERmwW5ZsGxtwPjpoJTwvmHu','Uq4qP8fiUkN1KnQA8Zjynoh576iobOKXTvfzaefx2A07NgfC',3,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (730,'f5O','OF0QWSBr4oZKJxkmEc4G',4,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (731,'d2U6cUd03ay5wboxDAHniwikLlNYyDCbaGmJ238xwwaF3u','SmcobdmobXa3mju2lsfS1NdmOYPNVpSn2hRsbP6WFaY2EvVV7qI504HKwOux2fm',2,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (732,'14Jg0OdV7ygjadnwoNCLBH4CxKMDkPa4alV74iDb','4rJ4ChQ4FN4lw5S8liwHyTjqUqtMB0YP2k5uUU35wx5UtYA07Qq2BbejWhTODBzXsXRejjqBnnSUcoUqlUGt',8,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (733,'WHoeMnjFQfMOGi754e22p3uEGOf','fmbGaOvDq6MnPzoSfvL',9,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (734,'mtYRFx3o8VNMMoh2kAv3Mzhw','vwngq7R4VgMVH0LuuZ1w2ECkxqLuJivahYT8QnshL3C5kbiaJNolpFDQVJVDbgiQcgkaVlE',2,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (735,'DR3IGqIV6UsEK3gLus8OYBNZ26ndVky86wu7MGYVgo','LBieHQYQaD11upZL87ENY53SK0rLkrPwMpLE1prmMBewNZY0RrQe',3,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (736,'0s0PIFT05nzlUbCJFjDBw8QRTopQMiDY6fIkq8yZyD','FIQHrwpCA38p1VBMq3R6e1cv1fLeqfmu5EMXmMUlA2E218uquTCPo43zd0gUUpLV5WxeZzR1ME4',9,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (737,'nmcPBuCao8BPkCAwQLlNItyq1skYZetMr50K3hTxbKqIIVa','6KREcIaeElaiMVHDh8widqOD',7,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (738,'tdvJTGyATb6YOLrz1xADOhUqq1BarlN3ugPgISMXtMhl2CqvFQ5aVHGCGmR','vzyc',6,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (739,'CqoJskhs1Fj','mbG7eAbwUlgl0H6IbCwrpU6c5aU6',3,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (740,'quDgFFjU8gt53qyZLARf4j81EwrcUAkyLrSShBUlnen2DNz6NAmgAPTS3msw5aaEmlgdKbtOs','ry2WS1R2Gs5dWoQeHSYYGGQErId7vKX1dvv8r1up5A7anfdFHJU4GaFCRHoI',3,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (741,'EIRE3yUS1E8MPVmrKBrIgsmqNesnEzwMCbnFIlpu8dP3MeksJQ2cSDGYxOkiRADMUPyaYq3eGZImJzwe5eFoiyVjrAHGK','MdRNhYEWsbfnqKhf1Ga8DTg1ZCw7NkMhakVZn5dY4LN7',4,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (742,'ydWGq4Sw5ot6RPgGiT72ZOJBSsOKuKla41lzSGqfveqkFR0Yfv7V','cqJaTnxgZjbJ8PhoMx4RLRoAgvNqRi62',3,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (743,'5s73j4UH5IF6','Dgkrro0Qe0rYuCeka3WnHhYhSsdp0Hhry7kmob',9,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (744,'4d','HwW4m',3,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (745,'CelaAaPW8QrHYNum1ri7dbQ86','hVBZaESjDEdDow078PTNodeljOT5pqGR61mko0j30hbsvQx2TDkPbfxPtNW0R6Xx8sOuJ0fj26UDRDGjcWE',8,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (746,'uqwHstrSim8N7ecfqkswByO0qmbuNb5iQaSNy7WvmQfkhjGkrdKkFdiH0XEBYNBpQx','PXGj3AmUO0vOJKRPLisuGcURKz',2,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (747,'2BST5U54MhCkdkwSA8Bc0zi3rMQk6MXS','xSGtj1mcWOAUIrHGc6RvRuKVLiwJ2Ts7yzKFW36L2uRwW1dnlHZkzEMz7WZc7efTPWaHqwj2qeodSMVgFWEPWVona',2,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (748,'ugmWXFPC5228On','tIcpmXwOREl2OfCx4KtzP8NiSaa4JnGjc2a1Np386A2MiPvVzu3',4,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (749,'6lxHZ1KvqBHcoF8bygvYbTYLBhJ','nbjTczAfcP4IkdYPk',6,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (750,'u0gheD3OnpUm7orxlW43ZQPqvpco3PBO8VjLSSrgmr2jx1flABSIkcUcCzVTXs1g5WBUftsYp4UPp1jn','L2F3k5WqbtNinmOWAKuySuNHDATwjPJr7GM1HeVI7pfh64bJO',8,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (751,'5klecYb','kxy2zKBjbIeKeovzZKIaK84PaPYerPKcbGtk3J1t1YzfMWGXqJDLxHSYAuwYo7meKofYwoDxJoWsLbjlJAduv6yUc',7,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (752,'nMo2','mmBjuSnEJj5AhKD0lHYX0I2RBFz5kInyhnef',6,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (753,'UaNoFOWeSlr21L8kTaOye6Us','ze8',6,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (754,'SACbWaS0Um1rIIZpx6YJlNWJCAJRwCpsBjldSSmos2m1XJSKr74egxtVsaYYVKv8s36XqZ72vsHBBaviOf','Z7YfXHWIZhltTwlnGTshgAflhTsyhqLS0PyRtcnQZiHBGBsz22lwmyRmRekdAKRM',3,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (755,'TnqFf','qfvIN4g22C5NDugEkdOQERg8pkKf0WAqXoF5gz4l',2,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (756,'VNr5ugwU7HoSIjOlPGLoXGNEkKeT523v1BttQL3n6AytE5eOjNBPRrZpTZ8AtH63Ly0IcNcvmrFat5JO88kU','MhoN7',4,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (757,'hIrphEO1mBZMsEDAOnDA2QhLdPA4i5cnv3Y5x','vWhfJKCbS5dXwOAuWPRXIr',5,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (758,'cgOMTYXj8pQvzoOKK31kGHLY8wXBoFRKVzSZvbvlChUEWNfcGHZAASZMDVXI0UHbBI640gmKVg4AOxmwaYoZsKMtxP','Dshoaw1CpiXM0s25xNbpO1bmTTyq4e7wl3GKqU0iD',9,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (759,'dtxsaYOU32MwNaBlJAhMAUzOqA6w5l','BwXdSzo4a3sP7XXYcjgpmActdDCiWscNc35rwLQGEtqGQo5qcCHds8',2,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (760,'KbTY','EitXVBSWzrtFw7tpM',2,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (761,'gGhuDEdcaQiIEVbKlqeSziqT','5ppAODTSgOkGAKU5J0N8xrRZD4vz4OVGneCT3aAcylbfGfvXxbJWqosn',5,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (762,'ZcUsxdpJjOOvmpgdmcpqFep1irkQImxlkqaT4nbUZqCAiDXpifrTaE0m8jD8aI360KomDKdIvBt33yebUS','UZGpR5bWpXwLGfhKai',9,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (763,'lDugJl05NT0W55Gven73Gl8GqwUn','LjP5q6zQ3hpX1HD4MXA6TW6uxfq3aDJ3yybjsdpic8T2rD4SeVe7oUr1Dv',4,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (764,'R4bjMMUTTWk','BjHBdkQ5u5pur',2,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (765,'eOxInocVR11RRQIzVDPUDsMLrFWr0xWE76podmIiLOJ1Ig3cOAWWWZKWpgbU','LNl16CbG1kwVDtIYSpoABpqhdHldq06QNJSao2o5LWQp17HlQG0BsxDwe5F13U2PUEVVxU',4,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (766,'Gg','aSYocSO73v8LXg1GNqchipeSwBFUyQEel0EGXnHFp5PCYfBZrtD5f1ZvtGm6CNpnNepm8uQ4HJQJSpjmxttr2eodJ0',7,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (767,'F2q3znKTINbDvqP6ZHAt6I2A4edRJgwV','p5bcrdfdFYvnhq6',3,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (768,'x3Rnj8jdXHhY3PPYnnjNr2HdB7O0K07a','oIfCU2bYbRptcJTk5cCpnXw8C8CqDoopXUHYlnwKKdZZQ0GIHmnrgqnSgys7Kz2oVRl8lQKv8yLqYTEbar3ZK7TU6B745',7,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (769,'aK7LJPC40t1UCEnQHEOsXOyQy478EBjSTrx8t1tPlceSzos6Xc8','PJqdHwyvPQrBNriwujVjgc3AnjKnxYBMQ8HcMnIYwXJdTZxwAa2wIMdUwE1Ydx1H8icxH5ZVQbiXjngBPqcfybTP6MuqDR',8,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (770,'k7hz2KaWMvmOW1hdjDSgarGeEWl36cMG1TP6r2jP3CAr4lwfVW1YWmjsPjQVv2ERIUDyuiT5qD676MU','agPwvjF6SMAABBW70tlGXzxdxTuFi2PHK4cvVxvUcb1rNeR1bURnOY3I',7,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (771,'cRdtV2V3WYHSaeBahsm6BK7N05uJA0v64kDl4MEVMVOn6NcsjTc84XAaM3TM024DnSl1','403xvHSgG6Dc0OXUjeRI4xLyqsyLnMxUDQ3iTbYuxRlvXIyPsqOBPSSms7qihtj',8,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (772,'dGVMfIkhWm7Ve2o6zG8hUc','camtg28ZrmmG2N2oByPZK8uw8Pr14Lh3lXZt07DpvWRRQLBkIuL7KA6sC3BxWMP',3,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (773,'TLO1i0CZQVxJWxD45Gy8opRypux1GsMSwTGdMeZanXSVZko4oQZuxZlgNZdP50XuTCnEYaY58Hog','VQrl58Sa5pLOKrrQSuH7j44hjezTmqyFRDczyjfq2JogMrUaqQnKSRfpuoL2x7hBkdElNi8oUmfWI6iF',5,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (774,'YQvhgWZ3zkIgb3GPua','MIS1YHtMVuVBeHaBUqWr5ZMJcg11G1ucxvnuQGzAq',5,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (775,'Nac4EQUyOtkeUIHhi','tCfZy4QssiLKXDKwdcTYpaa8BPhGklM1gkyWpbnLjWYEBKrv5DHDeJYfFCGcI4rTM5LuK5IPWL',3,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (776,'G3PPmPE2y4rMhq5ECPvCDabml7aaHoHBlEE507NGN0fRBnDQrfSXu21zJKBQurhnX2nW3gJGhvsVvScP5ACManr1','oSS2OTZ1aTLgDZavv1b',8,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (777,'R3GS6qNfJjhT3iRxxmkhBhHxok8mfv2PKCikLbiTyWD8PenEMtkq1FhcJqEBiTi50h47DkirZAZIzsUVcgdGwZSrpEZSICv','JypooVbSQDP5TWKOOxXCUZMHeygOY7XLv8K7VDqm15nxa6',8,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (778,'VQUwLJUHAwWvWAdPzgPzGcKswq24quD0xnVRYDPcyuPy2YeNOXdLjoljbuLWSEguN0f8ODTk0IvJq','mEIrTFtrdKf6ljKfimuC5i62ZYW6qrI',2,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (779,'HSGzjZ6pTPrqAMRyND7FuwbetJuDYf2x1d3sm','VnMUIUVZ03xWfRbkAE2H2ZBMkMSQpJScz2ziIZ634VvraskZsaIs',8,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (780,'fEOqHBbv5iQn7Tad1uKGGmM4EhWToy','DA2tunzX4Wj4cCwRkZbB7iHUOiEs1elBOt7fEZ7pH4aLww64YvkMfIbkJpsTDORQGaG',3,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (781,'YUXh7WNlQtWPJoIMRA3QmruiKsjudns6aH','AqLnE41Th48hg60w0uRsrVgYIJ8ys5U27v4ehjD0cBIWFqjRV7gvYZA4bo0kluVDLViyMjCJi',9,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (782,'SJlaF2csuzpTvEK2g','8NJPq2fWrxgseOBfKqWWmS1aSB3XpiMejak7SdB31fjHZd',4,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (783,'DREZsdcsvH7eUgKXsHfx2cIje7uwlcSHzCI27YCYeI','PQXAWsyftXkFuUcMizM',8,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (784,'Y6FEKXgjg1Z2Yl4nc7JWODaYc4UIhWYaTNQJogltyykswnODCQEpCThfR1em','O',9,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (785,'aKTY6N3Q6UAIrwmxWAsGb3gWeMGayzxek2JmdwroChHca31iP2pcTGMoMP4q0t4KZOremVoWVrGiOXRKnwTw1sLn','XbIb75My3bLj41Aoe3qHgfU80YQuBTCh5DwB881T74oXMl0rHJ0VyNOes4PuOqVNrsEesnVHXbog',5,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (786,'0lvqfKjBG2Xiek8rnUF0Bdt3y43c2r3MM32hJqFoNtTXUI3DKuu2duKtZpMiybzOlJFlHUdmoYA25jpkylaY','IgDxoGMoltYhCOZUN7G4BoCNtkNwW3eOGGAbblsJMYlpfcqLiRmn3E7bV4snMpT6jIAc08iqawDMeTzMxC0JjabETHx',7,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (787,'w35NT8d67L8jYsfXGiWJBVidYQfx4lbCMMQwrGKzatCrBDUhtNPhSMEqGrplNL12D8iUisYsZeB3JfdTyTXv','dPGGwaEAy2ALqAlFc3NIDU0PVCy30uImppc4d7uyRitDhqVYnm1rrc6hpOnMnjBFbuDEFfSY2qm7X7iRw2jcZZb1qSFxgv',6,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (788,'FFmTkKEIlH4gxnkszsvwtX0qgyDeNfLCD8rtPh7jxXQj6jU7OpfD8D4O8SpBLPhNz8oAGzWsqmEr4i4LIpctcOI3LDJRlJXLOmx','xmhRdvm3ZMXuRKfeJHhrQxsyTNWLWwminNAURBgecOPWBcvJO3boXRoICYVHjDf0PORViRTOsJzJoFWIv2oTukDFw',6,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (789,'wFtIQC1yFlWt3gQxopTItIIUUxuI7agNeKu58oOttcDcp12Qm','MESm0BEEEaiNBpYRKcIyLWq5MX',6,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (790,'jQYQsW31guOQkOliwcf6Wkk4VIBloTZg1LEyvSo6XrspZvkMOb022ndZqvm0AOet','I6Kms7GzstW',9,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (791,'y3vjPn6vELuLAfMyjERVXOwyDyavc0vmjVctCT6yfuoey2lRmzNJvB4BTgYsjqDaAfQLFsjAfIZCdlaBay13ot60AxASq5iR','FbNOhqch3FbABWuumfi5G5fuaJ6UkxFtbyHmqslbbdUqNPcUXIXfWOkRMZCVLu0cOIjScHM6YmyoBcRYmK301Q4QVzXCtKleo',3,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (792,'zNIo4oZv8m4TJnk6eE4VSMEoBuu1PkgzCYwWw5Ouy8v7DLWkXGd5Tp22QllQ2drFDKU5A8bXSqgS','iBt1CVFWqtzq6pfT586zOQEg67o6dGwORceUEEHS6eUcr4YiwetgXmaoLoi2zODYEOIV0huZL1GHTGm',6,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (793,'SmvPonHFO8SKzbWTAOExjjF8Ada08X8XPyYR','hEXYNjcMhInCAHugKQMu8eAm8mBsClewCzPJmLRwN1krEZRxmxPPGSdaGrSz6QLVJukQj6N8U',8,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (794,'L034TLC78yH','E1BO2vW1JpQ0L87T7jh4w547eB2AeYUfJNv66twW8UNSTcnPnbtXjVqIuREfnUWkbcO7oxdK4Mu2PoVxbIV5',7,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (795,'2EWmRwhaAM13d3xabPpr8QB7UXPdWDwrOYaCWZ7L8lJEf4cIxxjbIikR8UYC8cn4zIvChfKYJzj0RN3','LCuuV3pTb8OlGlKpvRp4P0CXveXLAmd3UDZmyxUb2BI4QsXK5ceA2MPWadfobXaxLKSEYCGddkfd',7,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (796,'3sQdFhVuOH6zlOc3Ax6W3KTjfoR','DZKmtwsMKTEGSz',8,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (797,'bd2uwvCnRaeh8fjamedv5mAl1xuYjbE','1GpZun6nnwiQujx0ZTbEdElnhpDsInZz2bbgndfS7bXyiS1X8se',2,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (798,'jvXJJLDLeRP8RBzUSRQoeA3UuEDtPgsKuRcJMgophLICvey6GH3cAciSjUvHM1eyVbJ12VxnHLD4GUGKC1ocRESrMUt','lBZA2csWPc4RjAlqaYeaS0qq3z7WFMRD5b44KdKQrp7eaErqS8rMO5',4,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (799,'FMb','ZLu1gjNB6J1bZRRjGKvcL8phn2SGy5HFALPmonSn',7,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (800,'IVkO5sWT2ziqiGVMcIzOveTG05L5BbbBxPsweLDsPNiCHf','LrucLMyM0EVQtjMmJtresTvqY6132OhHywr3oVrmbXlOjdKy54nZ6C4PG6v1OGJjvj1ao52MC',4,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (801,'ENErhNlHc8o7aL62cCmDqeQY5lPHaUhWQj2aGSXwS3k641H0Q6mAGwwbQC44mSv21mwy28jy2VTfdjoxfq0A1vmz7P7WAtqbt1','f5febTUeIXMqum3GFWAtgiJJxw402KOMS7AnCHXwM8uONs5tcWgSWz4NBZSfh6DY8nmKUF3voewDrsGGquMKGqB8jRa',2,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (802,'4HV8QkPo0GKuDgY0vYMwyqAGSdDySWiNbH5HyiOnyKInIHHD','QzxA6nI5jcniEDSUP0VlWHnWXCm5DHjz5vbunZl',2,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (803,'uG2tvJKLXu5SfWxf7s7Qe2eBSSMO2yI5CvcHa24MgzxjWT0nvvW6XXAgaj3Ha0CB1C0','SLyUPHXnrBJqmtE7eF',3,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (804,'yCWCocX8ZASbwdKfoXXQ2HwtN2XzvLyETVoajsc','VfTKLlDlh1pUdTDrVbiaup5ksbEPYWpDhA1oQhmL4tPmrikOtbFhXk0ia7EA4XgHVIHBUYgG1nkIDHSuNtdfSNlPQVewjjgVPis',6,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (805,'GBKlYX0V7H48miUCF0C1XqHQUaJwES1qJ','PYteNAWJGTC6i3ZxGU1kpAlF1y1W7GyobAyJj',6,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (806,'A4qbvGJ6cP7noQRUGcbvCAHjuPLm','OXeEuct',5,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (807,'IsFFwaFBxd0A2xTubKC7sogEPaj8neuPisPDVPIiqnTdDBePDCgdVsHcCFg6ZeOZ5dZOPJei5ToXJ5LuMfsMPvWZfL7C3','L6G8NhtvmCHCMM2e510SbaXjz8bsclqQsIBWs7OmRkotNrtC6MvHxqsbUFuTEbpJTSJD4Y3EQyO4IqsftZ0ldSfrVPYKS',6,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (808,'qYKBaIu56RRGx','0TtFW3N0Og4tPlLJ7IvfwvB',7,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (809,'CYqGzImt2lq8GwReAWhCZdprGqXZzMSoJTHHSI6XPuN5ZTPPsxx6jFzgWk3MgRvhZT2ebRd5YzcrN2eRz2KdCvzNyA','E603qBdoW6bsaxTjfseB2XbFE4MQU1NYUN8aRt',7,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (810,'ZYxqBJFzlFCJKv61C4qkQXZIwt3OffdkZcHGCBkmbbSO446NVfzQyf51sGYJe7ogr5UrYIRWoXusymTnOYwx5khW1qo','NStAhjqH8TAaB0iGgBSGNESp5PjesDJpc2qaZybXG03N2iicvyLDuEGGOxWNYvLFnAlKGqtgT',5,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (811,'kjCIcHzHN3nCcoEIbW','XSZ44RSKq',6,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (812,'QlHBXHFPDsAy8AyaaJPh2RRdXJYaVecX7H8jOzRDBOaUd5hAI7mKEr754pHUuDw5Dm07uAJ','uoCAUg6jGvt7En8v365iviIyRfDrX2rgigKvtvH4',6,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (813,'r0rQEfZTjo0j4m0Dq7zhhjenYacUvl0QYpS1pddL8ab2G8kBmwdlXNTXozxc3k8bsbufblanvD6OZO1CDPzeHSUrCmE2r','7JYe4LbwsSCC1dObCJcSz05RjbM6e5',6,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (814,'8ebQftY8aN37BvcZvQL4gQPvclXOK','JisGCpCguGyBjlUqsiOCtdoAqp0JNeVtriXIcQCT',2,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (815,'D1rUwe1CBvwjNnIz28S4YkRVjSX6v7IxyGuLMLx4v2uN6kodefl0nAiMKByBERrEf3JtNQ','iu8n1u',9,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (816,'1jmgrSIZ18RF6wLrupFcmfFvJVtSdMbgzkZLH3iWWEEni1Dt7pf77rdmX7jIplfZsQHMTrdB3bm1dDAsAKp','v50RJWEJPnngboFJPsNCQmo6513BfoR44ktZBAXYgLmyuiXD7Yv',9,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (817,'gSXXZmiMm7PHvaOndbYHuCRZsCzFsoXN66ehlqSPvNb5mAvNSVYQIyA7ut6','lEPyikqcfy5An1bT5GMIvXu0oefRx81UbpUZmnA4JqXTkEjc4XFjKifer0v2eDAHsdEjgSjKvvwUe814c7jV',8,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (818,'ETI','KGccwzGXtvctwY00t',9,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (819,'jNcdjQX3gUoHHRdDQdjn8pRM1qpyk0zK2jBDCEI3YlMXjfBsz3biyOldw3sbPAD','mjXydACPedYnat6Tv6tQS0ZlWPTXn4iNzhKzW7ABZK7OP4U5Xhl77ylzIJeNjvHiquIz8qkA5jBeNb7ESpj',2,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (820,'Ir6UwNuZGVazW7ge8xkvEQCsA3REBanFzi7EG2the0hn','aWipquXj8iDmUUF6eIEylzt0Q1GnjAQoqDBlWw',7,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (821,'jDhqVe2KbcYU','IYN4Q83leI6nZIlc8hdOELusxx57KttpTv7UW2',5,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (822,'MIiS62TYCTQbnFEV','Kn6zvqTzJTQlsXQriHBbmBF8euspZLbQU1ymebzTrEB8SFI4zt41pH5tFFGNsvvv80DtwgweTZhWbmMtOv',8,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (823,'8AOrp8pgcUwDncyvaTWl7HVlHpKAmOxZVL2','hYRb530QeadxNidOE7KHW76KUyiY7aGKMFGrXIsT3jmbOD7mE7JaIb3F6zM8OgZdr3VKTPr5of6EEbM',9,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (824,'jPkT8OffB4tkdDqVg41FnasplVAvhj2xGvWG','Q6wv2IsKPBxVAbyrI5X2K7yWox3Fe5CKCFA4fvL8JsMFxW3gZX3fx5qaHcIvCR1beW',6,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (825,'DbqdZrlBYmX6xHaHSUJtpVNKNdhyDoHOK3IwMigTVc8zhZ6AcK1tyRfI1TpHlXlA2nhKqTWNSLCiTf6M42OX6amS','AIdYu5',7,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (826,'4eeQadmNXQPrG8xkARnIQnQSAjoBlDriWiTEK18bdjVbH0EAaBHTcrKyvElRHlO1iNSIEiLo8yjvCT3wtmW6P','VgS5WLLxV2MitTlOPvg20GfTTowhpxuGXC',3,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (827,'A1mwDxT126hMHA0fOtkYBPoBCDbqKlOmVZcuUgY8LduBO5tgKuYCkuKvj6oL','hOVuvF8L6D6pcfuCDHd2iFUn3pLtTgfoPDIKMFUm8cSxPmeLsbNGjlbpEHvUjIl',5,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (828,'e2MD5loPhdpnEulo4cc8HSROXnGzbhqq314dGpbjKJDPIHqv0CMwiDGlCs2oNV7LWBBoehWBbGZnpaYywGro','oxmbedudrz4ixSbFJDoZMuhrJctkJQe1aYmfIxuM1qXHZF3t6d5tiweIjmnMgGQ5psFLbHIA5EH',9,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (829,'w3bFYYRoOCindlPen3zagQxx31UmlOHPlVxTqfsTPwlFhYlAMSC0MFi2VpI5IXzK','jsEvYPUFKhwpat023QxYaIs0pkRibRtgb8ld1XfQbLFnsvPkLt5wkMFlp7OQ6TG1OVT50IquU',9,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (830,'2PNTWM6v3kM','k7fP3IJSPv0fE2YTIRHpYDb5j7V8bO0J',7,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (831,'QX1','j5rBLvqIDkcaxO3gd7ZMPYfdXo5ZwbGDXwEGjWUCCRJSDdW40z6ZUFWKOC8ZBUba1dM3LGDjqO1D3n',9,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (832,'lH8qS4gTNZpjWVQBXNQ','m2Cgv80',5,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (833,'ZvoxELbNyAZlja6D2QfOTqE6tb3FKSfjfBu1NWNKL2yIZCTKFWdcZtU','6AwikcD1EaUqmgQUk8EVB4ueB5SAjN6vlVf6MstPe7EoTmiHerqXvsaIgeUZYYTmWRWGkWOESTPfkLrN0',9,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (834,'aM55ADV12dycbFV2m5n8G6VBbGekZQuVxyXwsqzApmNFnCwczXuooj6rrFFYJKkTsAnCrxEM4JnIHVuK','cookJm0M7vckqMniNtDpC7Gl236YKNmJB0hp1',9,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (835,'shGO0mYqBioep7MuBmWTyxnqRMYe37PVRxgFUNJpE6nz2SUZNyff1JUOqmN2fWqI4xPYuz5wZ77zHlNmtVL1f','u2zGkFnCOoR',4,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (836,'5RopaHkIDFe56iYjStpycZeqjD1Yg11nsTVtD57uixVdKXgfAxjMQCcfirlGNq7r2orFF6FOiLi3Zayv0X43qGcVnig4J','oQlRX2ADtL6rKEEysrAaPWjnzwy',7,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (837,'gKdrOEFeYO4XtOA1EDLncRRPGrNrAhvKLytanOOF23uA41cDWO4d8ANEN3HeMzpHKF1r4aphVECQhsoem','fnCHiOwHSKQN',5,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (838,'TUraJB1tryogGq2EkLvj1FqLkP26cVj41CDdvmItPzut5oGC3xlFvDl42yhuxD0RtnRKoc4cSLo8vFG','1Zo0XSuGgI76YVq5fvx0B6Cl',8,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (839,'Dbyto2vLqClNGa6EYZKLTe5D8VDNieAPZMlRFtQM4EUMirPNhIfcas6','aTKx7Djsya1KT8KUystDpdFIq25kD5qPD32VuVEKzpOwNXO58I7DMEWcvpYrk1GTW6NSHDE',4,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (840,'HM0l43x3B1DLgjlXsF2QTSLBBnt6vBnE60ppo','QcGYcSY57KglzNz1W0MO8yYymhag4cq83vpPaVJ8WSL50jIMYLJeoEKjSkDWBeH06NVTOzAkF2jkDoW4mN4kisSH7bGe1',9,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (841,'gMZkuufQaoVonVkUxYLd6uUDAIlrfd0snfru8wnNRfTWxE4rVKtJtk52NG73bTA','iNKGNgYtfdU7FxzA0wGOcQ8BTQz7JYuaiHAB0fBVQKtytYHJkF',5,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (842,'kBWRhfe','KjJDrJSyLHhNk5sa6',4,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (843,'LgnFjABGQpREbXY4L7A5v37hQvJVYpyCzygyD7VbpDSoG','7mOopzUHqtf0OO6eXI3SrBzFfsGB3pKJPkiGV235pKXKQkQiEWkZ6fNXhMr5BHJfBHDbs6aows',7,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (844,'irMFIXJ6PORqpt3PkUqfYRG8yVDvFNcvGyQJwhGMubMxOe6nDnn6UYaFbUcpHxbcjeJGca222S','QDPBmWaiQGklVBqwv0HcIFj3rbZecWJL0YdYP5XsDp8xIaqCXQtAY7XxNjAQDxfiyyjd',8,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (845,'7OiiahcfuWUAUetrvmDwvyVbSw7sCnt3xGYspM7krJ16ArltUYtb','jinBZz3jcYrtYzJaC0cjLNEcVskGRYCVE8EtWo5B7',5,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (846,'wWo3ypz108sI7WYU0rCjhlJyiw1tfMfqW3pyVBZfzSd','IhlilLVl1',9,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (847,'8H5JzPyLoTag0tFvRsXzhJqW7Ts03u0v1unJfsBx0GeJfKZ74Abx1BsoPLOzwjLuVLVXKDItEnDP','y48mGkpTh4A6OunISe',9,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (848,'75r6ONxEOxeOjc7xwZbfjRvodOLrTkhQL4X6zPYiQ2Auw4ITFEctkbOVt0rbxDGmNH5X4MZG7k75d3aq','o',8,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (849,'n6fgmLCnoELDLz5OK5b6ktMLCCIy4SpScWAVy65YosjYIsyZsfNo','GDjMAt4446n7WtvdrDbHeClsOjcepWBQrqqmo3T1i6D5PYALic8',4,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (850,'KzSmdXzJFGr1p7V5hyDt6B','NnWcXbFgBO5W7HRWcSySxkA4D4mHYNUmg1WYJEVuBTIxeIpNqPtsbPc7hek8XmRcKIGEj77',3,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (851,'8Kq7bZHEwYmEeKuUDDJMa5KCOTVuCOgEcwkIwvNleZXyHd4H36JpRvQDB2WwdaahOyJ0OWCJ1Soj4aGBlOUc0dFs6Y8W','7R678FlBzy7MpG2fcBJYxbCNQyOQ2rqKtI4o2DGYufI84qVULoXEpU',8,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (852,'wvi2doByiV1stcGvqtwQFsIVeg3zUxLB5AC','mF0pa4o7iqDSrYeBtexhfpTsRJAL0J',6,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (853,'uuxFNHLtm1URtIUv0lSK0A1hnpW2k47FKHTvoihydMEBXDm3aefS5a8k5','Uo2DIuu1fShpmA4y7efF6MA5DBHOTeC2rym3DA8tGanLzrj8xEoXxNKXtbrREJjRiiwQygx5DqV1R0JZ6qFJP4vSRJtCcmRy7j',5,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (854,'cUSlJJNmEnncRXFKG4xgKx7kz48lX65KIpJQvvAwINb0B0xa7W0ZquScbqGJ','fReGYS7tpY6KKLAvWvC6kBp8p0DtfHSKlHIXPXKimDRYOnzvPcmYMJSKDZyOfM5jC0OyKpDBImZdZIU',8,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (855,'B0OWgJGSCUtgZMs7gIE3ReK21QmnkYrKknpdFHmtnTWV1d','rwt87QTXwcDnBgxWQG20Se3fk2kfA8sUUYSGbtUfsfarxLDiv2rJDUMSeT2Kz0KnAtVy6L3tcNJr',5,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (856,'Gf4lmgqPwsoEvN','y4xSRJBnCTlLgPouW6p27zz7',9,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (857,'yBKBjSpxJBK4iYIPIqf02zWJF25WymAqnW0yWdKSjJ0Qkhdvu3dcdlox42hpYepQkBaht','nbz6H71UHuom6Bq0Uf8lE6lzntMr8uEA35FQDF1usOel1rBWsqKhVLvCa4jihwBCd2HopHDH',3,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (858,'MUw64XApQ','eNrZ2Ax5gSEaTjXx36BwK8la4L0VVIFkq0bsgVsvJ4srVk461',9,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (859,'OKOcNrfGhvjlH2LhQu8','o3Cpqe71XqW',8,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (860,'qMNaCFSlGUFoTCdIhz0Sq6vNr276PXi1LapIjLShiBmnbKHX21kV8QoOQ7tQYOOdJYZZQ3D','yRfH3wtjIbmOHyuDOPHSVpUlkN5vPD',6,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (861,'kCAoBprXdvFGcnXpz436HhgWLsemC','eM4gWrh6Eds0R7vdu5ST3eTPReLds3vR',5,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (862,'qcSHizI1V5evQwvax8WffIdDcX7uu','60xp8ZS7oEdIDuxxYEg8VS7ztM5CCaSgKA8dnyMnQ1xMNDdPoFdNCDR50EzCmSadC0',8,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (863,'4o','O05HuscQDxNEAXmXk4J1kOlaFsMBbhtgsQyDSpeXtg30lywSxaIIrzr',7,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (864,'jnTn2SLOYgB1DcwOV8wv1NRnfHZ1MAEAHBAGO3EZO7O2FRc3tzbnFpcmt4461cn8YCZK3xvtbVF7','gvOxEfmH6fMGWGbC14iu3mZjvitqS80WtLXu838beA854P8zLfCKjlhAHYcBkc',6,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (865,'7rtCW7gg5eTca7kQbWiRpkAPHf3exNH02U3Yn1tzeaQ2pnPxgtTsMgPUU0FcdELbJEu4xMelZ0pibfskjK2Pt','udAlkAwlrTBlO',8,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (866,'HTCNzdHauxaislViOIxGbCSXgyHYd1p7bKcR4JIdTVTvpgeS6wUETiiPWMIO2cFQKZC7UFtYwQqyzZ','FpSddBEoC4NiP3PTqx5q50Ir6pRkuy5Hnj0Wsn0Wdcj0BX8zDcUX2XOB2kFdPPoVtNjiAmib',2,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (867,'VAgZxdXIphAozFy07TB68Zk0msLZuoJtQfanfVBA2EgnCbbFrfG','UzlwEs',8,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (868,'vV4rM6QxV6tJCQmUAgqZDwpjHVbwE','J63gNdUyjRBnYcfA4egYfLBCmGLyGmuEmjVa8vJTwj1RMqhCSJjGUWYk57LOPktaHg7',6,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (869,'1oi8UIvlbzfupwMjTny0KkFbsvXMugNk5tMuS2kEzYfSHoEVnAhzLLFXQ8DfqJXGWnFuPwLOwfpufFIq8bifPHSAcPUQka7bpXu','r20yQwWvwD4wjHLDrV8w2Vefesm6B2gymh3jquxDAUydkTYPDRvMUMDCGPDedPmDVZzeLg8ILuarr5krAwE',2,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (870,'XNTBYpKbaoCS8yLRkWn6xFpj88YpTUfclWWNRWhlbySTRyYKmr0M7pmrjF2ERm215L','of6dLMivVYjyI7od3uFwFLi3',6,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (871,'2gTK','pm5R0FTJEYRBufbmaCoF3AVvelzNg46hB6yG3VmCBzi3Rw7oxHqgLYNr3l2c',3,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (872,'bANCrlQ1Vaqac84ZL2vgQwFb0U5rVirYfHWagFa0AfFNaUPAnz','cm0iwLetUa7WzMWxtzuxp1lIpoH4',8,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (873,'8gePehd8UBBV3lOKih1J4cztxwBYq6esX04CEP8m7z4nuTMIWS8QSeBCOLSM','iEPN2B2SowhMc8TRohRHTQg2z6WtagnbC4eBEBPrKYFyFtjvC218ArfX0PrymaAYoNI3z8',6,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (874,'3JqS10C8VtdO6mJiZMUzVcfLZVCkWUSaIHxEmNz3','u',6,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (875,'aJ4AL7x13x8HKYsepwzrS141Rd7B0Zdv5raF','BE02TvkSnABtXo10WmWtT1nc',2,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (876,'3ENHaFMTUIVBNpagfMGBSODdGD2ZhsXJLEtFTlywmQi','zHq5PiRsR',7,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (877,'YhXCiROiFF4KYlvWrj87kEhxiOIscIhxyvrQEZOztnOgpjz3H33aJFIHFnt6LkTKyz5sN4b7V3bSNjh6weA30HgaEdXomVg7LEt','qvZyVUeYVotFh1t05H0Bl6mgBv51Dnn58RWurbwXrsz5w4ZzkCw40mK3w1Gr3e',6,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (878,'WvFxlhtHv7zdWpbkLii4NFwriYfnnzYn0otz6KwPMwNus8JeYx6fLIhkkhja021Eryj7yQbjWnFgRWVJZ','c056ouM5JpsN',9,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (879,'wGTBwjAFREEXAd3ljecVeHKTuCvA2z3o75KZz8sAcjIoy','WEUuPE2ihpmuDHqg41AE5FjJOvABkNzvX5LO51fQzn4MmOl2UooetRQAYl41QtENdMxwQYpEp6fxcXgBkdXAXH',7,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (880,'z','qpKKryAhClxwRMdAhBl5KrvhkfYoFQiNpxb4PkGabLeZTxpgahtPlRXgHPESHHqRk5MJ80QNmVusM8DIzDhWR',5,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (881,'XF4qd6s7jOLW8HnGq4VPPImpUIFFwtZKkUJJHl3wHtwrDqgGbY2jdpmzIBJiYHE3aoEkr','jmR7e2ENVFWWK2s8ZFj5QfcQBy7tFKPuUvt7S78bJOkMv3p6fdx3aaofLVXUOmK0ShBN6h',7,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (882,'WW0s','kzfbXIsjVkkujbjfOrHybHJBMGmwOyuJYaseGFm0ZKRyDgSiseRxOCp1bGZStMWNYULqV27NQvecIydHwnF6nGEs4MCxmV',7,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (883,'Ri2NyKl7TBkEJAbm5ymw1I6NGT6oq7fIyOfzCncFPpOkoZiocgZRQfWgmQ8Q1VYIe02Rbf3RWCpfFPRD2JovGWuf04dvzI','G18Nk',2,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (884,'BYkcMbhln7R6VgHGMsYGdc4E6wi3e7otOIINDGHFbHMoUR5lkxVjKX7YMjBb7k','TpbTOKj7',9,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (885,'d6lpvVKQptNynW8szAyDzDN8NygVCa48KjYbCtyXos64mD8PlQ8wxifoZeu3UWgOchZk4YmG0oeDcTpI41VS','MpSZrvwFoUZkPV2aXjNtPM1',3,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (886,'m6yplaVhm4knKwo7coUghn6ZH3S7b8e2G5TYfnuKToGMdvDu6eVYz6AXKdsX4SmbsgAGy','BRN0VZEN0jsPQ416eebh1Hj1zZiUrPcGm3QqYyCP74VgvV0N2O7IRX04XBjGRb2yaoQpiWjgz2oZTTO8Op8',3,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (887,'x7MtH','h6ftpiSY48NPjdqLTGCdWqcvlroUcA05Qap5X4cwh00FUGi8xkYK4Cc2',5,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (888,'hA4zAmuIJJlKWCmgF2EB2sABy4lrDvLEoST','ikjTpsPgoYnQixN3RhuYvK8Qi66wIt0SGb4Xe6O3enBOU1VhDaI',7,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (889,'8mXta0ElK4CnTIK4HIDZsEBpfvPi3NbrZbQcRbJqbZTBax22aZDHl','xFMGlzPq6dozVuwdHOGDbEji7xnXAcDdcOGjSVFRqBZ4FioyOO7Rno4SKeEyOMqkiabHTbW4fwXyVkSZhW05eod4praTSx',5,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (890,'WQfmYvw1ePANWRqz','brGSN23VtpY1HaSR3oItFwAd8F5OXhFCv',8,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (891,'LEdvY','hhnGixsxcq1ZaHJHBdIHmaG8oBxY6DuYa20GQNl',3,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (892,'VtIsIeNBQCwiYrSpxLFK87F7rlpdf0k3DTwmv7fevixqM2Y6eYECVzcBz1RwwQJWUtYqyKZHByBQ1m','YneF8bDfIQSreCCUz',3,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (893,'3N3NuqLj74L7ugCXDLnkNqp','ldz',2,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (894,'i466yhq','K0kOU6EmhjFLGRmYrJHZChKZR851DZabsIthnBmym0RCVqizQmNXhQNH2MZktZEqvnmUXFhg4CUBvIhdKg1E0',5,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (895,'wQOA3LNhuab1RWzkffXUN0jChLaOTgt43jX0UKQeJV87n3GHgyl8a2rK33QniBCYJDF','EeNhTvLz',9,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (896,'JMV5EaO35A6vbRf','nwH6ofR',3,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (897,'Qjlxypnj8WAHTc2mq2urLIHcsVwi26VQtTRGHzsr20vL0oe','EMHSijJVgSRUL1oHvLRhEOekX38EY6c1vV',9,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (898,'TGxlLD8AibcoOlKuxXtGdmUuA3Qrfcz5ohk0eCrH7A1KiJsKcC','Ybzw57guNRCd6SkdSbPkXzbUzK8dZjeqfIoy2yDAtM4MnC6ma',8,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (899,'dLGPqTOpoKMVcq0R1N4FBsIVv5IUtOFwwAnwNdSQ3QUGtkTzKTNswGaorxT8U6','0P2D5pVaHQkBYGIotxjNahieivGnpsmjuyWqRtGSPmXLbJU7T3Lf4Wye3L6H',9,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (900,'4VvY2PGndsm5nePGXIlWJwCxfUtHPFsNbo1du4eSZ8LbCiyuwEHXZvowbeiuDeCPYYY4jPU0TAWYzrjuTf7Z','4qvlyda300ZObh5ZHRhtjFtnaLaTKLbBaDrvdHqwPKpQFHWxOAPd',4,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (901,'A44ebqO30Dmf18sPEELLC3UkM1k2XraUdooMg','rU84RKDFAtTrPCZHokQFnxpVtpFEKlKYU10Z0MqgAqRh4SqjoYRPD',7,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (902,'mxMKOBNUI7J','1PQ2B5Go4AIjOmHxpLj5YQelEr1RFaHkg46O1fKLaw8sT4gR4O8SU3DNTWDXKY3BOSGiYcDcRlDnM65KsIB',5,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (903,'X4UHIL','8PKhWQrfUCH8ezPZXjpeWSOOOKHba7agXW',4,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (904,'Lnz7lpWkyX7tdQF8PWfWnUNe3uT024d1ZjL8AvAEkChG6ihlUo5Mmu6GkeK6SgbJg8xeTLN8RVUgfTfIh','Q4CHQAoRkROtwZzQYTGNtVEyuA8qYiSLj2hbLU',8,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (905,'mNrlYNWBNCEgSg','yhVbTMehN1eKZGtMi5aWqvJ2laJpw7hpsOXlLvM7sROlJ1MRZwm',7,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (906,'ZRZfKIEnPCJOtj22hiZEingReKdOeYehR8V0JoKrPc8axKj3FBW8dPh5aVy8ewt3jeotamDhdmV4GQfCQ45hufV','ZXcUjXRe6xaaFjRHGRSIFOjUPKokCAqb0vCzUwm7itMbrN0Snu8sX7CzZ1O8HfmTCna6UB5fe8JBBTHeeBO',4,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (907,'QlGlaG1MHqJRb740vHc1WC6pIQsq4foKxxNqUyFWygtH7R51aK4tsho2cDVogzT8PDF3DZMKUcc0WGaTOU7OBejVxMgB','unQ3F3060eQEQnp7rJePdzd7zVrwIo5a0OUaA4g1iuV7ByBeonJbIgEgCWhIviAcVRSbcTqFKpfX7liPv2mlwAztUjkLsNNc',4,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (908,'Y8XndOIdD5R2aIeNMKbVsRx8r3MQ1bsxvgPaG81zG4cH0IdY3WBFZD6nfr1fgaEV4Af3','vGXfskqVVnpVsvZJUwJp6hXszlA165n7MJCAJ2bs73ABBbu8gKfYznEZaaRF',6,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (909,'1uxxb0GkI138ZXDqtP8','0BaMVbjlNKQidlqug8',2,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (910,'fq26iSFWDfxwevrw6JGfruXr62','ivdRNMlHthtBUm4EKKaUyHzsZD2',4,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (911,'RsEfOfh7yLApHljZePorFzJn1RmL370u3dMzY0q0PpDrHSCvMmKCYxm0JsOkXlmmPjxTPwMWiiKWQF','KHodetPblis',6,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (912,'UWOUoGBBF8gwtm21iNvGXT7zlysbuYhiAo4g0Lepmn3B0IgilwLr4VJ','8dnljMXZJSCLTUBBlxKwuN3UCCAnFWnmmmB7coBRYgsnmMTcAuFZKXDSlB13gw',4,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (913,'7y8xTLvOlKnWssL','zHYhmojwnMW7UziI5NG0dfhxjhDqZPkqCysHRhZTuIvKsnwWzwCIO8CTdDFsNP7xSNc1vmmI0W',6,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (914,'7nsrSKWmdflPbAMtD06lWu0QSJDrLyw8FDs1curdQ1Z2dB5VkWQY1i7njFx5xxeQMiWwt5Bb7qLQNltzeGpe3ytVez4XwS','qYYADK2mzenEovP47dZBeGHJcoNbjNipgCaBvorBJQwarzw7wpFIgf7JdETJjdqHT0pCYtwhUDeikSwEERet7RYdXO01G8vnqod',9,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (915,'daJNO8T3vs0kOullABAD4mWh6CiNgr41Wkm7CWJ6E1pEXuvBRmvX2AsHXGRpH1Zaq2ojeqjbkezx3ez3','qzvNlfP5cwyL86tal2JHtFbueTbLYS8LlPBCZ61EcHdGIZQRacQqoLuqr4CRZHMHnMA0gdm8wUXgkaYCY',8,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (916,'KSBtwn8TXZvJYTouor8UVZXIgtoAfDoGj6u6xMYprQC4AEZNxUJ0N0wfVz5upRGTnphxYb1SAeouLDB','VPyNpTvCA1X80WzuUocLmwmQcf5GgcE2N14inLAjk0YIsZUcEBxQ8W6Hpr7led1IgrLsvctcmBcmDZKfnwNScr1wL',2,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (917,'4dOiHVc61HdbXHIvtlX3ShfL5eLKftjERHVelpXhRCSUpadpOLt8lVrY4MSS7qHsrEo3nFv','uk7t3VqWfRv8NnCgTsyNf2kcqNAwQM72cAftnZ4lhw3J',8,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (918,'1RoGlBWu26giCustTG1IQYamuMtgqETl7Jzkwo0fYoajCURDP3wvkNban','jp0G2nbhCCSRYiMDG6XqizxlvzJKEU6Wwv5b65EofuVXZ1rL',3,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (919,'MQH','Nk4fKmEpdN6oKu',7,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (920,'ARJ1p6dycIAjgIDmFlwmcxMA867n15ZwBtx8sL63lMoNSB2ryceglpcpG8jR1JaOL2KKCFbMhnYvSHIFmFVjgzYl','aCtYcQ4QFhYohtysIzuyZEe2wck5',9,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (921,'LRm8js63NfwgApVI3mMyDGUCyDh7QX8DoHWKBg0pGF8Hhv5gxetM7aVjfvfPwNwGowJknnjypRlMlqQA','L3MQo0YIinJgQJfCWxYmDpAtQ7Lv6rWsbuKGCsF8la7JT7yzjfnz34T7tfoUHTeJsrxcvSHdo8XYILRluVaYzcApCxREflym',8,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (922,'lbGDHUucDLiO1agReSSG','X4ks4ZYKej4wtIEVUCcQSia1ufHkkgctizGCZFTRtzjeLhHs5fdp5yEJ84SbloBAihVX7MrTMS57',6,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (923,'BArFottk0nXLw2mwH6cRZ2dD88ZY2I6NxVFhUO02v','HVsrk1CQI2uLdwLIQnvXXSMcs7cY7iNX1i2oxUAzoR4BOs5PVRL8RBNIncHcNMdK2cHAdoQ8xxeqy6pOGH542j2',5,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (924,'3tcyIxsWNzZKI3iiGNTUsM8vdOFNYnpCYGsJxZnYf2seZitCOuj1c','RXQBWTzfId5Bj4lL',5,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (925,'uuyCwW6YuFoYlfiZe72BOTb7Vj24YAFqeBZavYU3o20LJkVdImwRDsU3v2C5vsaZkiSitfQnMbqL623B7asyXZTPN','CmUpMvqdk7KLkvwWlbRzN7oHA5PT2knB8wsZC1axrPbtiRVuDDLj5NHOi3fJ',5,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (926,'FQOSryS54kNaWDDqongMIlyOnvQQWsnLdxwCKU6PP8xMgwkWuFDR3yFOKdPZeg','TcQ5GLUH7WuZB3y2xrzSugSRPrMUY2eD56ENutsr6SYYFzO1hLm64KiPVpsVOMsEHyphjSzfY3HHMCbqmw4YDQPKYQ',4,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (927,'IP8qhMCdOiCNYNVyMb','uMfgTZRa7hetGgRNdIzSFlUqSToCWnQTjgya4icbSm2PTGwKvBToKGtDpSb5O13wrud',6,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (928,'M2iXQzEc1bNhotPasux1zIk1rdUZLZbjW82w1jP6ozWUXmKuvCHI285Z7GP','p5ocs1LSr2dHqRRvIvY4qsa1E5mhMOxuOpNPgapu8dCGPbV2QEsAtyM5X2IRcj4HzaCY1dgOAHwvFHfkXgKNG3hbmCWVMl',7,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (929,'UqUJJf5DAlGBhpNfrVEQ4qE4kWr7cUGtCxuC8gXORcqNqFeaDPy2Gmh5lD32c','i7cSODeUwF7ipZYuD44Bdo5',7,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (930,'woAoQ0ftqwHvnRF','irtJMSYSLmp4T7vL860rHtU6vt4zPfJCyDnNpVMYl2',6,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (931,'IItOONYGEof26agYgG4MvIkXDPahps1wrNypFOnvn20i4re8ezZG','7mMn2KG6j2QAv67pVLDUDd5IerWfD1yzYJiOK6NpGKqsS1jsn1H336wpeMwfiMu8wfRkmJ4Owb',2,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (932,'GsUbQWPD2myX8vZLXeIAYbFDMvMfxPxAk44GeCzWzdl6wneAzpJbGshvIA2z3LHPxxmjKJTF3oIfJreLZIilG8ExQEF','WFFkjPkIIH00aI8ktJBlmuZ1WvOLJBJbDUUf4BAGM4FjTkug3MQDpHgWiAkjm2N8ZCJ4OiaF7kGHpPPEIgw',8,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (933,'kPRp4L7TyBUSlTvdQlabKrMGw5sRyugxHeCw1a4lnKtjltWtRwgZqeVTrIPQ7kLV3UmeClFTKFGhoIYAxhvaZBEHZlqKTtd','rZTu68zR1WfRo2',6,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (934,'HWGzncC7tNphTLLaPvwZcH0lAPQaiUbYJPXivK2JvrhZtQojGg4JbYLCS7qGopT2b1WWz457QW3SpDtxgn6Fd','P2q1FZp4jRd3bamdBCX0utDf4AsVKwM4D8Yd85GKtKeY',7,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (935,'YbCNDWiSSo1Fp1YWoNVHY4074MfXTcC3yY1Kuj4LG5pmI6FTEIRVRRHSvyOwJXbBJhQF8urea3k0EP1','rKoBwALuUTl5gbMXIuLYOChTMV780ZqjmgkKrzzmprpnQkxr54q54a3O3jQy',4,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (936,'b3RwUSkU7pgqk8Txwxagf1jHx1bYM','6yPL5',5,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (937,'BMvp3q5c2AWMearPO4wkdcplmyk','FSPd1v21yD0H',2,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (938,'7Co3M6yEZQjVvpfpfVaPKsxb3BpIwmrjAAvhN7jXLwgKX1x','sHubUk71ZdF8CzDd5CMeo2bgCtvlfoONARGeN7LC5PA6rez2AePaD34uUGlVuJ8he5rnx1iG4BPn0ReHFJWqQAq0D',5,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (939,'tDmbNy7ccyVSa7nNSHShv7BvpZeg6RBv65NDtcUg00Oti3zNWNkHR3CQMOcYBI7shuGFbJahbJaXeqFn','KKjtpqf7Vda1dH2qCqfW40TvwCNFkA6kTUYl3vnMieMuDBh7uY8ni0ZnxD0FDf',3,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (940,'LVGrz3znTQVesSCmT0DCczirVHSbDk2KaSuP4Mu2PZW5Xu6UsNrUbp1Q8cACcmna7khVBIgs0Ny1akcgbMkbEiigadK5zJU','oCv0frTeTR6wZZsYk0W56HbwWZ1g',8,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (941,'AI7keJJzyQyn7Zs3wh6uCmgmbQLNJuoqoE03V4D3Avl1EjDIO3TiU','fiMHJZ1HSbWMt0FWuNv3i',2,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (942,'oqOWy54oM8MClL1oT5Gbp8opH3DEkx4PJHzml8H6gOXuWjxFHryRoi8tsLL3hHVRB8D4l6xbpiqLxIpvrjz8','bSF6WSTGSsuoGepKT41Vs3FBvkUVKBFcFxBmHgOw6u2NLW1mhYlx8SwTyllRZcMCNYM8MQA',4,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (943,'E1l33OiiGIxJswtI3MDEqr0peZYdwlmgueIcSJgvxuyGmRmmMSfXVj7','sm',6,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (944,'OFE4PcdG0qikdX2u3sSotrj7G0ErpshVXfEADZHATWL1Y','PjnDHolllBKbFzhVkBD1UXJmMMROu8CaDyWcoES470YTWIIo8',7,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (945,'k0xUNVMOPVw7P48piBfLUpMpAdTFVLJEViFjRrJ13D2LKCAX0EFFBheIAZC','lxQ7FfSgjWvkRLkfI8PqprCOowYV68O4Yxm1qCFbaLwWrNl8iGC1x0v8YkFOzirugDm0CfkxH',7,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (946,'wLXR7mln5jaQnG8ADtvkpAPDMgbVMnyKJ8TLorpshTw4zLAqziqT7THwJzAry1aFAoz3YLk','IdsTP0Q7vlYLptJaKTJTe3jvB0A',4,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (947,'8nH7fj65gfmAN5DawG3uGztz6HR0SUrYWfvWDu0rCKNoHI2Px','C7Da3ZV7',8,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (948,'GeYhBxNxhp06Shav8zAmYo','nVbYK8IAapXMPXtnBLt7QQgfBnVu0GpNbqIwkXuRiRgNteNW5Xt44FSZvwx2T1hCtL8Eba2aMqrDRGQSLL3XIdyJDpfZd7m6we3',4,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (949,'QLdxXWqX2ZVXJPwhQJgJ4','wx28sDCO0s1JgqSozsmhAzndJ7',9,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (950,'BapKixoM5skC0ndZDWKZxTqxskKSaujt1dqmRUxHXUQukfxIve0ZP','pgA',9,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (951,'YRuCzAPzTx4IxQWDkUk7t71mVBpBzmIB2svsM87V7n83Z7nNH6hXsgEmySP4bl2MtSpE8tFNycR','HqjTfSLRp8LyYEVTmSh8KPzcxo7KssnSU7j3jFp0AK8P0RiPDLOdcqEytbV74P5OBLYo8kLsJCycpvijkWHa',9,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (952,'32nWkNRwyYu8m6cfhTjuBTYFX8QcBXRXaFYgA2Dvw6ytcs','jDekVP3jNR3O6CGwCCTcHRca6xuELEHHoZQkGRhU68aB8td10ddOb3mi',8,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (953,'ujfJpiF2f4VDp0o0d','eiNEmhjs7JQnYiteBka0YsgSYpACOzuy5Ow',6,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (954,'5YjowVpk6U0ISCJLP60WYAVqANKzKvJvosTLKXup8DYpG','Qqdc',9,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (955,'B6qCZuH04HeVpFSbK25YrbVMBFsIMdX8MZk8OkTcOchZjv3tJQmH8oWOKWIrGYsAc8gBBho38AZoy','2ULT3BYNAYTUDwKudjLwRLX5yOq2ZF8p26QOHK',4,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (956,'7gidVf7uz7EbWBRa272FFfv1b2MxLxsJvfee2oJAmJRYAB7TvMtu1yNdiEvZcPT7bcJPpoHDl1StAQNfDVIHHz','jyuqdQAwIdVVI8UlWo1VtAF11lv3DxEyVXzctKmSam7lh7SwKi3BKm7I4Rvr1juz0TWM0SUXTyPIJ4LvTv4hz',4,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (957,'JMf7iNc7FULdh8EwZOsYVg6d3AYbxOjv4a7uZgywYWy4Txcsxpa5NRRJBQ1TAmeiF4su','5TkxV040DPllNM3bM',6,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (958,'wO04L8iWHPGml4ZkAW6OYxN6yKTgQj5t6uwHIRkjJNJE','qxgD2BrkJrjZYZ38rzWmDma2NPl2xN1j3wuSIeXmd0GvHRORIwLshYywGs',3,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (959,'xwm4PaIonNSpDCqKeRhJSc8G6GkT1SPtKnCPPhsou4g','NVbmS3WyMUz6104fxyJpfw8cZ7xIbmkoZXjkuz4hDhWI16gV1k1S0S6',7,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (960,'7A4iC1qD6ySmLolARLTp2hNYzxJZCLBdWccBEL3Vr6RNVtq3kbkkb','bmtpDUEQiHTY68QB6TyNEin',3,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (961,'iU1vPKZHPDHzrWsrgv8oGJ0AA2YgOL73EKBuuGt0FKFSvvNU4WXsNZmq57jFtxWwdHAyApvkoJtxP7PChR2Q1NtXjKNZ6VTF','Omq2a7SDlKpE8cipqD3nKidC5VjExKOc1rXBVFm',9,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (962,'xJ4z06N08jgGQc1ZnVPqHm7QhsYgFovk545ABUqXhWYn','m4xrPQHfxgceIyAi1STDo8DZzzfNgmFNR64hFOZyyA8ydz4TdTUdcYUHpPucCVOzJiixIyVHTbrkIEDp6USepN11ldTTd4k',2,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (963,'r1FGFROehrgZkS6JdK0jjD4VQ38lysr8bT2r8cMfCUG','TovXLU',9,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (964,'z0cWYp2X6U2DAWZ8tJRlofyYiFWgHRjsmNu4xrVxg3lHf6B3fsjAuxrKGkgh3EOa3sYgUkGqBPdYRwZMkEvOXvPR3o2nKLq6IT','l57WAyItExmVKgvWciu6sjku86m2MynE7drlDrQzkefVFyMIw3pF8LcECVypllSArHcTlpnsgu0f7',9,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (965,'F7fHLOm6OOxw76UkUQQIcdM6lygfFF3rSNQCjKzs78D12krvGLG7odxSHqP','Efsc0BoU0sQO',8,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (966,'1Ol7ZU14IkSCU8HDb1Oxs0c0T31HSeDPCNNLg43Qt6YTWVA1T5q2aKfbKWJYRF5fQdOsxBKfCkXhgEqf3B3Vp7eQO2VPjpPOH0','0q5QKd368enjdX7eCgegtS38X5v7YQtngw3ktmrSiscxOa7OIzpbw4B8WXWpdPszL0uJiqIiRczNklReXqndL',3,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (967,'hNB3wDiLVXamyXCbnKwYzaQeLFIxhuSuslkoH4JO04mdhDZ','YfVAnMe3FDmJq5uyDqYDTSzU1YfWGLuzi1HiLbD3J24vTRuS1vokWnHMmgI',9,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (968,'d5e1MOLkTOMbAn0ZzYanfR8BJCSTOjAJn2msLy4UyLGav0MylbUaXSdahyel0lxYWgqt7PejeQn0lOLty','M8WB5DSdJcWjg2nEaF4kkVKG3aBLnYKI3w8iamBCFoC0JcKzIFsT4Xcs234yz',6,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (969,'uzP5o0aKcelXzzMsWURkjsY1tQMOUHW3GPfnNKIPCtc8rAxbt6PCCQ7sXBXLdkTqViiL1j0VcTgIVnz','aFy4idAwjguwIhmpgEcfumVGpIXaAqDQt8cjIAgb7PGfNM5ZvcwgJ7BbQgddQpbPKPZEKFEumQKKgXwU',7,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (970,'dHi4YhcUse23HfSjScDMly','nBs3UvVp',6,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (971,'o36OSAxVvs4vEGH1ymIuBTXyadM1hlWvGkEDUzu8hu1b6JTypXESepIcoSEPOqNP7nO5315A','5TuJ1K4dmk6XTtJEsnWb0',6,4);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (972,'Xx5JNrsMn5LNtCsDte','axWIpDGInmDrKhfQufeWA',3,2);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (973,'n04BDfgGXstclQ7OHx4s5ELzrRDFTNfgvieWTQfbhJekB8DFa','B5QYBmJDFe5Bp0Fjqg0taFpuMyJOAczezRek',4,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (974,'CToBcE2Ct6SuDSgCiOXnwVWR2QCd4puoDvLxdDF3bAm6ZcVl4u8CuQ0PMIvjZm1juDY4hhQH2fISg0RSIVU7aaN8gXf41','WPR5OuyHX0xerIb6T0JxVzPhUueyEasuEDlOuWcSr8zEGCymQWcecyBxoi8Z4UrT8fTnOYBpHnl7CVV1cyB4wDvRC7',4,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (975,'zqP3kVqpYgUFUMXLXACl1iYvPTzpyyfPkAwgGmltweV','2XFPpzBEeycX1HQw5Svkx74y5lMBCltIy4QolqIRSPkQHxyaB83mGDUpsiVJTiSg1U7pMdOXWhfv0bFJ8osuBJzeT',3,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (976,'JcePHSFLyJJErexs0pdvBeZH25QoiOk5b6Ipco1jT4ZHmP0d3cVnLJqWGhqcAUOjHX4tmXQt3Rzp','Fjk2Hiom0N',4,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (977,'hpNfNCmDsutnC1tk5DGfzzacLbsSnUoFJjWC2jMFI7PLQ3FIaXbYurK13','dB85HMVM2jWtAwEbp',2,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (978,'B8jzTSYUgE3gIZmCIbFFX','vRs56ZozxpW8Yptyb8O3OiQILyOzpuQz22EYIS3VX5aKDQfU1q1gQeJEGntbFWF',8,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (979,'ixc5oHo','HYYoPKtt1qRg',6,3);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (980,'K0a3KupJ1p8Hc','xMOuSol7JukOeOmfJmLKPnBPYzmasklpywDOL4xjrXSM0aeakts67tXcEoIdCiCQzhYuHxQULz52aFRgDn',4,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (981,'0gBcao7XDcxR3Q6pnf6c','ie12IkYh',9,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (982,'WURhBB8nElmXJFZQKsFVJTFLhcZTYT07opnj3xVLGwr7XozzUKs4wSmmh27KMRAPW6H0KkFUxgYa','QydsRuoZSsX2GT12UEaFiXt00V3Y2rGbGiazAncC7Fuxx50ICGCgdKdel158MuWoIzH0YLF',2,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (983,'Tvwkaqc0rtjH654JlJgg1cTL8wbbIqb8ttGQGUTbo3CsksciC4on87bLogjesq8qTOMznheLNjgA','U8aRNHybNOUeA8v78888BCFxGXLK7k6oUeXkUMyT6UEG0Lj2NqeIALM2BcJFffPoNyLB7Z3j5Gzh',3,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (984,'Wuh3IsqwcvbVY44Oau0m5HCa8fllNxUf0JGPyK7dTk8TJqHsxY4hewSpMvyDJNZHoSfMYehmeEpW4DKVdwSgJxrZNaNfNPkQR','1Z2etpc',7,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (985,'gLMSrszn41Oy','SwrUiFYuaLcWnTue0Ofl6RYoACJfEb5BVfgtbv8TuhZ',7,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (986,'lYRE1q23JMLGJGcMsWNoaGAthj4OkbuOuaaPVenkJHgZ1otX','6fc4QuURto0EiuzmSwW6cZo2HPyNuryFrcPTjterXRvnpdyTqudhjq2VhpUacJHZXMBq',6,5);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (987,'UJv8LMVuiPgJ3GSRS7kkNME5dGL7NP3ATWa6TjXxL1ZLIUNgP1M8zo2OuS0shu7silIEo','eXLtbctfVhn8P2zwegyttmyuaD6btCMCr8eoBhLjfEK7S5Igko4jlVCz1agc4rhZSlCwXTJeF71qD8tLxy',4,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (988,'Zdkh6bNxEPVIkZeUpSEw6Z3CTKaIfZqcc7WnZpyIqvejtlOda0M8Kbk4NHpDgIXZ5Ffx81SU3YuG1JkX','mMbDGd6Im7edtiFC7z2XkMqADtTS7jNrHl1MCHkP4Sd2FmouRfrBP0I8FvhmsDb2B3jhRjdxYnuzIrHyR',9,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (989,'gHWKLqGnP2fKsRQwa4SLqQFiIi1wXVnngCClfYMJmu2iESGsyYLbn','kJEJO4Ow87AohyhoZaRgZE314jb5nP3dNSWeaVOs8UH3AtO1k',2,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (990,'7UF2r4yMHaatkgdL7m6H3Wp7EanSua48Fpn61sKKkpSqrDPpSDptmb','qCTqi03NVgmBgOgQyjpn0cU6bORXN3SXCXhDzxukIhBFTRKVIBBwwP2PgTpMvZVJBRWMqKUE08FNhRBhtzr',7,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (991,'MAHVVpjufR0iaq2jYtQJ6zyoWst5PgatCDF2QI6yUwON5ERhDeGLVSY','sNJUkIYYg1haAbsGjimYf0Ig3x17mDFwL2SuZ6CO7Bs0JDhpTiPZjjVFLAULZ2EwUFYy',8,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (992,'QHh0GMzvSKMkzMxBskjwgYM5vKZu6O811DnC5sTOf2AoGVDepF0OMpOTh8z7XKmhxSK5UcKWd84WPQOPlNf','ryk1QZ0ZbMJmOvmv1GMpZHUFconFeLnZMoOLEUFGmDINiY1Cq7Flh7ZkzvVnUiOcLLBuplPomNr0',4,7);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (993,'QLL7QpOaVDB5KStuLNnPOgdM8gKMdTl8s8FFf3AloO1czAbgbeUir5ZALCmyF','HXVcBxNdu0J0BFVciHZTzsflqEhmQMj3LWc8YmCxwh1k0Bn4wtn4VH3URJdfmkn6Tln',9,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (994,'50urGAZpg8CmSB5jajXgxWPfbshrXkB28MsD6rxVwrBnEsVLupkw66MAOs75pmdvXXUroSQ1Nb5R5PE','UYpgbVigL7CovhgC2ycXzrVJelAjrOJX8bQO8amI6sZxEIA3z6rsSIsx1j74EADRcWbZfJLZyPDGu5Q0lyjNzGkSn11',3,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (995,'UCeRTAn5V0u1CUql8E2NaJxZoE03qmuIFBubPZH5mBBG3Opl1LbLKa5pjCuzzi6oNkg8LzzOuk1MLOL2mvhd6ddto0','tgzPDlvHvZuTOpRF8WY4eZ5VKEcf8DyOMTO3WSPzBm4VHOmSbM60pkb60CfIbQ',2,1);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (996,'3LTOLJVUJaAp6n8iwUuJ5cYWOyG7TyDUeX','d75w5Q6',4,8);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (997,'RrmNs4asHyiuamUJYxaIq0N1vRs4cBvOh6mUaa7cDjXzgZmCuUpAYyt558oszzt2bP1lj2AvBSW','iGDsDWvhlC0fevRkcNe4GjgJs0Ab0ZswtHY553CCTeGWaEUi35k7PMYaqeNsFztMgefsFf6zZhk7wdJqv',5,6);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (998,'FlrxLYfd8kTXCKsrge3tt0NYTQFinFoV','XSsQfONQyGLHNbpcLR8nBDXkjuEV1PA1G4r7C55xCxpjscDQzMEQ5',8,9);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (999,'6DXwOle2nmJgnV5r2hX31GJ2Dv37oMN3xqGywSNreFNOvDzcDxTuAfGaGY2apedba7','TptumYl7w6NF6xIU8w8dAIpNSIlHfmzIGnLIjFAQ15eIKAN8iu',7,10);
INSERT INTO "online_challenge_activity"."gioco" ("id","nome","plancia","maxsq","maxdadi") VALUES (1000,'bOnxIjTMFhKKgZcAwiAt87nN8oJlfREtSS1IBmf5mfQOBo1ZmP1p','zBaAbDASDNqStPfa4vq2ab5hyTZ6eP6ncSYikIEugoxEZgnCe',9,8);



INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (20,'05:55:00','MO','18.01.2020','00:58:00',61.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (21,'00:08:00','NM','30.09.2002','04:30:00',61.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (22,'06:01:00','NM','05.09.2009','01:14:00',69.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (23,'04:19:00','NM','24.06.2008','05:15:00',69.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (24,'07:43:00','MO','30.09.2018','03:20:00',69.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (25,'02:50:00','MO','31.08.2009','06:26:00',74.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (26,'01:12:00','NM','03.05.2007','05:22:00',75.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (27,'06:16:00','NM','20.04.2016','02:44:00',75.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (28,'03:06:00','NM','28.02.2008','03:03:00',80.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (29,'02:54:00','NM','22.12.2016','09:58:00',83.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (30,'10:38:00','MO','27.01.2004','02:02:00',85.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (31,'02:56:00','MO','22.09.2005','04:49:00',85.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (32,'00:26:00','MO','05.02.2002','03:58:00',85.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (33,'01:45:00','MO','07.03.2003','04:58:00',93.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (34,'08:20:00','NM','27.09.2011','10:49:00',93.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (35,'05:58:00','NM','10.01.2014','07:30:00',93.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (36,'02:46:00','MO','13.10.2011','05:30:00',103.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (37,'04:15:00','MO','20.11.2008','04:38:00',103.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (38,'08:50:00','MO','12.10.2011','09:18:00',103.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (39,'02:27:00','NM','11.09.2009','00:32:00',111.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (40,'09:19:00','NM','16.08.2003','07:57:00',111.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (41,'01:09:00','NM','15.10.2015','09:00:00',117.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (42,'06:44:00','MO','18.05.2010','02:13:00',117.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (43,'06:41:00','MO','22.03.2020','03:23:00',117.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (44,'03:46:00','NM','27.06.2017','09:47:00',118.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (45,'06:02:00','MO','19.12.2020','03:46:00',122.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (46,'02:47:00','MO','05.03.2000','01:02:00',122.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (47,'01:48:00','MO','19.01.2004','00:34:00',132.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (48,'06:57:00','MO','07.12.2017','03:05:00',132.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (49,'06:18:00','MO','27.02.2010','09:18:00',133.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (50,'04:08:00','NM','08.04.2002','10:12:00',138.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (51,'02:14:00','MO','14.12.2015','05:47:00',143.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (52,'08:48:00','MO','30.03.2016','01:04:00',143.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (53,'05:14:00','MO','12.05.2011','09:06:00',147.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (54,'00:30:00','NM','03.05.2005','05:54:00',147.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (55,'09:16:00','NM','05.10.2005','07:32:00',147.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (56,'06:03:00','MO','12.07.2016','07:15:00',152.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (57,'10:31:00','NM','03.07.2012','02:11:00',152.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (58,'06:06:00','MO','01.05.2009','00:34:00',158.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (59,'06:19:00','MO','15.12.2008','08:24:00',165.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (60,'07:12:00','MO','22.12.2013','01:13:00',166.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (61,'01:51:00','NM','05.11.2009','02:35:00',166.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (62,'02:06:00','NM','28.02.2015','00:37:00',166.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (63,'09:09:00','NM','05.02.2009','09:17:00',170.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (64,'00:16:00','NM','25.03.2016','02:13:00',170.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (65,'03:20:00','MO','27.12.2007','07:32:00',178.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (66,'09:16:00','NM','14.03.2011','06:26:00',188.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (67,'08:22:00','MO','18.07.2019','05:25:00',194.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (68,'03:04:00','NM','13.02.2016','08:09:00',194.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (69,'06:06:00','NM','04.03.2019','09:47:00',194.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (70,'07:53:00','MO','22.09.2014','03:36:00',198.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (71,'07:47:00','MO','13.09.2011','00:46:00',199.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (72,'08:40:00','MO','01.03.2013','08:22:00',199.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (73,'02:19:00','MO','08.10.2019','04:39:00',199.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (74,'09:21:00','NM','05.07.2001','01:01:00',206.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (75,'00:47:00','NM','09.03.2002','06:00:00',206.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (76,'06:24:00','NM','17.04.2021','06:40:00',210.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (77,'09:01:00','NM','31.01.2019','04:36:00',210.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (78,'06:01:00','NM','20.06.2012','04:11:00',210.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (79,'01:24:00','MO','15.10.2010','04:30:00',219.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (80,'00:28:00','MO','29.12.2018','02:36:00',226.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (81,'05:03:00','NM','14.11.2017','02:52:00',231.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (82,'03:36:00','NM','31.07.2006','07:40:00',231.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (83,'00:25:00','MO','22.12.2010','07:07:00',231.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (84,'03:58:00','NM','02.08.2020','09:23:00',236.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (85,'08:20:00','MO','17.06.2007','03:36:00',237.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (86,'03:50:00','MO','03.09.2005','03:52:00',237.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (87,'08:03:00','NM','02.10.2012','10:23:00',246.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (88,'05:33:00','NM','01.05.2006','06:50:00',246.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (89,'07:02:00','MO','13.08.2015','05:06:00',250.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (90,'06:42:00','MO','31.01.2013','09:32:00',250.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (91,'10:39:00','MO','09.07.2012','02:39:00',259.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (92,'01:44:00','MO','20.05.2001','09:19:00',267.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (93,'06:33:00','MO','11.06.2004','08:54:00',269.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (94,'10:35:00','NM','11.11.2011','00:23:00',269.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (95,'01:33:00','MO','16.05.2007','00:54:00',269.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (96,'06:46:00','MO','28.11.2012','04:31:00',273.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (97,'03:13:00','NM','19.07.2008','10:45:00',273.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (98,'09:37:00','MO','18.04.2008','08:12:00',275.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (99,'07:41:00','NM','11.01.2016','07:56:00',284.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (100,'04:28:00','NM','02.12.2020','02:36:00',284.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (101,'05:18:00','NM','20.12.2018','07:51:00',286.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (102,'00:06:00','MO','25.09.2010','07:12:00',295.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (103,'10:17:00','MO','11.11.2012','05:38:00',295.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (104,'03:31:00','MO','24.10.2001','05:20:00',295.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (105,'00:39:00','NM','07.10.2012','01:47:00',301.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (106,'00:57:00','NM','21.08.2007','07:13:00',301.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (107,'05:27:00','NM','13.02.2004','00:11:00',308.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (108,'00:25:00','MO','18.01.2017','09:36:00',311.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (109,'04:57:00','MO','21.02.2017','05:08:00',311.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (110,'01:42:00','MO','20.02.2014','10:17:00',311.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (111,'06:38:00','NM','29.08.2016','05:50:00',319.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (112,'08:53:00','NM','29.03.2013','03:36:00',319.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (113,'02:46:00','NM','27.02.2002','07:55:00',324.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (114,'00:03:00','NM','14.01.2018','06:05:00',330.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (115,'02:12:00','MO','18.07.2002','06:29:00',330.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (116,'00:51:00','MO','02.09.2017','01:39:00',332.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (117,'00:20:00','NM','13.05.2018','08:14:00',332.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (118,'02:25:00','MO','27.04.2021','08:18:00',333.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (119,'08:43:00','NM','15.05.2008','08:31:00',337.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (120,'10:39:00','NM','31.10.2014','00:38:00',337.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (121,'02:27:00','NM','23.06.2014','04:24:00',341.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (122,'07:49:00','MO','18.06.2014','00:49:00',341.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (123,'06:49:00','MO','27.12.2007','05:58:00',350.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (124,'04:37:00','MO','08.02.2000','08:47:00',350.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (125,'05:03:00','MO','16.09.2010','06:32:00',359.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (126,'08:08:00','MO','18.10.2005','04:23:00',363.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (127,'03:10:00','NM','31.07.2003','01:17:00',363.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (128,'09:00:00','MO','16.11.2004','01:05:00',367.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (129,'10:01:00','NM','27.03.2004','08:38:00',367.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (130,'09:13:00','NM','11.01.2011','07:57:00',367.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (131,'09:12:00','NM','14.04.2011','00:13:00',374.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (132,'10:29:00','MO','22.05.2008','09:36:00',374.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (133,'05:24:00','NM','18.08.2003','01:28:00',374.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (134,'03:44:00','MO','04.02.2000','05:26:00',377.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (135,'08:20:00','MO','10.06.2016','02:08:00',377.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (136,'03:35:00','MO','10.02.2001','00:32:00',387.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (137,'03:37:00','MO','09.05.2000','05:10:00',387.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (138,'05:12:00','MO','26.05.2012','09:22:00',387.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (139,'06:35:00','NM','14.03.2000','04:44:00',390.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (140,'04:09:00','MO','24.12.2001','09:47:00',390.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (141,'07:25:00','NM','20.03.2019','02:03:00',390.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (142,'10:26:00','MO','28.03.2015','06:11:00',391.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (143,'10:03:00','MO','30.12.2011','01:47:00',391.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (144,'10:03:00','NM','28.07.2012','08:08:00',397.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (145,'07:11:00','MO','05.01.2018','04:16:00',397.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (146,'10:40:00','MO','01.12.2012','05:25:00',397.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (147,'05:32:00','MO','09.07.2014','03:52:00',404.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (148,'08:09:00','MO','04.11.2015','10:55:00',411.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (149,'08:32:00','MO','25.08.2001','10:00:00',411.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (150,'03:28:00','MO','06.02.2021','01:24:00',413.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (151,'07:53:00','MO','01.10.2017','03:33:00',414.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (152,'02:57:00','NM','22.02.2015','09:34:00',414.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (153,'04:38:00','MO','22.06.2006','09:35:00',414.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (154,'04:19:00','NM','25.01.2005','08:16:00',424.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (155,'07:40:00','MO','19.09.2013','01:22:00',431.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (156,'01:21:00','MO','01.04.2009','03:04:00',431.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (157,'05:54:00','MO','30.05.2008','08:17:00',441.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (158,'06:25:00','NM','12.10.2017','01:39:00',444.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (159,'05:11:00','NM','19.11.2013','07:01:00',444.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (160,'03:57:00','NM','27.11.2012','06:15:00',449.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (161,'01:45:00','MO','19.02.2015','07:57:00',449.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (162,'02:50:00','MO','17.02.2016','10:56:00',453.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (163,'05:12:00','MO','08.02.2008','01:53:00',459.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (164,'06:30:00','NM','13.10.2014','07:38:00',461.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (165,'08:21:00','NM','12.05.2002','06:31:00',463.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (166,'05:58:00','NM','12.01.2017','08:01:00',463.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (167,'06:02:00','MO','19.08.2018','03:02:00',467.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (168,'00:10:00','NM','02.11.2010','08:25:00',467.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (169,'04:42:00','NM','26.03.2017','03:50:00',473.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (170,'10:02:00','MO','06.07.2012','06:58:00',475.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (171,'05:44:00','NM','14.03.2010','05:50:00',475.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (172,'00:55:00','NM','06.06.2010','05:22:00',485.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (173,'00:44:00','MO','16.09.2019','04:24:00',485.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (174,'07:54:00','MO','04.02.2011','01:37:00',489.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (175,'03:58:00','NM','27.06.2010','03:10:00',497.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (176,'06:20:00','NM','30.05.2017','07:54:00',497.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (177,'03:24:00','MO','24.02.2011','00:10:00',497.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (178,'04:52:00','NM','23.02.2007','08:52:00',507.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (179,'01:27:00','MO','13.02.2014','06:56:00',515.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (180,'04:56:00','NM','23.03.2007','04:11:00',523.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (181,'09:36:00','MO','13.11.2007','00:41:00',524.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (182,'10:04:00','MO','24.12.2015','07:22:00',524.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (183,'08:25:00','MO','29.11.2017','02:43:00',534.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (184,'07:11:00','MO','20.09.2008','10:26:00',534.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (185,'01:16:00','NM','10.04.2003','01:36:00',534.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (186,'01:01:00','MO','14.02.2014','02:05:00',537.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (187,'06:08:00','MO','20.06.2002','03:43:00',537.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (188,'06:05:00','MO','30.09.2018','02:57:00',547.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (189,'01:18:00','NM','03.10.2020','09:46:00',547.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (190,'08:06:00','NM','08.05.2004','02:17:00',547.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (191,'06:07:00','NM','22.02.2016','01:44:00',551.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (192,'00:08:00','NM','23.12.2003','00:16:00',551.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (193,'02:30:00','MO','11.03.2008','07:07:00',551.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (194,'07:19:00','NM','11.01.2018','04:09:00',553.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (195,'04:12:00','MO','30.01.2003','06:27:00',561.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (196,'08:52:00','NM','27.11.2011','05:20:00',561.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (197,'00:09:00','MO','14.09.2004','10:18:00',561.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (198,'02:29:00','NM','09.05.2012','02:36:00',562.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (199,'08:06:00','MO','16.10.2009','03:27:00',571.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (200,'05:02:00','NM','23.03.2010','05:22:00',572.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (201,'08:48:00','NM','18.07.2002','10:05:00',572.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (202,'00:40:00','NM','15.12.2000','00:13:00',581.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (203,'00:08:00','NM','22.09.2001','04:37:00',590.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (204,'05:55:00','NM','07.03.2009','07:31:00',590.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (205,'08:55:00','NM','13.06.2007','09:40:00',597.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (206,'00:30:00','MO','01.03.2003','00:32:00',605.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (207,'06:54:00','NM','08.11.2019','06:47:00',605.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (208,'08:39:00','NM','17.07.2021','05:31:00',605.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (209,'04:11:00','MO','04.12.2013','01:52:00',611.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (210,'01:39:00','MO','09.07.2018','05:35:00',616.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (211,'02:57:00','MO','22.07.2008','10:04:00',616.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (212,'00:40:00','NM','31.01.2012','06:11:00',618.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (213,'07:46:00','MO','08.01.2013','04:43:00',621.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (214,'07:04:00','NM','27.09.2012','06:57:00',621.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (215,'05:19:00','NM','14.10.2002','02:38:00',630.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (216,'08:11:00','MO','21.04.2017','10:31:00',630.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (217,'04:21:00','MO','20.07.2014','06:16:00',631.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (218,'00:53:00','MO','03.01.2019','08:05:00',631.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (219,'02:44:00','NM','24.04.2010','10:33:00',631.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (220,'02:12:00','NM','27.07.2007','04:15:00',633.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (221,'08:11:00','MO','08.12.2019','04:19:00',633.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (222,'02:22:00','MO','26.11.2001','00:30:00',633.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (223,'01:03:00','MO','18.12.2001','09:53:00',640.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (224,'02:32:00','NM','12.01.2011','01:33:00',644.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (225,'00:04:00','NM','18.08.2009','03:30:00',652.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (226,'08:37:00','NM','25.09.2020','05:49:00',652.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (227,'03:52:00','NM','06.03.2010','05:41:00',652.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (228,'07:35:00','MO','26.02.2005','08:50:00',658.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (229,'06:13:00','NM','04.03.2010','05:55:00',658.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (230,'09:15:00','MO','03.06.2021','08:48:00',666.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (231,'02:42:00','MO','06.04.2014','01:08:00',676.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (232,'08:04:00','NM','26.02.2008','05:38:00',676.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (233,'01:03:00','NM','15.11.2000','07:06:00',676.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (234,'10:07:00','NM','16.03.2006','02:32:00',683.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (235,'00:35:00','MO','17.03.2014','00:57:00',683.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (236,'04:11:00','NM','03.10.2013','08:00:00',683.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (237,'08:55:00','NM','14.02.2015','08:11:00',688.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (238,'01:20:00','MO','05.09.2013','05:18:00',688.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (239,'04:01:00','MO','17.02.2002','07:12:00',688.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (240,'07:11:00','NM','02.10.2000','05:22:00',697.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (241,'10:40:00','NM','11.05.2010','03:27:00',697.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (242,'09:06:00','MO','07.09.2001','10:22:00',704.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (243,'09:03:00','MO','28.08.2011','01:34:00',714.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (244,'08:11:00','MO','01.07.2013','05:12:00',714.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (245,'01:35:00','MO','05.06.2014','02:48:00',714.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (246,'08:05:00','MO','23.03.2009','06:04:00',724.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (247,'10:47:00','MO','31.01.2002','06:23:00',727.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (248,'06:43:00','MO','15.02.2012','03:38:00',727.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (249,'02:22:00','NM','12.02.2013','02:21:00',727.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (250,'01:17:00','NM','25.06.2014','08:24:00',733.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (251,'10:17:00','NM','02.12.2012','10:12:00',733.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (252,'00:18:00','NM','18.12.2008','03:13:00',733.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (253,'03:10:00','NM','29.10.2000','10:45:00',735.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (254,'04:05:00','NM','16.12.2015','06:32:00',735.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (255,'00:13:00','MO','07.05.2007','09:12:00',743.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (256,'09:58:00','MO','09.12.2006','01:40:00',743.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (257,'03:38:00','NM','28.05.2003','07:10:00',743.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (258,'00:38:00','NM','25.04.2010','02:46:00',753.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (259,'08:14:00','NM','10.05.2008','02:50:00',753.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (260,'03:26:00','NM','10.09.2000','01:54:00',753.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (261,'06:51:00','MO','04.06.2010','02:01:00',757.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (262,'06:28:00','NM','09.11.2020','06:31:00',757.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (263,'10:48:00','NM','19.02.2000','07:09:00',757.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (264,'08:13:00','MO','26.07.2019','02:19:00',766.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (265,'06:38:00','NM','24.11.2013','08:06:00',770.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (266,'10:08:00','MO','11.01.2003','05:05:00',774.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (267,'09:58:00','MO','28.09.2016','09:31:00',774.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (268,'04:22:00','NM','01.11.2007','00:53:00',776.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (269,'03:33:00','MO','22.10.2019','02:44:00',776.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (270,'09:08:00','MO','25.02.2019','08:25:00',776.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (271,'04:53:00','MO','16.10.2012','09:53:00',780.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (272,'09:16:00','MO','28.05.2015','05:57:00',788.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (273,'06:15:00','NM','28.09.2002','01:03:00',788.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (274,'05:35:00','MO','13.09.2008','00:39:00',788.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (275,'06:52:00','NM','13.10.2000','06:33:00',793.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (276,'03:27:00','NM','10.02.2014','03:52:00',793.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (277,'03:37:00','MO','03.05.2019','08:28:00',793.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (278,'04:19:00','MO','12.11.2017','03:03:00',795.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (279,'06:55:00','NM','13.03.2018','08:36:00',795.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (280,'04:03:00','NM','20.02.2010','03:18:00',800.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (281,'05:03:00','MO','12.03.2000','05:48:00',809.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (282,'10:22:00','NM','05.03.2003','01:21:00',809.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (283,'01:14:00','NM','19.01.2015','07:40:00',813.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (284,'02:31:00','NM','17.11.2016','07:00:00',816.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (285,'07:07:00','NM','04.04.2011','06:15:00',822.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (286,'06:41:00','NM','21.08.2017','07:33:00',831.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (287,'00:28:00','NM','20.01.2006','09:29:00',837.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (288,'01:01:00','NM','07.11.2006','01:48:00',837.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (289,'09:36:00','NM','01.11.2011','10:15:00',844.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (290,'09:36:00','MO','21.03.2008','07:33:00',844.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (291,'08:02:00','MO','20.10.2008','05:43:00',850.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (292,'07:25:00','NM','19.05.2002','05:06:00',850.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (293,'06:43:00','MO','08.08.2014','06:03:00',859.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (294,'07:56:00','NM','15.09.2006','04:36:00',862.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (295,'04:35:00','MO','10.09.2013','01:06:00',862.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (296,'10:44:00','MO','27.11.2014','06:02:00',862.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (297,'03:27:00','MO','09.02.2009','00:30:00',871.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (298,'02:16:00','NM','26.08.2015','06:23:00',871.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (299,'06:20:00','MO','17.06.2010','00:52:00',871.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (300,'00:33:00','MO','23.12.2002','03:16:00',877.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (301,'02:04:00','MO','22.11.2014','09:49:00',877.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (302,'00:54:00','NM','04.10.2008','07:58:00',884.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (303,'02:33:00','NM','07.04.2013','10:01:00',885.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (304,'03:23:00','NM','17.10.2009','02:04:00',885.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (305,'06:35:00','NM','29.05.2008','03:40:00',885.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (306,'02:09:00','NM','25.07.2021','01:32:00',894.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (307,'01:29:00','NM','27.03.2021','10:42:00',903.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (308,'07:50:00','NM','11.11.2015','03:41:00',903.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (309,'06:48:00','NM','25.07.2001','08:02:00',903.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (310,'04:05:00','MO','22.06.2021','06:51:00',904.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (311,'00:29:00','NM','01.10.2009','01:01:00',905.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (312,'00:58:00','MO','23.09.2007','10:14:00',905.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (313,'09:38:00','NM','10.01.2000','08:32:00',905.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (314,'07:02:00','MO','14.05.2012','03:14:00',910.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (315,'05:39:00','MO','01.09.2014','08:54:00',912.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (316,'07:38:00','MO','13.11.2020','08:45:00',914.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (317,'05:29:00','NM','04.09.2001','08:12:00',914.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (318,'03:36:00','MO','13.12.2006','03:35:00',914.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (319,'01:07:00','NM','09.03.2015','04:48:00',921.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (320,'08:26:00','MO','28.08.2011','03:17:00',928.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (321,'03:50:00','MO','10.01.2005','05:00:00',937.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (322,'02:10:00','NM','25.08.2002','09:27:00',937.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (323,'07:28:00','NM','16.03.2005','09:13:00',944.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (324,'09:40:00','NM','08.01.2005','10:01:00',944.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (325,'10:25:00','NM','22.07.2001','02:04:00',949.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (326,'06:35:00','NM','20.02.2021','00:47:00',952.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (327,'00:43:00','MO','03.08.2015','05:47:00',952.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (328,'04:33:00','MO','28.06.2005','08:31:00',952.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (329,'05:54:00','MO','09.05.2005','01:25:00',959.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (330,'08:27:00','NM','28.11.2013','10:15:00',960.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (331,'06:48:00','MO','09.10.2006','03:30:00',960.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (332,'09:03:00','MO','25.09.2009','07:47:00',960.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (333,'01:50:00','NM','28.07.2005','08:28:00',965.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (334,'07:35:00','MO','27.03.2002','07:31:00',965.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (335,'00:49:00','NM','12.05.2009','06:09:00',965.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (336,'10:27:00','MO','31.01.2020','01:24:00',975.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (337,'03:57:00','NM','17.05.2014','10:45:00',979.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (338,'04:18:00','MO','28.10.2013','05:35:00',979.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (339,'04:04:00','MO','12.04.2020','04:47:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (340,'05:22:00','MO','10.02.2010','07:56:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (341,'10:41:00','MO','01.10.2007','10:57:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (342,'03:03:00','NM','24.11.2013','07:51:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (343,'08:43:00','NM','03.06.2010','00:44:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (344,'03:57:00','MO','30.03.2008','02:24:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (345,'01:33:00','MO','14.09.2005','03:50:00',983.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (346,'09:04:00','MO','25.02.2010','09:23:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (347,'03:12:00','MO','12.02.2001','08:48:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (348,'00:27:00','MO','11.10.2007','02:08:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (349,'08:08:00','MO','12.04.2001','00:42:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (350,'03:27:00','MO','08.01.2011','03:11:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (351,'02:18:00','NM','29.09.2001','10:00:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (352,'08:54:00','NM','30.01.2009','00:04:00',987.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (353,'00:01:00','MO','22.10.2007','02:43:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (354,'03:48:00','MO','20.06.2015','06:53:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (355,'05:31:00','NM','13.08.2021','10:50:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (356,'04:33:00','MO','02.10.2013','06:26:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (357,'07:57:00','NM','27.09.2018','08:38:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (358,'06:24:00','MO','19.05.2005','06:58:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (359,'07:49:00','NM','05.05.2015','10:49:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (360,'08:08:00','NM','14.08.2021','06:54:00',988.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (361,'01:53:00','MO','23.04.2021','08:25:00',988.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (362,'01:09:00','NM','14.11.2017','08:40:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (363,'05:31:00','NM','02.03.2021','01:16:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (364,'00:33:00','NM','10.09.2002','03:42:00',996.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (365,'04:45:00','MO','03.06.2007','01:40:00',996.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (366,'08:33:00','NM','15.03.2021','05:15:00',981.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (367,'09:40:00','NM','04.12.2010','10:15:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (368,'00:01:00','MO','14.05.2012','02:47:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (369,'04:25:00','NM','10.05.2021','08:29:00',993.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (370,'09:50:00','MO','07.01.2016','03:06:00',993.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (371,'08:47:00','NM','02.09.2007','07:51:00',977.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (372,'03:39:00','NM','23.01.2010','03:39:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (373,'08:44:00','NM','01.12.2015','09:12:00',988.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (374,'04:46:00','MO','27.12.2000','03:30:00',988.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (375,'02:34:00','NM','01.05.2014','04:32:00',988.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (376,'00:14:00','NM','23.04.2021','08:17:00',991.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (377,'08:15:00','MO','28.04.2004','01:13:00',991.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (378,'04:58:00','NM','05.05.2012','06:25:00',994.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (379,'04:44:00','NM','27.11.2006','03:45:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (380,'01:15:00','NM','23.05.2008','09:57:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (381,'01:11:00','MO','06.12.2005','02:14:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (382,'02:34:00','MO','01.09.2020','08:42:00',979.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (383,'06:44:00','NM','31.01.2010','08:10:00',979.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (384,'10:55:00','MO','31.03.2016','09:30:00',979.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (385,'02:17:00','NM','26.04.2010','06:18:00',983.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (386,'09:49:00','MO','30.07.2011','06:31:00',983.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (387,'02:46:00','MO','14.07.2017','02:03:00',983.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (388,'08:10:00','NM','07.10.2009','05:37:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (389,'07:46:00','MO','20.03.2014','06:02:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (390,'00:37:00','NM','12.06.2018','09:32:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (391,'06:53:00','MO','14.06.2007','10:09:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (392,'10:22:00','NM','14.09.2015','07:19:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (393,'04:44:00','MO','12.01.2021','05:05:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (394,'07:46:00','NM','25.04.2000','05:09:00',977.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (395,'06:07:00','NM','24.03.2016','06:37:00',977.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (396,'10:13:00','MO','02.04.2016','09:26:00',977.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (397,'02:48:00','MO','15.11.2012','03:25:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (398,'07:17:00','MO','12.08.2018','06:06:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (399,'00:55:00','NM','15.06.2019','07:45:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (400,'00:51:00','MO','01.11.2016','10:03:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (401,'08:16:00','NM','18.11.2003','06:16:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (402,'00:29:00','MO','24.04.2002','03:03:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (403,'01:12:00','NM','30.10.2019','06:31:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (404,'02:55:00','MO','10.03.2013','01:25:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (405,'09:27:00','NM','10.10.2015','07:25:00',996.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (406,'03:22:00','NM','06.01.2012','03:00:00',996.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (407,'08:26:00','NM','01.11.2017','09:31:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (408,'03:20:00','MO','07.08.2003','06:00:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (409,'08:12:00','MO','27.03.2008','00:47:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (410,'06:04:00','NM','14.05.2008','08:51:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (411,'01:45:00','MO','30.04.2009','06:49:00',994.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (412,'07:33:00','NM','21.10.2017','08:04:00',994.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (413,'07:23:00','MO','11.08.2005','00:41:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (414,'08:19:00','NM','20.08.2007','09:04:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (415,'05:35:00','NM','11.11.2004','10:24:00',977.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (416,'02:11:00','MO','23.02.2021','08:30:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (417,'08:09:00','NM','14.01.2015','06:55:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (418,'08:45:00','MO','08.01.2013','02:15:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (419,'07:23:00','NM','14.07.2017','07:36:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (420,'07:05:00','NM','22.06.2013','07:38:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (421,'03:15:00','MO','02.09.2003','01:36:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (422,'09:41:00','NM','13.10.2008','09:37:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (423,'02:54:00','NM','29.05.2014','03:05:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (424,'08:14:00','NM','06.03.2014','05:07:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (425,'05:10:00','NM','20.03.2001','02:26:00',996.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (426,'01:54:00','MO','20.07.2009','08:53:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (427,'07:23:00','NM','12.12.2020','03:06:00',981.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (428,'10:47:00','NM','19.07.2021','05:44:00',987.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (429,'01:46:00','NM','30.10.2014','04:23:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (430,'10:46:00','NM','12.04.2000','08:30:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (431,'08:26:00','MO','23.04.2005','10:44:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (432,'03:12:00','MO','03.04.2009','10:06:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (433,'09:56:00','NM','18.02.2003','00:25:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (434,'10:09:00','MO','08.11.2013','04:01:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (435,'06:25:00','NM','03.02.2018','07:42:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (436,'00:44:00','MO','05.05.2006','04:03:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (437,'02:06:00','NM','20.07.2015','04:21:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (438,'05:14:00','NM','03.04.2003','01:51:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (439,'09:34:00','NM','13.08.2006','07:45:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (440,'07:08:00','MO','11.08.2021','05:45:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (441,'05:50:00','NM','19.06.2009','03:28:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (442,'00:18:00','MO','11.09.2013','03:55:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (443,'07:21:00','MO','08.08.2021','09:51:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (444,'01:14:00','NM','02.06.2013','09:01:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (445,'01:09:00','MO','24.11.2008','08:28:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (446,'03:40:00','MO','01.02.2005','08:53:00',994.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (447,'07:11:00','MO','17.08.2021','10:35:00',994.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (448,'09:07:00','NM','27.05.2018','06:48:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (449,'03:38:00','NM','21.02.2017','07:10:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (450,'09:56:00','MO','27.02.2014','00:47:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (451,'03:32:00','NM','24.01.2003','05:57:00',977.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (452,'07:54:00','MO','17.02.2005','01:10:00',977.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (453,'09:25:00','MO','27.07.2010','06:28:00',977.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (454,'03:01:00','MO','03.10.2008','06:42:00',979.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (455,'03:55:00','NM','13.09.2004','07:26:00',985.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (456,'00:06:00','NM','28.08.2011','01:46:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (457,'10:29:00','NM','11.09.2004','06:28:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (458,'00:18:00','MO','02.05.2020','03:46:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (459,'05:19:00','MO','15.09.2020','10:05:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (460,'06:47:00','NM','11.06.2010','10:03:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (461,'02:44:00','NM','04.03.2003','06:34:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (462,'10:18:00','NM','07.09.2016','09:09:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (463,'01:01:00','MO','06.08.2003','07:02:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (464,'08:01:00','MO','07.07.2012','05:27:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (465,'00:00:00','MO','04.03.2000','06:07:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (466,'10:37:00','MO','09.07.2001','09:21:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (467,'09:40:00','MO','12.07.2005','09:41:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (468,'00:09:00','NM','05.05.2013','01:53:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (469,'07:05:00','MO','18.02.2011','01:28:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (470,'04:24:00','MO','14.11.2003','09:25:00',996.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (471,'05:08:00','NM','15.05.2014','08:23:00',996.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (472,'01:09:00','NM','26.05.2003','08:19:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (473,'05:52:00','NM','05.01.2008','09:57:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (474,'01:51:00','MO','22.12.2002','08:13:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (475,'03:09:00','NM','02.12.2014','03:36:00',982.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (476,'04:13:00','NM','02.07.2007','05:15:00',982.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (477,'02:36:00','MO','03.04.2009','03:20:00',988.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (478,'01:42:00','NM','11.09.2017','08:04:00',988.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (479,'04:02:00','NM','10.05.2007','10:29:00',988.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (480,'05:34:00','NM','01.06.2008','05:26:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (481,'09:16:00','MO','10.07.2019','08:37:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (482,'06:05:00','NM','06.09.2002','06:34:00',982.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (483,'01:31:00','MO','17.06.2008','05:00:00',982.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (484,'03:35:00','MO','14.07.2013','00:53:00',991.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (485,'02:04:00','MO','18.08.2012','03:16:00',991.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (486,'03:35:00','NM','26.08.2019','07:16:00',991.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (487,'08:21:00','MO','02.01.2018','03:23:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (488,'05:05:00','NM','14.01.2014','00:41:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (489,'09:37:00','MO','11.11.2010','07:54:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (490,'09:05:00','NM','31.05.2017','07:58:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (491,'02:29:00','NM','04.12.2014','10:32:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (492,'05:03:00','NM','13.12.2011','01:02:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (493,'04:53:00','MO','07.12.2013','01:44:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (494,'08:09:00','MO','26.07.2014','03:11:00',994.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (495,'03:33:00','NM','13.11.2010','07:08:00',994.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (496,'07:51:00','NM','18.11.2000','08:40:00',994.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (497,'07:07:00','NM','21.04.2019','06:01:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (498,'10:25:00','MO','12.02.2020','09:05:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (499,'06:32:00','NM','01.06.2003','03:01:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (500,'09:28:00','NM','02.04.2016','10:32:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (501,'03:25:00','NM','04.08.2018','00:49:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (502,'01:37:00','MO','24.09.2011','06:00:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (503,'10:10:00','NM','27.08.2014','10:53:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (504,'06:37:00','MO','28.12.2009','10:34:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (505,'09:36:00','NM','06.09.2007','07:03:00',982.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (506,'05:36:00','NM','29.08.2013','03:20:00',991.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (507,'05:34:00','NM','01.01.2012','05:19:00',991.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (508,'06:13:00','NM','01.05.2000','05:13:00',991.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (509,'02:17:00','NM','02.02.2018','06:47:00',993.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (510,'04:49:00','NM','30.01.2018','06:56:00',993.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (511,'06:56:00','NM','19.11.2006','04:27:00',993.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (512,'07:48:00','NM','02.03.2021','00:51:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (513,'03:38:00','MO','08.01.2000','07:06:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (514,'09:28:00','MO','11.07.2020','04:05:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (515,'09:50:00','MO','12.09.2007','05:29:00',991.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (516,'08:02:00','MO','15.10.2018','03:51:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (517,'07:05:00','NM','12.05.2015','04:06:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (518,'05:37:00','MO','03.12.2002','05:55:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (519,'08:40:00','MO','05.02.2014','10:45:00',981.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (520,'07:01:00','MO','05.02.2007','02:53:00',981.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (521,'03:00:00','NM','11.08.2003','01:37:00',985.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (522,'07:22:00','MO','16.01.2008','10:37:00',985.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (523,'07:41:00','MO','21.07.2016','09:40:00',985.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (524,'05:43:00','MO','15.11.2003','09:36:00',993.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (525,'07:03:00','NM','05.11.2017','03:48:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (526,'05:57:00','MO','07.02.2003','03:01:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (527,'05:00:00','NM','22.08.2016','04:32:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (528,'04:44:00','NM','27.06.2010','06:57:00',979.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (529,'09:53:00','MO','07.01.2002','10:44:00',979.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (530,'00:43:00','MO','14.06.2005','10:58:00',979.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (531,'09:04:00','NM','22.03.2015','10:55:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (532,'03:34:00','MO','31.08.2006','02:04:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (533,'06:35:00','MO','03.01.2021','07:47:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (534,'07:44:00','MO','08.09.2018','10:28:00',991.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (535,'03:06:00','NM','26.06.2009','08:03:00',991.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (536,'02:40:00','MO','11.11.2017','07:17:00',991.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (537,'04:19:00','NM','09.02.2002','09:17:00',994.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (538,'04:53:00','NM','14.11.2003','00:18:00',994.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (539,'06:08:00','NM','11.02.2005','03:23:00',994.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (540,'00:19:00','MO','27.03.2017','08:21:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (541,'07:00:00','MO','05.03.2009','07:56:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (542,'07:30:00','MO','18.07.2004','00:48:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (543,'06:54:00','MO','19.03.2006','04:16:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (544,'01:50:00','NM','21.01.2015','04:58:00',983.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (545,'10:31:00','NM','24.04.2013','10:27:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (546,'01:27:00','MO','26.01.2016','08:31:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (547,'10:41:00','NM','15.02.2004','10:45:00',977.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (548,'07:40:00','MO','13.07.2017','01:04:00',977.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (549,'03:31:00','MO','29.08.2015','00:06:00',977.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (550,'05:46:00','NM','19.07.2005','08:54:00',982.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (551,'01:44:00','MO','19.10.2004','01:33:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (552,'05:58:00','MO','07.03.2006','09:55:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (553,'02:06:00','MO','09.01.2020','04:16:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (554,'01:03:00','NM','02.03.2021','04:12:00',985.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (555,'06:26:00','NM','26.08.2013','01:05:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (556,'04:30:00','MO','21.11.2007','07:27:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (557,'00:44:00','NM','26.05.2014','04:38:00',987.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (558,'04:18:00','MO','10.02.2014','04:53:00',987.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (559,'10:39:00','NM','24.03.2002','00:12:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (560,'06:15:00','MO','17.12.2004','06:58:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (561,'07:31:00','NM','17.10.2007','01:24:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (562,'01:06:00','MO','18.01.2017','10:24:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (563,'08:24:00','MO','24.08.2014','08:52:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (564,'01:45:00','MO','10.10.2011','03:29:00',983.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (565,'07:28:00','MO','11.02.2016','09:44:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (566,'07:52:00','NM','30.12.2019','05:05:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (567,'10:17:00','NM','16.04.2014','03:51:00',991.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (568,'10:58:00','NM','24.11.2013','02:02:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (569,'01:00:00','NM','26.07.2018','07:40:00',982.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (570,'07:31:00','NM','19.05.2002','02:06:00',982.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (571,'04:16:00','MO','07.08.2007','09:30:00',985.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (572,'00:58:00','MO','09.04.2001','02:01:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (573,'00:10:00','NM','18.05.2016','08:53:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (574,'07:32:00','MO','09.01.2008','03:03:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (575,'07:44:00','MO','01.01.2019','06:28:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (576,'08:58:00','NM','17.10.2016','00:17:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (577,'08:36:00','NM','29.05.2004','04:00:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (578,'01:47:00','MO','26.06.2007','10:44:00',977.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (579,'05:16:00','MO','18.10.2001','01:24:00',977.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (580,'00:09:00','NM','29.12.2015','04:11:00',977.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (581,'08:43:00','NM','25.07.2006','04:13:00',987.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (582,'03:54:00','NM','23.02.2000','06:57:00',987.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (583,'07:00:00','NM','03.10.2004','07:02:00',991.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (584,'10:34:00','MO','03.08.2009','05:07:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (585,'02:42:00','NM','23.01.2007','08:05:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (586,'01:23:00','NM','03.07.2011','07:01:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (587,'04:23:00','NM','03.04.2000','02:11:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (588,'02:32:00','MO','22.09.2014','05:14:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (589,'04:47:00','MO','31.08.2001','01:20:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (590,'01:44:00','MO','04.08.2000','04:05:00',988.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (591,'05:42:00','NM','08.10.2000','01:02:00',988.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (592,'06:18:00','MO','30.06.2016','09:30:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (593,'09:30:00','NM','14.12.2014','00:22:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (594,'02:41:00','NM','24.09.2009','08:46:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (595,'09:49:00','MO','26.10.2012','03:50:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (596,'09:10:00','MO','15.02.2017','01:09:00',983.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (597,'05:39:00','MO','02.07.2015','05:17:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (598,'06:34:00','NM','15.07.2020','10:21:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (599,'10:38:00','NM','16.11.2000','04:30:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (600,'04:35:00','NM','17.10.2002','03:27:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (601,'06:54:00','MO','02.09.2020','08:55:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (602,'01:29:00','MO','27.06.2004','08:24:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (603,'03:34:00','NM','04.05.2019','08:56:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (604,'00:35:00','NM','15.07.2017','08:35:00',979.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (605,'09:52:00','NM','09.11.2001','10:33:00',979.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (606,'05:20:00','NM','27.10.2002','06:57:00',988.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (607,'03:29:00','NM','02.09.2018','01:06:00',988.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (608,'07:36:00','NM','09.09.2019','00:41:00',988.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (609,'03:31:00','MO','28.01.2016','00:06:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (610,'00:58:00','MO','22.11.2012','07:29:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (611,'10:04:00','MO','20.02.2013','01:31:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (612,'07:37:00','MO','10.08.2002','01:36:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (613,'08:15:00','NM','12.11.2004','07:28:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (614,'05:02:00','MO','08.04.2012','09:35:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (615,'05:29:00','NM','05.08.2012','02:16:00',982.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (616,'05:38:00','NM','02.06.2004','07:58:00',982.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (617,'05:42:00','NM','02.01.2012','08:02:00',985.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (618,'05:35:00','NM','18.08.2008','10:40:00',985.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (619,'04:28:00','NM','17.08.2012','05:51:00',991.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (620,'04:09:00','MO','15.12.2005','10:10:00',991.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (621,'06:54:00','NM','19.04.2004','02:43:00',991.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (622,'06:39:00','MO','19.09.2013','10:14:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (623,'08:39:00','MO','27.05.2010','09:24:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (624,'03:41:00','MO','06.12.2006','00:15:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (625,'08:08:00','MO','06.01.2015','05:29:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (626,'10:43:00','NM','01.09.2005','05:51:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (627,'08:17:00','MO','16.12.2016','06:09:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (628,'00:46:00','NM','20.02.2017','01:14:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (629,'05:23:00','NM','20.11.2014','06:12:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (630,'03:40:00','NM','03.02.2014','04:07:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (631,'01:37:00','NM','05.09.2017','01:36:00',983.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (632,'03:30:00','MO','22.08.2008','06:07:00',983.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (633,'07:23:00','NM','15.10.2007','04:21:00',983.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (634,'01:11:00','NM','04.04.2000','08:31:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (635,'09:31:00','MO','14.10.2019','04:25:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (636,'02:40:00','MO','20.06.2002','04:26:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (637,'04:52:00','MO','11.10.2012','10:14:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (638,'05:47:00','MO','05.12.2017','06:51:00',977.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (639,'08:13:00','NM','31.08.2018','08:10:00',977.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (640,'04:14:00','MO','02.03.2005','00:55:00',985.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (641,'09:13:00','NM','26.02.2016','04:39:00',985.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (642,'00:25:00','MO','21.03.2015','09:35:00',985.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (643,'06:39:00','NM','16.09.2016','03:55:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (644,'07:54:00','MO','20.05.2021','07:06:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (645,'03:49:00','MO','01.11.2003','00:56:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (646,'08:22:00','NM','20.01.2015','02:53:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (647,'01:03:00','MO','29.05.2004','04:03:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (648,'07:03:00','NM','27.04.2010','00:31:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (649,'09:11:00','MO','11.08.2017','10:50:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (650,'00:15:00','NM','26.06.2002','01:45:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (651,'01:51:00','MO','06.01.2001','05:22:00',996.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (652,'04:16:00','MO','17.03.2005','06:04:00',996.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (653,'10:25:00','MO','11.06.2019','05:31:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (654,'04:55:00','NM','09.02.2021','07:33:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (655,'04:58:00','NM','31.10.2015','08:15:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (656,'03:49:00','NM','15.09.2011','08:51:00',983.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (657,'04:55:00','NM','29.01.2016','06:38:00',983.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (658,'07:15:00','MO','27.06.2002','00:01:00',983.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (659,'01:35:00','NM','30.03.2000','01:54:00',988.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (660,'04:04:00','MO','26.09.2014','01:33:00',988.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (661,'09:04:00','MO','26.02.2010','08:13:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (662,'09:45:00','MO','10.09.2004','08:27:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (663,'08:09:00','MO','24.08.2002','10:38:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (664,'03:57:00','NM','05.03.2019','08:17:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (665,'01:43:00','MO','20.06.2016','03:20:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (666,'00:47:00','MO','24.10.2018','09:51:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (667,'05:52:00','NM','11.12.2019','09:58:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (668,'08:32:00','NM','12.01.2002','09:13:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (669,'00:22:00','NM','04.05.2003','04:54:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (670,'04:29:00','MO','20.08.2004','03:14:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (671,'06:39:00','MO','17.02.2015','07:21:00',994.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (672,'02:05:00','NM','29.03.2008','06:31:00',994.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (673,'04:07:00','MO','13.11.2018','00:33:00',994.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (674,'05:25:00','NM','07.07.2013','04:22:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (675,'04:07:00','NM','02.02.2012','06:54:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (676,'05:17:00','MO','03.05.2020','10:05:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (677,'03:54:00','MO','03.11.2008','08:08:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (678,'07:57:00','NM','04.03.2004','10:22:00',979.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (679,'04:28:00','NM','15.03.2015','06:00:00',979.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (680,'09:44:00','NM','02.06.2012','04:03:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (681,'05:29:00','MO','03.11.2011','10:45:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (682,'08:06:00','MO','13.10.2001','10:19:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (683,'05:49:00','MO','07.03.2017','07:21:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (684,'08:24:00','MO','20.03.2010','01:22:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (685,'06:05:00','MO','17.09.2020','06:12:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (686,'04:16:00','MO','04.08.2009','07:46:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (687,'00:41:00','MO','30.05.2014','06:39:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (688,'05:23:00','NM','07.03.2007','05:50:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (689,'03:07:00','NM','04.01.2020','04:54:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (690,'03:50:00','MO','02.11.2020','01:44:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (691,'02:45:00','NM','06.08.2007','03:53:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (692,'01:38:00','NM','04.10.2012','04:26:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (693,'02:15:00','NM','02.05.2021','02:03:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (694,'01:28:00','MO','07.06.2020','10:18:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (695,'09:54:00','MO','27.10.2002','01:44:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (696,'05:31:00','MO','16.12.2015','07:13:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (697,'06:52:00','NM','06.01.2021','05:18:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (698,'02:47:00','MO','03.02.2008','02:13:00',994.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (699,'06:31:00','NM','27.08.2015','03:02:00',994.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (700,'08:45:00','NM','07.01.2007','07:52:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (701,'06:28:00','MO','03.09.2017','04:17:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (702,'00:51:00','NM','22.06.2002','02:31:00',983.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (703,'03:18:00','MO','07.09.2005','06:34:00',983.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (704,'06:50:00','MO','13.09.2002','08:20:00',983.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (705,'09:37:00','MO','10.05.2020','09:15:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (706,'08:13:00','MO','20.07.2017','07:31:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (707,'02:16:00','MO','30.07.2011','08:32:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (708,'10:04:00','NM','06.08.2007','10:49:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (709,'06:37:00','MO','07.08.2000','08:10:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (710,'04:41:00','MO','22.06.2000','02:13:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (711,'07:58:00','MO','04.04.2006','02:05:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (712,'09:32:00','NM','20.02.2016','02:16:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (713,'08:11:00','MO','22.08.2015','10:32:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (714,'07:20:00','MO','26.05.2015','00:11:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (715,'08:29:00','NM','09.06.2016','06:08:00',985.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (716,'09:14:00','MO','31.03.2002','06:29:00',985.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (717,'00:52:00','MO','05.09.2000','09:31:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (718,'04:12:00','NM','29.01.2011','03:51:00',996.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (719,'08:45:00','MO','22.11.2003','04:36:00',996.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (720,'00:43:00','NM','02.01.2008','03:34:00',996.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (721,'09:42:00','MO','12.11.2001','03:05:00',981.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (722,'05:54:00','MO','23.04.2014','05:08:00',981.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (723,'03:38:00','NM','05.11.2015','05:38:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (724,'02:57:00','MO','14.08.2004','06:07:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (725,'05:30:00','MO','05.01.2009','05:51:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (726,'08:07:00','NM','30.03.2020','00:07:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (727,'10:53:00','MO','30.11.2011','01:36:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (728,'08:17:00','MO','23.09.2003','09:47:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (729,'07:24:00','NM','04.07.2016','07:31:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (730,'07:58:00','NM','17.10.2005','06:40:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (731,'02:37:00','NM','27.03.2007','07:09:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (732,'10:31:00','NM','06.04.2010','07:40:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (733,'06:02:00','NM','26.03.2015','00:00:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (734,'03:17:00','NM','28.02.2002','04:49:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (735,'07:09:00','MO','20.06.2004','00:23:00',988.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (736,'02:48:00','NM','12.09.2013','08:58:00',988.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (737,'02:28:00','NM','23.05.2007','01:49:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (738,'00:15:00','NM','03.12.2003','04:49:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (739,'01:11:00','MO','14.04.2020','06:07:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (740,'01:02:00','MO','24.03.2016','10:35:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (741,'09:18:00','MO','01.11.2003','00:07:00',982.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (742,'03:05:00','MO','21.10.2016','05:56:00',987.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (743,'09:58:00','NM','28.03.2001','03:51:00',987.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (744,'00:07:00','MO','16.07.2000','10:06:00',987.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (745,'03:00:00','NM','23.10.2013','07:03:00',996.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (746,'03:33:00','NM','01.11.2011','07:05:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (747,'09:25:00','NM','18.08.2014','05:49:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (748,'01:40:00','NM','29.05.2015','06:53:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (749,'07:49:00','MO','05.02.2012','07:46:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (750,'04:06:00','NM','22.07.2017','09:32:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (751,'08:12:00','MO','24.02.2019','04:09:00',985.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (752,'10:05:00','MO','09.08.2000','03:45:00',987.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (753,'09:26:00','MO','15.07.2018','09:29:00',987.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (754,'00:57:00','MO','09.09.2013','01:06:00',987.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (755,'02:00:00','NM','29.11.2009','09:22:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (756,'09:38:00','MO','26.08.2016','09:25:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (757,'02:23:00','NM','08.01.2000','05:11:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (758,'08:42:00','NM','10.09.2011','10:30:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (759,'09:02:00','NM','30.05.2017','03:34:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (760,'09:36:00','NM','17.06.2011','06:44:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (761,'03:38:00','MO','06.12.2000','05:03:00',983.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (762,'08:29:00','MO','02.11.2020','01:41:00',983.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (763,'07:19:00','MO','15.02.2008','09:31:00',983.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (764,'07:42:00','NM','13.10.2003','06:34:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (765,'04:11:00','NM','17.06.2015','07:00:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (766,'08:27:00','MO','25.05.2011','01:16:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (767,'01:45:00','NM','15.05.2005','07:19:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (768,'03:25:00','MO','19.04.2016','02:02:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (769,'05:48:00','NM','17.09.2000','04:02:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (770,'00:35:00','MO','29.05.2000','01:50:00',977.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (771,'09:04:00','MO','29.12.2019','08:51:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (772,'07:29:00','NM','08.05.2014','10:30:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (773,'01:07:00','NM','17.11.2004','02:02:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (774,'02:43:00','MO','08.04.2013','01:39:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (775,'03:01:00','MO','10.12.2016','04:52:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (776,'08:12:00','NM','02.01.2014','01:30:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (777,'07:17:00','MO','04.12.2007','05:26:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (778,'04:15:00','MO','10.10.2003','03:50:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (779,'04:49:00','NM','07.02.2000','05:48:00',979.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (780,'05:06:00','MO','10.07.2000','06:16:00',982.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (781,'09:06:00','MO','15.07.2006','00:14:00',982.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (782,'00:57:00','NM','20.11.2003','09:50:00',985.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (783,'07:06:00','MO','11.03.2000','01:19:00',985.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (784,'06:08:00','NM','07.02.2007','00:49:00',985.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (785,'08:12:00','NM','19.05.2017','07:55:00',987.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (786,'10:29:00','NM','15.12.2012','08:11:00',987.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (787,'07:52:00','NM','04.11.2009','03:07:00',987.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (788,'06:04:00','NM','25.02.2017','03:19:00',996.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (789,'06:19:00','NM','28.01.2015','09:42:00',996.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (790,'07:07:00','MO','28.08.2012','08:00:00',996.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (791,'09:33:00','NM','31.08.2007','05:19:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (792,'09:30:00','NM','09.12.2010','02:16:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (793,'04:40:00','MO','20.02.2006','07:53:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (794,'03:22:00','MO','03.04.2006','03:46:00',981.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (795,'00:25:00','MO','02.10.2014','05:05:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (796,'06:53:00','MO','17.02.2011','09:09:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (797,'02:36:00','NM','09.05.2014','09:25:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (798,'00:49:00','MO','23.10.2018','02:58:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (799,'04:06:00','MO','14.08.2000','09:46:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (800,'07:47:00','NM','18.01.2008','09:10:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (801,'06:56:00','MO','23.12.2018','06:48:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (802,'09:23:00','NM','11.04.2016','06:30:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (803,'09:12:00','NM','15.09.2005','00:13:00',982.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (804,'07:37:00','MO','27.05.2012','05:47:00',982.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (805,'04:48:00','NM','22.08.2021','01:44:00',982.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (806,'01:47:00','MO','12.04.2020','00:16:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (807,'06:18:00','MO','17.08.2000','09:47:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (808,'02:34:00','NM','24.08.2021','00:20:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (809,'04:09:00','NM','09.02.2009','02:03:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (810,'09:54:00','MO','18.11.2008','10:54:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (811,'05:49:00','MO','25.03.2000','10:18:00',977.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (812,'08:57:00','MO','05.05.2000','07:16:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (813,'07:43:00','MO','08.09.2016','06:04:00',988.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (814,'03:20:00','MO','20.08.2012','04:53:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (815,'06:41:00','MO','08.05.2003','00:23:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (816,'08:30:00','NM','24.12.2020','05:58:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (817,'08:21:00','NM','06.12.2001','08:07:00',994.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (818,'02:41:00','NM','05.04.2019','10:48:00',994.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (819,'02:49:00','NM','16.08.2011','05:31:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (820,'06:48:00','NM','27.07.2021','01:28:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (821,'01:58:00','NM','05.06.2016','01:44:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (822,'00:42:00','MO','01.08.2017','10:07:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (823,'08:16:00','MO','15.11.2002','05:39:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (824,'09:06:00','MO','05.11.2010','05:02:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (825,'09:02:00','MO','20.10.2003','10:17:00',981.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (826,'07:08:00','MO','05.04.2020','05:11:00',981.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (827,'08:45:00','MO','28.09.2000','00:34:00',981.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (828,'01:49:00','NM','26.07.2015','02:11:00',982.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (829,'02:22:00','MO','01.12.2010','07:15:00',982.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (830,'00:11:00','MO','07.05.2011','10:10:00',982.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (831,'05:36:00','NM','07.08.2014','05:21:00',988.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (832,'05:43:00','MO','26.10.2014','03:38:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (833,'01:19:00','MO','09.12.2011','02:34:00',981.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (834,'01:07:00','NM','18.09.2018','04:35:00',981.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (835,'04:02:00','MO','15.03.2005','06:20:00',981.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (836,'09:22:00','MO','08.06.2004','02:27:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (837,'01:54:00','MO','27.08.2004','00:31:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (838,'01:05:00','NM','04.01.2018','00:52:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (839,'08:01:00','MO','06.04.2009','03:56:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (840,'02:56:00','MO','15.03.2016','07:45:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (841,'02:38:00','MO','15.11.2008','02:23:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (842,'07:26:00','NM','14.11.2004','07:53:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (843,'01:53:00','MO','19.11.2019','00:11:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (844,'02:38:00','MO','08.03.2001','04:40:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (845,'03:52:00','NM','08.08.2016','07:04:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (846,'02:57:00','MO','22.07.2002','01:21:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (847,'06:33:00','MO','02.12.2004','01:05:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (848,'06:42:00','NM','06.09.2012','10:37:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (849,'05:39:00','MO','04.07.2012','01:21:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (850,'08:37:00','NM','16.02.2001','03:15:00',985.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (851,'09:45:00','NM','18.06.2020','09:39:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (852,'02:34:00','MO','09.01.2018','08:47:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (853,'04:13:00','NM','11.10.2004','05:40:00',988.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (854,'08:58:00','MO','12.07.2021','05:03:00',993.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (855,'08:52:00','MO','24.02.2010','07:31:00',977.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (856,'02:41:00','MO','26.11.2014','08:28:00',977.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (857,'06:09:00','MO','02.01.2002','06:27:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (858,'10:43:00','MO','23.04.2017','00:44:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (859,'03:39:00','MO','20.03.2011','01:18:00',991.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (860,'00:21:00','NM','04.09.2011','07:52:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (861,'06:17:00','MO','02.10.2019','01:38:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (862,'02:16:00','NM','28.03.2020','01:43:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (863,'02:17:00','NM','29.04.2016','01:50:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (864,'06:54:00','NM','26.09.2004','02:41:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (865,'04:05:00','NM','27.09.2018','02:34:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (866,'04:54:00','NM','19.02.2001','09:45:00',983.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (867,'03:19:00','NM','23.06.2000','05:05:00',983.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (868,'08:11:00','MO','03.08.2002','06:48:00',983.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (869,'00:06:00','NM','23.04.2015','09:56:00',991.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (870,'05:53:00','NM','08.10.2016','08:10:00',991.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (871,'04:56:00','MO','25.03.2015','00:39:00',993.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (872,'03:08:00','MO','31.08.2011','01:03:00',993.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (873,'01:36:00','NM','09.04.2010','09:30:00',993.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (874,'07:51:00','MO','09.12.2001','00:02:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (875,'07:50:00','MO','16.09.2016','01:42:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (876,'05:08:00','MO','12.11.2010','01:33:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (877,'08:03:00','NM','23.04.2010','06:56:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (878,'09:17:00','NM','07.07.2007','06:44:00',985.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (879,'02:16:00','MO','08.08.2002','08:55:00',985.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (880,'09:05:00','NM','20.11.2006','08:29:00',994.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (881,'04:32:00','NM','17.01.2021','05:40:00',994.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (882,'07:44:00','NM','10.08.2014','00:42:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (883,'10:11:00','NM','31.01.2010','10:44:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (884,'01:50:00','NM','29.08.2006','04:42:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (885,'09:29:00','MO','15.07.2018','02:36:00',988.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (886,'02:49:00','NM','06.07.2019','07:44:00',994.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (887,'04:19:00','NM','22.02.2012','03:05:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (888,'09:57:00','NM','14.03.2011','02:53:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (889,'04:33:00','NM','03.04.2021','06:43:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (890,'07:12:00','MO','11.09.2007','04:02:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (891,'03:26:00','NM','11.07.2005','00:47:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (892,'09:51:00','MO','03.05.2001','08:05:00',980.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (893,'03:24:00','MO','23.04.2006','00:01:00',982.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (894,'00:44:00','MO','06.10.2012','03:37:00',982.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (895,'04:04:00','MO','31.03.2013','07:24:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (896,'00:19:00','NM','30.04.2008','09:14:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (897,'06:47:00','MO','10.02.2019','05:26:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (898,'02:24:00','NM','18.03.2004','03:53:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (899,'08:35:00','NM','11.01.2010','01:55:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (900,'00:23:00','MO','02.03.2014','04:25:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (901,'02:00:00','NM','05.07.2004','01:45:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (902,'08:55:00','NM','26.05.2014','10:01:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (903,'07:41:00','MO','15.12.2017','08:16:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (904,'01:41:00','MO','11.06.2009','09:24:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (905,'02:47:00','NM','23.02.2009','01:02:00',983.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (906,'04:16:00','NM','11.08.2011','04:32:00',983.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (907,'01:43:00','MO','30.07.2021','00:52:00',988.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (908,'06:26:00','NM','19.04.2018','00:16:00',996.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (909,'04:54:00','NM','05.09.2009','05:36:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (910,'03:22:00','NM','16.07.2013','10:15:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (911,'07:55:00','MO','03.04.2021','04:46:00',982.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (912,'07:53:00','MO','05.03.2009','01:22:00',983.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (913,'09:28:00','NM','24.09.2015','02:16:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (914,'05:05:00','NM','24.07.2021','00:24:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (915,'09:20:00','NM','11.02.2018','09:02:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (916,'01:01:00','NM','12.07.2001','06:30:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (917,'04:20:00','MO','06.11.2019','10:21:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (918,'01:07:00','NM','02.11.2000','10:50:00',979.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (919,'00:51:00','MO','28.01.2002','06:43:00',979.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (920,'00:40:00','NM','25.08.2014','02:07:00',979.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (921,'04:38:00','NM','22.03.2013','09:24:00',983.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (922,'04:25:00','NM','13.07.2006','04:32:00',987.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (923,'10:10:00','MO','08.06.2014','03:34:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (924,'10:05:00','NM','29.03.2010','03:55:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (925,'05:42:00','NM','23.12.2006','04:07:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (926,'07:57:00','MO','10.10.2017','09:10:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (927,'06:49:00','NM','19.04.2006','05:04:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (928,'02:18:00','NM','20.09.2013','07:56:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (929,'07:14:00','MO','29.09.2020','03:48:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (930,'03:57:00','MO','28.03.2019','01:00:00',981.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (931,'09:35:00','NM','23.03.2004','08:35:00',981.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (932,'05:18:00','MO','19.03.2002','06:18:00',981.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (933,'04:40:00','MO','23.05.2010','05:57:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (934,'05:45:00','MO','20.11.2007','03:11:00',990.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (935,'04:15:00','NM','09.10.2004','01:31:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (936,'01:47:00','MO','03.02.2021','09:05:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (937,'04:20:00','NM','09.04.2003','00:15:00',996.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (938,'00:57:00','MO','11.07.2013','02:22:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (939,'00:45:00','NM','15.04.2018','08:33:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (940,'00:55:00','NM','15.02.2011','06:06:00',981.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (941,'00:26:00','NM','26.03.2010','09:25:00',981.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (942,'01:09:00','MO','22.08.2011','00:24:00',981.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (943,'05:18:00','NM','21.03.2007','09:03:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (944,'01:18:00','NM','21.01.2018','01:10:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (945,'03:00:00','NM','23.11.2000','02:13:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (946,'09:49:00','NM','18.08.2008','01:22:00',998.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (947,'03:34:00','NM','13.09.2000','00:40:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (948,'03:41:00','MO','21.11.2010','05:18:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (949,'05:46:00','NM','11.12.2018','06:38:00',985.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (950,'10:20:00','MO','13.03.2012','07:20:00',985.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (951,'09:54:00','MO','26.02.2012','00:03:00',985.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (952,'02:56:00','MO','07.03.2012','08:11:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (953,'02:06:00','NM','19.08.2004','02:22:00',994.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (954,'09:13:00','MO','20.08.2011','05:21:00',994.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (955,'02:58:00','MO','07.03.2008','03:27:00',994.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (956,'05:31:00','NM','20.04.2019','10:58:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (957,'04:44:00','NM','08.09.2004','00:44:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (958,'05:37:00','MO','20.01.2012','00:41:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (959,'02:19:00','NM','25.04.2014','08:55:00',993.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (960,'09:05:00','MO','19.02.2021','03:26:00',996.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (961,'04:15:00','NM','20.10.2009','02:46:00',979.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (962,'10:52:00','MO','30.04.2009','10:04:00',989.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (963,'08:34:00','MO','22.08.2014','04:58:00',995.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (964,'06:07:00','NM','26.07.2012','04:44:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (965,'10:20:00','NM','10.10.2002','00:09:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (966,'08:39:00','MO','02.03.2004','02:04:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (967,'01:20:00','MO','20.04.2015','09:55:00',981.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (968,'00:04:00','NM','20.11.2007','00:26:00',981.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (969,'00:21:00','MO','06.05.2006','04:54:00',981.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (970,'09:28:00','MO','19.07.2010','07:06:00',987.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (971,'07:41:00','MO','15.06.2003','08:26:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (972,'02:37:00','MO','22.05.2001','02:54:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (973,'03:53:00','MO','28.08.2006','03:30:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (974,'00:14:00','MO','29.07.2015','09:21:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (975,'02:45:00','NM','14.07.2012','10:56:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (976,'10:32:00','NM','26.04.2006','06:27:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (977,'00:25:00','MO','28.03.2000','08:07:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (978,'10:05:00','NM','27.06.2015','01:13:00',976.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (979,'02:13:00','MO','23.11.2008','07:31:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (980,'07:32:00','NM','21.08.2011','10:46:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (981,'10:12:00','MO','16.02.2011','10:29:00',978.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (982,'00:45:00','NM','11.04.2016','05:33:00',984.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (983,'05:36:00','NM','10.01.2020','02:55:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (984,'01:19:00','NM','13.12.2016','07:32:00',986.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (985,'10:38:00','MO','29.10.2012','02:22:00',993.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (986,'01:48:00','MO','08.01.2003','09:47:00',993.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (987,'05:35:00','MO','19.07.2016','05:09:00',993.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (988,'01:41:00','MO','03.11.2002','05:57:00',994.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (989,'00:09:00','NM','12.02.2020','02:40:00',997.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (990,'09:44:00','NM','14.12.2004','05:37:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (991,'09:03:00','MO','04.06.2014','06:28:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (992,'06:28:00','MO','25.08.2018','04:28:00',985.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (993,'06:43:00','NM','03.12.2007','10:23:00',985.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (994,'04:51:00','MO','01.06.2012','03:22:00',992.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (995,'01:29:00','MO','29.07.2012','07:55:00',994.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (996,'10:03:00','NM','18.03.2019','08:41:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (997,'00:35:00','MO','07.01.2014','04:46:00',999.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (998,'09:29:00','NM','20.08.2005','07:49:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (999,'06:25:00','MO','18.06.2019','06:57:00',1000.0);
INSERT INTO "online_challenge_activity"."sfida" ("cods","durmax","tiposfi","data","ora","codg") VALUES (1000,'08:34:00','NM','10.09.2011','05:47:00',1000.0);







--7.	Creazione schema fisico:


	--1
	CREATE INDEX idxmaxsq ON Gioco (maxsq);

	--2
	CREATE INDEX idxmaxdadi ON Gioco (maxdadi);
	CLUSTER Gioco USING idxmaxdadi;

	--3
	CREATE INDEX idxcodG ON Sfida (codG);

	--4
	CREATE INDEX idxdata ON Sfida (data);

	--5
	CREATE INDEX idxdurmax ON Sfida (durmax);
	CLUSTER Sfida USING idxdurmax;



--8.	Interrogazioni e vista:


-- Determinare l’identificatore dei giochi che coinvolgono al più quattro squadre e richiedono l’uso di due dadi


	select id
	from Gioco G
	where maxsq<=4 and maxdadi=2;


--Determinare l’identificatore delle sfide relative al gioco 0001 che, in alternativa:
--hanno avuto luogo a gennaio 2021 e durata massima superiore a 2 ore,
--o hanno avuto luogo a marzo 2021 e durata massima pari a 30 minuti


	select codS
	from Sfida S
	where codG='0001' and data>='01-01-2021' and data<='31-01-2021' and durmax>'02:00:00'
	UNION 
	select codS
	from Sfida S
	where codG='0001' and data>='01-03-2021' and data<='31-03-2021' and durmax='00:30:00';	


--Determinare le sfide, di durata massima superiore a 2 ore, dei giochi che richiedono almeno due dadi.
--Restituire sia l’identificatore della sfida sia l’identificatore del gioco.


	select codS, id
	from Gioco G, Sfida S
	where S.codG=G.id and durmax>'02:00:00' and maxdadi>=2;
	

--La definizione di una vista che fornisca alcune informazioni riassuntive per ogni gioco: 
--il numero di sfide relative a quel gioco disputate, la durata media di tali sfide, 
--il numero di squadre e di giocatori partecipanti a tali sfide, 
--i punteggi minimo, medio e massimo ottenuti dalle squadre partecipanti a tali sfide;



CREATE VIEW Gameinfoaux1 AS	
	select G.id, count (*) as numsfide , avg (durmax) as durmedia
	from Gioco G, Sfida S
	where S.codG=G.id
	group by G.id
	order by G.id;

CREATE VIEW Gameinfoaux2 AS	
	select G.id, S.codS, count(*) as numsqu, min(P.punt) as minimo, max(P.punt) as massimo, avg (P.punt) as media
	from Partecipa P, Gioco G, Sfida S
	where S.codG=G.id and S.codS=P.codS
	group by id, S.codS
	order by S.codS;
	
CREATE VIEW Gameinfoaux3 AS	
	select id, sum (giocatori) as numgioc
	from Gioco G, 	(	select S.codG,G.nomesq, count (*) as giocatori
						from Gioca G, Partecipa P, Sfida S
						where G.nomesq=P.nomesq and P.codS=S.codS
						group by S.codG,G.nomesq)		as A
	where G.id=A.codG
	group by id;
	
CREATE VIEW Gameinfo AS	
	select G.id, numsfide, durmedia, numsqu, numgioc, minimo, massimo, media
	from Gameinfoaux1 g1, Gameinfoaux2 g2, Gameinfoaux3 g3, Gioco G
	where g1.id = G.id and g2.id=G.id and g3.id=G.id
	group by G.id, numsfide, durmedia, numsqu, numgioc, minimo, massimo, media
	order by G.id;
	


--a. Determinare i giochi che contengono caselle a cui sono associati task;

	
	select DISTINCT idG
	from Tiene T
	order by idG;

-- b. Determinare i giochi che non contengono caselle a cui sono associati task;

	select id
	from Gioco
	where id NOT IN (	select DISTINCT idG
						from tiene )
	order by id;
	
-- c. Determinare le sfide che hanno durata superiore alla durata media delle sfide relative allo stesso gioco.

	select codS
	from Sfida S
	where durmax > (select AVG(durmax)
				   	from Sfida Sf
				    where S.codG=Sf.codG)
	order by codS;

--9. Procedure/funzioni:

--a. Funzione che realizza l’interrogazione 2c in maniera parametrica rispetto
--all’ID del gioco (cioè determina le sfide che hanno durata superiore alla durata medie delle sfide
--di un dato gioco, prendendo come parametro l’ID del gioco);


	CREATE FUNCTION sfidemaggavg (IN idGioco NUMERIC(4)) 
	RETURNS TABLE ( codS NUMERIC (4)) AS
		$$
		DECLARE Gioc NUMERIC(4);
		BEGIN
			Gioc:= (select id from Gioco where id=idGioco);
			IF Gioc IS NULL THEN RAISE EXCEPTION 'Error non può essere presente valore null nel parametro';
			END IF;
			IF (select id from Gioco where id=Gioc) IS NULL THEN RAISE EXCEPTION 'Non ci sono sfide per questo gioco';
			END IF;

			RETURN QUERY 	select S.codS
							from Sfida S
							where codG=Gioc and durmax > (select AVG(durmax)
														  from Sfida Sf
														  where codG=Gioc)
							order by S.codS;
			IF NOT FOUND THEN RAISE EXCEPTION 'Non cè nessuna sfida con durata maggiore alla durata media delle sfide per questo gioco';
			END IF;
			RETURN;
		END;
		$$
	LANGUAGE plpgsql;


--b. Funzione di scelta dell’icona da parte di una squadra in una sfida: possono essere scelte solo le
--icone corrispondenti al gioco cui si riferisce la sfida che non siano già state scelte da altre squadre.


CREATE FUNCTION sceltaicona (IN codSfida NUMERIC(4))
	RETURNS TABLE(nomei VARCHAR(15)) AS
	$$
	DECLARE funsfida NUMERIC(4);
	BEGIN
		funsfida:=(select codS from Sfida where codS=codSfida);
		IF funsfida IS NULL THEN RAISE EXCEPTION 'Sfida selezionata inesistente';
		END IF;
		RETURN QUERY
						select C.nomei
						from Contiene C, Sfida Sf
						where C.idg=Sf.codG and Sf.codS='9' and C.nomei NOT IN (select Sq.nomei
																				from Partecipa P, Sfida S, Squadra Sq
																				where P.codS=S.codS and P.nomesq=Sq.nomesq and S.codS='9');																				
		IF NOT FOUND THEN RAISE EXCEPTION 'Non ci sono più pedine disponibili per la sfida selezionata :C ';
		END IF;
		RETURN;
	END; 
	$$
LANGUAGE plpgsql;



--10. Trigger:

--a. Verifica del vincolo che nessun utente possa partecipare a sfide contemporanee;


	CREATE OR REPLACE FUNCTION nout()
	RETURNS TRIGGER AS $nout$

	BEGIN
		IF (select count (*)
			from (	select distinct nickgioc
					from Gioca G, Partecipa Pa
					where G.nomesq=Pa.nomesq and nickgioc IN (select Gi.nickgioc
															  from Gioca Gi, Partecipa P
															  where Gi.nomesq=P.nomesq and G.nickgioc=Gi.nickgioc and P.codS<>Pa.codS)) as B) >0
		THEN RAISE EXCEPTION 'Il giocatore che vuoi inserire fa già parte di una Squadra';
		ELSE
			RETURN NEW;
		END IF;
	END;
	$nout$
	LANGUAGE plpgsql;

	CREATE TRIGGER vinutent
	AFTER INSERT OR UPDATE ON Partecipa FOR EACH ROW
	EXECUTE PROCEDURE nout();


--b. b. Mantenimento del punteggio corrente di ciascuna squadra in ogni sfida e inserimento delle
--icone opportune nella casella podio.


	CREATE FUNCTION aggpodio()
	RETURNS TRIGGER AS $aggpodio$
	DECLARE fpunt INT;
	DECLARE fcodsfida NUMERIC(4);
	DECLARE fsqprima VARCHAR(15);
	DECLARE fsqseconda VARCHAR(15);
	DECLARE fsqterza VARCHAR(15);

	BEGIN
	fpunt:=(select sum(Som.punrisp+Som.puntask) as allpunt
			from		(select P.codS, P.nomesq, sum(R.punt) as punrisp, sum(T.punt) as puntask
						from Giocatore G, Gioca Gi, Vota V, Risposta R, Partecipa P, File F, Task T
						where Gi.nickgioc=G.nick and V.nickgioc=G.nick and V.codR=R.codR and G.nick=F.nickgioc and T.codT=F.codT and P.nomesq=Gi.nomesq
						and G.nick=new.nickgioc
						group by P.codS,P.nomesq) as Som);
	
	fcodsfida:=(select P.codS
				from Partecipa P, Gioca G, File F, Vota V
				where P.nomesq=G.nomesq and G.nickgioc=F.nickgioc and V.nickgioc=G.nickgioc
				and (F.nickgioc=new.nickgioc or V.nickgioc=new.nickgioc));		
			
			
	UPDATE Partecipa 
	SET punt=fpunt 
	WHERE Partecipa.nomesq=(select P.nomesq
							from Partecipa P, Gioca G, File F, Vota V
							where P.nomesq=G.nomesq and G.nickgioc=F.nickgioc and V.nickgioc=G.nickgioc
							and (F.nickgioc=new.nickgioc or V.nickgioc=new.nickgioc))
	and Partecipa.codS=fcodsfida;
	
	
	fsqterza:=(select Fin.nomesq
			   from 		(select Som.codS,Som.nomesq,sum(Som.punrisp+Som.puntask) as allpunt
						     from		(select P.codS, P.nomesq, sum(R.punt) as punrisp, sum(T.punt) as puntask
										  from Giocatore G, Gioca Gi, Vota V, Risposta R, Partecipa P, File F, Task T
										  where Gi.nickgioc=G.nick and V.nickgioc=G.nick and V.codR=R.codR and G.nick=F.nickgioc and T.codT=F.codT and P.nomesq=Gi.nomesq
										  group by P.codS,P.nomesq) as Som
							 group by Som.codS,Som.nomesq
							 order by allpunt desc limit 1 offset 2) as Fin);
	
	
	fsqseconda:=(select Fin.nomesq
			   from 		(select Som.codS,Som.nomesq,sum(Som.punrisp+Som.puntask) as allpunt
						     from		(select P.codS, P.nomesq, sum(R.punt) as punrisp, sum(T.punt) as puntask
										  from Giocatore G, Gioca Gi, Vota V, Risposta R, Partecipa P, File F, Task T
										  where Gi.nickgioc=G.nick and V.nickgioc=G.nick and V.codR=R.codR and G.nick=F.nickgioc and T.codT=F.codT and P.nomesq=Gi.nomesq
										  group by P.codS,P.nomesq) as Som
							 group by Som.codS,Som.nomesq
							 order by allpunt desc limit 1 offset 1) as Fin);
	
	
	fsqprima:=(select Fin.nomesq
			   from 		(select Som.codS,Som.nomesq,sum(Som.punrisp+Som.puntask) as allpunt
						     from		(select P.codS, P.nomesq, sum(R.punt) as punrisp, sum(T.punt) as puntask
										  from Giocatore G, Gioca Gi, Vota V, Risposta R, Partecipa P, File F, Task T
										  where Gi.nickgioc=G.nick and V.nickgioc=G.nick and V.codR=R.codR and G.nick=F.nickgioc and T.codT=F.codT and P.nomesq=Gi.nomesq
										  group by P.codS,P.nomesq) as Som
							 group by Som.codS,Som.nomesq
							 order by allpunt desc limit 1) as Fin);
							 
	UPDATE Partecipa
	SET cpodio='0';
							 
	UPDATE Partecipa
	SET cpodio='1'
	WHERE Partecipa.codS=fcodsfida
	and Partecipa.nomesq=fsqprima;

	UPDATE Partecipa
	SET cpodio='2'
	WHERE Partecipa.codS=fcodsfida
	and Partecipa.nomesq=fsqseconda;
	
	UPDATE Partecipa
	SET cpodio='3'
	WHERE Partecipa.codS=fcodsfida
	and Partecipa.nomesq=fsqterza;
	
	RETURN NEW;
	END;
	$aggpodio$
	LANGUAGE plpgsql;

	CREATE TRIGGER aggpodiotask
	AFTER INSERT ON File
	FOR EACH ROW
	EXECUTE PROCEDURE aggpodio();

	CREATE TRIGGER aggpodioquiz
	AFTER INSERT ON Vota
	FOR EACH ROW
	EXECUTE PROCEDURE aggpodio();



