
--Parte III


--Creazioni Ruoli:

CREATE ROLE gameadmin;
CREATE ROLE gamecreator;
CREATE ROLE giocatore;
CREATE ROLE utente;


--Permessi:


GRANT SELECT ON "online_challenge_activity".Contiene, "online_challenge_activity".Giocatore,
"online_challenge_activity".Gioco, "online_challenge_activity".Icona
TO utente;
GRANT UPDATE ON "online_challenge_activity".Giocatore TO UTENTE;
GRANT DELETE ON "online_challenge_activity".Giocatore TO UTENTE;
GRANT INSERT ON "online_challenge_activity".Giocatore TO UTENTE;



GRANT SELECT ON "online_challenge_activity".Casella, "online_challenge_activity".Eseguito,
"online_challenge_activity".File, "online_challenge_activity".Gioca, "online_challenge_activity".Lancio,
"online_challenge_activity".Partecipa, "online_challenge_activity".Possiede, "online_challenge_activity".Quiz,
"online_challenge_activity".Risposta, "online_challenge_activity".Sfida, "online_challenge_activity".Squadra,
"online_challenge_activity".Task, "online_challenge_activity".Vota TO giocatore;

GRANT INSERT ON "online_challenge_activity".File, "online_challenge_activity".Giocatore, "online_challenge_activity".Partecipa,
"online_challenge_activity".Squadra, "online_challenge_activity".Vota TO giocatore;

GRANT UPDATE ON "online_challenge_activity".Gioca, "online_challenge_activity".Giocatore, "online_challenge_activity".Partecipa,
"online_challenge_activity".Squadra TO giocatore;

GRANT DELETE ON "online_challenge_activity".Gioca, "online_challenge_activity".Giocatore, "online_challenge_activity".Squadra TO giocatore;



GRANT SELECT ON ALL TABLES IN SCHEMA "online_challenge_activity" 
TO gameadmin WITH GRANT OPTION; 

GRANT UPDATE ON "online_challenge_activity".Admin, "online_challenge_activity".File, "online_challenge_activity".Sfida,
"online_challenge_activity".Task, "online_challenge_activity".Vota TO gameadmin WITH GRANT OPTION; 

GRANT DELETE ON "online_challenge_activity".Partecipa, "online_challenge_activity".Sfida, "online_challenge_activity".Vota 
TO gameadmin WITH GRANT OPTION;

GRANT INSERT ON "online_challenge_activity".Sfida TO gameadmin WITH GRANT OPTION; 



GRANT ALL ON ALL TABLES IN SCHEMA "online_challenge_activity"
TO gamecreator;


--Creazione della gerarchia:

GRANT gamecreator TO gameadmin;
GRANT giocatore TO gamecreator;
GRANT utente TO giocatore;



