-- TP5: transactions et contrôle de concurrence
-- Exercice 1


-- 1 (session S1)

SET AUTOCOMMIT OFF;

CREATE TABLE transaction (
    idTransaction   VARCHAR2(44),
    valTransaction  NUMBER(10)
);


-- 2 (session S2)

SET AUTOCOMMIT OFF;

INSERT INTO transaction VALUES ('T1', 100);
INSERT INTO transaction VALUES ('T2', 200);
INSERT INTO transaction VALUES ('T3', 300);

UPDATE transaction SET valTransaction = 250 WHERE idTransaction = 'T2';
DELETE FROM transaction WHERE idTransaction = 'T1';

SELECT * FROM transaction;

ROLLBACK;

SELECT * FROM transaction;


-- 3 (session S2 puis S1)

-- SESSION S2
INSERT INTO transaction VALUES ('T4', 400);
INSERT INTO transaction VALUES ('T5', 500);

SELECT * FROM transaction;

QUIT;

-- SESSION S1
SELECT * FROM transaction;


-- 4 (session S1)

INSERT INTO transaction VALUES ('T6', 600);
INSERT INTO transaction VALUES ('T7', 700);

SELECT * FROM transaction;

-- fermer brutalement SQL*Plus ici puis se reconnecter

SET AUTOCOMMIT OFF;

SELECT * FROM transaction;


-- 5 (nouvelle session)

SET AUTOCOMMIT OFF;

INSERT INTO transaction VALUES ('T8', 800);

ALTER TABLE transaction ADD val2Transaction NUMBER(10);

ROLLBACK;

DESC transaction;
SELECT * FROM transaction;


-- 6 Conclusion

-- Une session est une connexion entre un utilisateur et le SGBD
-- Une transaction est un ensemble d’opérations exécutées comme une unité logique
-- COMMIT valide définitivement les modifications
-- ROLLBACK annule les modifications non validées
-- Si une session se termine sans COMMIT, les modifications sont perdues
-- Une commande DDL comme ALTER TABLE provoque un COMMIT implicite
