-- Exercice 3 TP4

-- Créer la table client
SET SERVEROUTPUT ON;

CREATE TABLE client (
    idClient NUMBER(10) NOT NULL,
    nomClient VARCHAR2(50) NOT NULL,
    prenomClient VARCHAR2(50) NOT NULL,
    codePostalClient VARCHAR2(96),
    ageClient NUMBER(4),
    CONSTRAINT client_pk PRIMARY KEY (idClient)
);

-- Spécification du package
SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE packageClient IS

    PROCEDURE addClient(
        p_idClient client.idClient%TYPE,
        p_nomClient client.nomClient%TYPE,
        p_prenomClient client.prenomClient%TYPE,
        p_codePostalClient client.codePostalClient%TYPE,
        p_ageClient client.ageClient%TYPE
    );

    PROCEDURE addClient(
        p_idClient client.idClient%TYPE,
        p_nomClient client.nomClient%TYPE,
        p_prenomClient client.prenomClient%TYPE,
        p_codePostalClient client.codePostalClient%TYPE
    );

    FUNCTION getAgeAvg RETURN NUMBER;

END packageClient;
/

-- Implémentation package et lever exceptions
SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE BODY packageClient IS

    PROCEDURE addClient(
        p_idClient client.idClient%TYPE,
        p_nomClient client.nomClient%TYPE,
        p_prenomClient client.prenomClient%TYPE,
        p_codePostalClient client.codePostalClient%TYPE,
        p_ageClient client.ageClient%TYPE
    ) IS
    BEGIN
        IF p_ageClient IS NOT NULL AND p_ageClient < 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Age invalide : age negatif interdit');
        END IF;

        INSERT INTO client(idClient, nomClient, prenomClient, codePostalClient, ageClient)
        VALUES (p_idClient, p_nomClient, p_prenomClient, p_codePostalClient, p_ageClient);

        DBMS_OUTPUT.PUT_LINE('Client ajoute avec age.');
    
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : idClient deja existant.');
        WHEN VALUE_ERROR THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : valeur incorrecte.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erreur Oracle : ' || SQLERRM);
    END addClient;


    PROCEDURE addClient(
        p_idClient client.idClient%TYPE,
        p_nomClient client.nomClient%TYPE,
        p_prenomClient client.prenomClient%TYPE,
        p_codePostalClient client.codePostalClient%TYPE
    ) IS
    BEGIN
        INSERT INTO client(idClient, nomClient, prenomClient, codePostalClient, ageClient)
        VALUES (p_idClient, p_nomClient, p_prenomClient, p_codePostalClient, NULL);

        DBMS_OUTPUT.PUT_LINE('Client ajoute sans age.');

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : idClient deja existant.');
        WHEN VALUE_ERROR THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : valeur incorrecte.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erreur Oracle : ' || SQLERRM);
    END addClient;


    FUNCTION getAgeAvg RETURN NUMBER IS
        v_avg NUMBER;
    BEGIN
        SELECT AVG(ageClient) INTO v_avg
        FROM client
        WHERE ageClient IS NOT NULL;

        IF v_avg IS NULL THEN
            RAISE NO_DATA_FOUND;
        END IF;

        RETURN v_avg;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Aucun age disponible.');
            RETURN NULL;
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : plusieurs lignes inattendues.');
            RETURN NULL;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erreur Oracle : ' || SQLERRM);
            RETURN NULL;
    END getAgeAvg;

END packageClient;
/

-- Tests
BEGIN
    packageClient.addClient(1, 'Dupont', 'Jean', '75000', 25);
    packageClient.addClient(2, 'Martin', 'Alice', '92000');
    packageClient.addClient(1, 'Durand', 'Paul', '33000', 30);
    packageClient.addClient(3, 'Petit', 'Nina', '69000', -5);
END;
/

SELECT * FROM client;

VARIABLE v_age_moyen NUMBER;
EXECUTE :v_age_moyen := packageClient.getAgeAvg;
PRINT v_age_moyen;
