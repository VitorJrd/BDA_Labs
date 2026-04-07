-- Exercice 1 TP4

-- 1
SET SERVEROUTPUT ON;

ACCEPT a PROMPT 'Saisir le premier entier : '
ACCEPT b PROMPT 'Saisir le deuxieme entier : '

DECLARE
    v_a NUMBER := &a;
    v_b NUMBER := &b;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Somme = ' || (v_a + v_b));
END;
/

-- 2
SET SERVEROUTPUT ON;

ACCEPT n PROMPT 'Saisir un entier : '

DECLARE
    v_n NUMBER := &n;
BEGIN
    FOR i IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE(v_n || ' x ' || i || ' = ' || (v_n * i));
    END LOOP;
END;
/


-- 3
SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION puissance_recursive(x NUMBER, n NUMBER)
RETURN NUMBER
IS
BEGIN
    IF n = 0 THEN
        RETURN 1;
    ELSE
        RETURN x * puissance_recursive(x, n - 1);
    END IF;
END;
/

-- Test Puissance Recursive
ACCEPT x PROMPT 'Saisir x : '
ACCEPT n PROMPT 'Saisir n : '

DECLARE
    v_x NUMBER := &x;
    v_n NUMBER := &n;
    v_resultat NUMBER;
BEGIN
    v_resultat := puissance_recursive(v_x, v_n);
    DBMS_OUTPUT.PUT_LINE(v_x || '^' || v_n || ' = ' || v_resultat);
END;
/

-- Tables nécéssaires
SET SERVEROUTPUT ON;

CREATE TABLE resultatFactoriel (
    n NUMBER(10),
    factorielle NUMBER(38)
);

CREATE TABLE resultatsFactoriels (
    n NUMBER(10),
    factorielle NUMBER(38)
);

-- 4
SET SERVEROUTPUT ON;

ACCEPT n PROMPT 'Saisir un entier strictement positif : '

DECLARE
    v_n NUMBER := &n;
    v_fact NUMBER(38) := 1;
BEGIN
    IF v_n <= 0 THEN
        DBMS_OUTPUT.PUT_LINE('Erreur : le nombre doit etre strictement positif.');
    ELSE
        FOR i IN 1..v_n LOOP
            v_fact := v_fact * i;
        END LOOP;

        INSERT INTO resultatFactoriel VALUES (v_n, v_fact);

        DBMS_OUTPUT.PUT_LINE('Factorielle de ' || v_n || ' = ' || v_fact);
    END IF;
END;
/

-- Test
SELECT * FROM resultatFactoriel;


-- 5
SET SERVEROUTPUT ON;

DECLARE
    v_fact NUMBER(38) := 1;
BEGIN
    DELETE FROM resultatsFactoriels;

    FOR i IN 1..20 LOOP
        v_fact := v_fact * i;
        INSERT INTO resultatsFactoriels VALUES (i, v_fact);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Les factorielles de 1 a 20 ont ete inserees.');
END;
/

-- Test
SELECT * FROM resultatsFactoriels;
