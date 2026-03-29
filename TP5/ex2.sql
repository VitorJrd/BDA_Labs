-- TP5: transactions et contrôle de concurrence
-- Exercice 2

-- Création des tables

CREATE TABLE vol (
    idVol VARCHAR2(44),
    capaciteVol NUMBER(10),
    placesReserveesVol NUMBER(10)
);

CREATE TABLE client (
    idClient VARCHAR2(44),
    prenomClient VARCHAR2(11),
    placesReserveesClient NUMBER(10)
);

INSERT INTO vol VALUES ('V1', 10, 0);
INSERT INTO client VALUES ('C1', 'Alice', 0);
INSERT INTO client VALUES ('C2', 'Bob', 0);

COMMIT;

SELECT * FROM vol;
SELECT * FROM client;


-- Isolation des transactions

-- SESSION T1
-- Réservation sans COMMIT
UPDATE client SET placesReserveesClient = placesReserveesClient + 2 WHERE idClient = 'C1';
UPDATE vol SET placesReserveesVol = placesReserveesVol + 2 WHERE idVol = 'V1';

SELECT * FROM client;
SELECT * FROM vol;

-- SESSION T2
-- Vérifier la visibilité
SELECT * FROM client;
SELECT * FROM vol;

-- T2 ne voit pas les modifications de T1 car elles ne sont pas validées

-- ROLLBACK

-- SESSION T1
ROLLBACK;

SELECT * FROM client;
SELECT * FROM vol;

-- SESSION T2
SELECT * FROM client;
SELECT * FROM vol;


-- COMMIT


-- SESSION T1
UPDATE client SET placesReserveesClient = placesReserveesClient + 2 WHERE idClient = 'C1';
UPDATE vol SET placesReserveesVol = placesReserveesVol + 2 WHERE idVol = 'V1';

COMMIT;

-- SESSION T2
SELECT * FROM client;
SELECT * FROM vol;


-- Mise à jour perdue (READ COMMITTED)


-- Réinitialisation
UPDATE vol SET placesReserveesVol = 0 WHERE idVol = 'V1';
UPDATE client SET placesReserveesClient = 0 WHERE idClient = 'C1';
UPDATE client SET placesReserveesClient = 0 WHERE idClient = 'C2';

COMMIT;

-- SESSION T1 (lecture)
SELECT * FROM vol WHERE idVol = 'V1';
SELECT * FROM client WHERE idClient = 'C1';

-- SESSION T2 (lecture)
SELECT * FROM vol WHERE idVol = 'V1';
SELECT * FROM client WHERE idClient = 'C2';

-- SESSION T1 (update + commit)
UPDATE client SET placesReserveesClient = 2 WHERE idClient = 'C1';
UPDATE vol SET placesReserveesVol = 2 WHERE idVol = 'V1';

COMMIT;

-- SESSION T2 (update + commit)
UPDATE client SET placesReserveesClient = 3 WHERE idClient = 'C2';
UPDATE vol SET placesReserveesVol = 3 WHERE idVol = 'V1';

COMMIT;

-- Vérification
SELECT * FROM client;
SELECT * FROM vol;


-- Isolation SERIALIZABLE


-- Réinitialisation
UPDATE vol SET placesReserveesVol = 0 WHERE idVol = 'V1';
UPDATE client SET placesReserveesClient = 0 WHERE idClient = 'C1';
UPDATE client SET placesReserveesClient = 0 WHERE idClient = 'C2';

COMMIT;

-- SESSION T1
ALTER SESSION SET ISOLATION_LEVEL = SERIALIZABLE;

-- SESSION T2
ALTER SESSION SET ISOLATION_LEVEL = SERIALIZABLE;

-- Refaire les mêmes opérations; Oracle peut rejeter une transaction (ORA-08177) (cohérence en mode SERIALIZABLE)



-- READ COMMITTED: pas de lecture sale mais incohérences possibles
-- SERIALIZABLE: cohérence garantie mais rejet possible de transactions
-- Oracle ne correspond pas exactement à un verrouillage strict à deux phases. Il utilise un mécanisme basé sur la gestion des versions et le niveau d’isolation
