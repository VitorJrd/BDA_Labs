-- Exercice 2 TP4

-- Schéma de la base de données
SET SERVEROUTPUT ON;

CREATE TABLE emp (
    matr NUMBER(10) NOT NULL,
    nom VARCHAR2(50) NOT NULL,
    sal NUMBER(7,2),
    adresse VARCHAR2(96),
    dep NUMBER(10) NOT NULL,
    CONSTRAINT emp_pk PRIMARY KEY (matr)
);

-- Insérer quelques données
INSERT INTO emp VALUES (1, 'Alice', 2000, 'Paris', 92000);
INSERT INTO emp VALUES (2, 'Bob', 2500, 'Lyon', 75000);
INSERT INTO emp VALUES (3, 'Charlie', 3000, 'Marseille', 92000);

COMMIT;

-- Test
SELECT * FROM emp;

-- 1
SET SERVEROUTPUT ON;

DECLARE
    v_employe emp%ROWTYPE;
BEGIN
    v_employe.matr := 4;
    v_employe.nom := 'Youcef';
    v_employe.sal := 2500;
    v_employe.adresse := 'avenue de la Republique';
    v_employe.dep := 92002;

    INSERT INTO emp VALUES v_employe;

    DBMS_OUTPUT.PUT_LINE('Employe insere.');
END;
/

-- 2
SET SERVEROUTPUT ON;

DECLARE
    v_nb_lignes NUMBER;
BEGIN
    DELETE FROM emp WHERE dep = 10;
    v_nb_lignes := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE('v_nb_lignes : ' || v_nb_lignes);
END;
/

-- 3
SET SERVEROUTPUT ON;

DECLARE
    v_salaire emp.sal%TYPE;
    v_total emp.sal%TYPE := 0;

    CURSOR c_salaires IS
        SELECT sal
        FROM emp;
BEGIN
    OPEN c_salaires;

    LOOP
        FETCH c_salaires INTO v_salaire;
        EXIT WHEN c_salaires%NOTFOUND;

        IF v_salaire IS NOT NULL THEN
            v_total := v_total + v_salaire;
        END IF;
    END LOOP;

    CLOSE c_salaires;

    DBMS_OUTPUT.PUT_LINE('Total : ' || v_total);
END;
/

-- 4
SET SERVEROUTPUT ON;

DECLARE
    v_salaire emp.sal%TYPE;
    v_total emp.sal%TYPE := 0;
    v_count NUMBER := 0;
    v_moyenne NUMBER(10,2);

    CURSOR c_salaires IS
        SELECT sal
        FROM emp;
BEGIN
    OPEN c_salaires;

    LOOP
        FETCH c_salaires INTO v_salaire;
        EXIT WHEN c_salaires%NOTFOUND;

        IF v_salaire IS NOT NULL THEN
            v_total := v_total + v_salaire;
            v_count := v_count + 1;
        END IF;
    END LOOP;

    CLOSE c_salaires;

    IF v_count > 0 THEN
        v_moyenne := v_total / v_count;
        DBMS_OUTPUT.PUT_LINE('Moyenne : ' || v_moyenne);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Aucun salaire trouve.');
    END IF;
END;
/

-- 5
SET SERVEROUTPUT ON;

DECLARE
    v_total emp.sal%TYPE := 0;
    v_count NUMBER := 0;
    v_moyenne NUMBER(10,2);
BEGIN
    FOR v_employe IN (SELECT sal FROM emp) LOOP
        IF v_employe.sal IS NOT NULL THEN
            v_total := v_total + v_employe.sal;
            v_count := v_count + 1;
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Total : ' || v_total);

    IF v_count > 0 THEN
        v_moyenne := v_total / v_count;
        DBMS_OUTPUT.PUT_LINE('Moyenne : ' || v_moyenne);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Aucun salaire trouve.');
    END IF;
END;
/

-- 6

SET SERVEROUTPUT ON;

DECLARE
    CURSOR c(p_dep emp.dep%TYPE) IS
        SELECT dep, nom
        FROM emp
        WHERE dep = p_dep;
BEGIN
    FOR v_employe IN c(92000) LOOP
        DBMS_OUTPUT.PUT_LINE('Dep 92000 : ' || v_employe.nom);
    END LOOP;

    FOR v_employe IN c(75000) LOOP
        DBMS_OUTPUT.PUT_LINE('Dep 75000 : ' || v_employe.nom);
    END LOOP;
END;
/
