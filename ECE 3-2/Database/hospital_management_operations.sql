-- Operation 1: Add a column in the PATIENTS table
-- Question: Add a new column to store patient's contact number
ALTER TABLE PATIENTS ADD (CONTACT_NUMBER VARCHAR2(15));

-- Operation 2: Modify a column
-- Question: Modify the AGE column to store a larger value (increase its size)
ALTER TABLE PATIENTS MODIFY AGE NUMBER(3);

-- Operation 3: Rename a column
-- Question: Rename the "NAME" column to "FULL_NAME" in the PATIENTS table
ALTER TABLE PATIENTS RENAME COLUMN NAME TO FULL_NAME;

-- Operation 4: Delete a column
-- Question: Remove the "CONTACT_NUMBER" column from the PATIENTS table
ALTER TABLE PATIENTS DROP COLUMN CONTACT_NUMBER;

-- Operation 5: Insert a row
-- Question: Insert a new patient into the PATIENTS table
INSERT INTO PATIENTS (PATIENT_ID, FULL_NAME, AGE, GENDER, DEPARTMENT)
VALUES (7, 'Robert Adams', 28, 'M', 'CARDIOLOGY');

-- Operation 6: Update a row value
-- Question: Update the age of patient with ID 1 to 31
UPDATE PATIENTS SET AGE = 31 WHERE PATIENT_ID = 1;

-- Operation 7: Delete a row
-- Question: Delete the patient record where the patient ID is 7
DELETE FROM PATIENTS WHERE PATIENT_ID = 7;

-- Operation 8: Find the patient who is prescribed the most medications
-- Question: Find which patient has been prescribed the most medications
SELECT * 
FROM (
    SELECT P.PATIENT_ID, P.FULL_NAME, COUNT(PT.MEDICATION_ID) AS MEDICATION_COUNT
    FROM PATIENTS P
    JOIN PATIENT_TREATMENTS PT ON P.PATIENT_ID = PT.PATIENT_ID
    GROUP BY P.PATIENT_ID, P.FULL_NAME
    ORDER BY MEDICATION_COUNT DESC
)
WHERE ROWNUM = 1;

-- Operation 9: Find the top 5 patients who are prescribed the most medications
-- Question: Find the top 5 patients who have been prescribed the most medications
SELECT * 
FROM (
    SELECT P.PATIENT_ID, P.FULL_NAME, COUNT(PT.MEDICATION_ID) AS MEDICATION_COUNT
    FROM PATIENTS P
    JOIN PATIENT_TREATMENTS PT ON P.PATIENT_ID = PT.PATIENT_ID
    GROUP BY P.PATIENT_ID, P.FULL_NAME
    ORDER BY MEDICATION_COUNT DESC
)
WHERE ROWNUM <= 5;

-- Operation 10: Count the number of medications prescribed to each patient
-- Question: Count the number of medications prescribed to each patient
SELECT PATIENT_ID, COUNT(MEDICATION_ID) AS MEDICATION_COUNT
FROM PATIENT_TREATMENTS
GROUP BY PATIENT_ID;

-- Operation 11: Count how many medications each patient has been prescribed after a specific date
-- Question: Count the number of medications prescribed to each patient after '2024-11-10'
SELECT PATIENT_ID, COUNT(MEDICATION_ID) AS MEDICATION_COUNT
FROM PATIENT_TREATMENTS
WHERE DATE_ASSIGNED > TO_DATE('2024-11-10', 'YYYY-MM-DD')
GROUP BY PATIENT_ID;

-- Operation 12: Count the number of medications prescribed to each patient where the PATIENT_ID is less than 6
-- Question: Find how many medications have been prescribed to each patient with ID less than 6
SELECT PATIENT_ID, COUNT(MEDICATION_ID) AS MEDICATION_COUNT
FROM PATIENT_TREATMENTS
GROUP BY PATIENT_ID
HAVING PATIENT_ID < 6;

-- Operation 13: Only include patients who have been prescribed more than 2 medications
-- Question: Find patients who have been prescribed more than 2 medications
SELECT PATIENT_ID, COUNT(MEDICATION_ID) AS MEDICATION_COUNT
FROM PATIENT_TREATMENTS
GROUP BY PATIENT_ID
HAVING COUNT(MEDICATION_ID) > 2;

-- Operation 14: Find patients who have been prescribed medications in the past
-- Question: Find the patients who have been prescribed medications before today
SELECT PATIENT_ID, COUNT(MEDICATION_ID) AS MEDICATION_COUNT
FROM PATIENT_TREATMENTS
WHERE DATE_ASSIGNED < SYSDATE
GROUP BY PATIENT_ID;

-- Operation 15: Find patients who have been prescribed fewer than 5 medications
-- Question: Find patients who have been prescribed fewer than 5 medications
SELECT PATIENT_ID
FROM PATIENT_TREATMENTS
GROUP BY PATIENT_ID
HAVING COUNT(MEDICATION_ID) < 5;

-- Operation 16: Find patients whose name is 'John Doe' or 'Emily Clark'
-- Question: Find the patients whose names are 'John Doe' or 'Emily Clark'
SELECT PATIENT_ID, FULL_NAME
FROM PATIENTS
WHERE FULL_NAME IN ('John Doe', 'Emily Clark');

-- Operation 17: Find patients from the 'CARDIOLOGY' department
-- Question: Find all patients from the 'CARDIOLOGY' department
SELECT PATIENT_ID, FULL_NAME
FROM PATIENTS
WHERE DEPARTMENT = 'CARDIOLOGY';

-- Operation 18: Create a new table for 'CARDIOLOGY' patients and insert data into it
-- Question: Create a table for 'CARDIOLOGY' patients and insert data
CREATE TABLE CARDIOLOGY_PATIENTS (
    PATIENT_ID NUMBER(2),
    FULL_NAME VARCHAR2(50)
);

INSERT INTO CARDIOLOGY_PATIENTS (PATIENT_ID, FULL_NAME)
SELECT PATIENT_ID, FULL_NAME
FROM PATIENTS
WHERE DEPARTMENT = 'CARDIOLOGY';

-- Operation 19: Fetch patients and doctors who have prescribed medications
-- Question: Find both patients and doctors who have prescribed medications
SELECT P.PATIENT_ID, P.FULL_NAME
FROM PATIENTS P
WHERE P.PATIENT_ID IN (
    SELECT PT.PATIENT_ID
    FROM PATIENT_TREATMENTS PT
)
UNION ALL
SELECT D.DOCTOR_ID, D.NAME
FROM DOCTORS D
WHERE D.DOCTOR_ID IN (
    SELECT DP.DOCTOR_ID
    FROM DOCTOR_PRESCRIPTIONS DP
);

-- Operation 20: Fetch patients and doctors who have prescribed medications, with changed column names
-- Question: Fetch patients and doctors who have prescribed medications, using alias for columns
SELECT P.PATIENT_ID AS ID, P.FULL_NAME AS NAME
FROM PATIENTS P
WHERE P.PATIENT_ID IN (
    SELECT PT.PATIENT_ID
    FROM PATIENT_TREATMENTS PT
)
UNION ALL
SELECT D.DOCTOR_ID AS ID, D.NAME AS NAME
FROM DOCTORS D
WHERE D.DOCTOR_ID IN (
    SELECT DP.DOCTOR_ID
    FROM DOCTOR_PRESCRIPTIONS DP
);

-- Operation 21: Find doctors and patients in the 'CARDIOLOGY' department
-- Question: Find patients and doctors from the 'CARDIOLOGY' department
SELECT PATIENT_ID AS ID, FULL_NAME AS NAME
FROM PATIENTS
WHERE DEPARTMENT = 'CARDIOLOGY'
UNION ALL
SELECT DOCTOR_ID AS ID, NAME AS NAME
FROM DOCTORS
WHERE SPECIALTY_ID IN (
    SELECT SPECIALTY_ID
    FROM SPECIALTIES
    WHERE NAME = 'Cardiology'
);

-- Operation 22: Find patients who have been prescribed medications
-- Question: Find patients who have been prescribed medications
SELECT P.PATIENT_ID, P.FULL_NAME, PT.MEDICATION_ID
FROM PATIENT_TREATMENTS PT
JOIN PATIENTS P ON P.PATIENT_ID = PT.PATIENT_ID;

-- Operation 23: Find patients who have been prescribed medications using JOIN
-- Question: Find patients and prescribed medications using JOIN
SELECT P.PATIENT_ID, P.FULL_NAME, PT.MEDICATION_ID
FROM PATIENT_TREATMENTS PT
JOIN PATIENTS P ON P.PATIENT_ID = PT.PATIENT_ID;

-- Operation 24: Find doctors who have prescribed medications
-- Question: Find doctors who have prescribed medications using JOIN
SELECT D.DOCTOR_ID, D.NAME, DP.MEDICATION_ID
FROM DOCTOR_PRESCRIPTIONS DP
JOIN DOCTORS D ON D.DOCTOR_ID = DP.DOCTOR_ID;

-- Operation 25: Apply NATURAL JOIN to fetch doctor and prescription information
-- Question: Apply NATURAL JOIN between doctors and prescriptions
SELECT NAME, DOCTOR_ID
FROM DOCTORS D NATURAL JOIN DOCTOR_PRESCRIPTIONS DP;

-- Operation 26: Apply multiple joins to find medications prescribed to patients by doctors
-- Question: Apply multiple joins to find the prescribed medications for patients by doctors
SELECT P.PATIENT_ID, P.FULL_NAME, PT.MEDICATION_ID, D.NAME AS DOCTOR_NAME
FROM PATIENTS P
JOIN PATIENT_TREATMENTS PT ON P.PATIENT_ID = PT.PATIENT_ID
JOIN DOCTORS D ON D.DOCTOR_ID = PT.MEDICATION_ID;

-- Operation 28: Apply inner join to find doctors who have prescribed medications
-- Question: Apply INNER JOIN to find doctors who have prescribed medications
SELECT D.NAME, DP.DOCTOR_ID
FROM DOCTORS D
INNER JOIN DOCTOR_PRESCRIPTIONS DP ON D.DOCTOR_ID = DP.DOCTOR_ID;

-- Operation 29: Apply LEFT OUTER JOIN to find patients who have been prescribed medications
-- Question: Apply LEFT OUTER JOIN between PATIENTS and PATIENT_TREATMENTS
SELECT P.PATIENT_ID, P.FULL_NAME, PT.MEDICATION_ID
FROM PATIENTS P
LEFT OUTER JOIN PATIENT_TREATMENTS PT ON P.PATIENT_ID = PT.PATIENT_ID;

-- Operation 30: Apply RIGHT OUTER JOIN to find all medications prescribed
-- Question: Apply RIGHT OUTER JOIN between PATIENTS and PATIENT_TREATMENTS
SELECT P.PATIENT_ID, P.FULL_NAME, PT.MEDICATION_ID
FROM PATIENTS P
RIGHT OUTER JOIN PATIENT_TREATMENTS PT ON P.PATIENT_ID = PT.PATIENT_ID;

-- Operation 31: Apply CROSS JOIN to find all combinations of patients and medications
-- Question: Apply CROSS JOIN between PATIENTS and MEDICATIONS
SELECT DISTINCT P.PATIENT_ID, P.FULL_NAME, M.MEDICATION_NAME
FROM PATIENTS P
CROSS JOIN MEDICATIONS M;

-- Operation 32: Apply INNER JOIN between PATIENTS, MEDICATIONS, and PATIENT_TREATMENTS
-- Question: Apply INNER JOIN to find which patients are prescribed which medications
SELECT P.PATIENT_ID, P.FULL_NAME, PT.MEDICATION_ID, M.MEDICATION_NAME
FROM PATIENTS P
INNER JOIN PATIENT_TREATMENTS PT ON P.PATIENT_ID = PT.PATIENT_ID
INNER JOIN MEDICATIONS M ON PT.MEDICATION_ID = M.MEDICATION_ID
ORDER BY P.PATIENT_ID ASC;

-- Operation 33: Self-Join to Find Patients Who Were Assigned the Same Medication

-- Question: How to find patients who are assigned to the same medication?

-- Answer:
SELECT P1.NAME AS PATIENT_NAME, P2.NAME AS OTHER_PATIENT_NAME
FROM PATIENTS P1
JOIN PATIENTS P2 ON P1.PATIENT_ID != P2.PATIENT_ID
JOIN PATIENT_TREATMENTS PT1 ON P1.PATIENT_ID = PT1.PATIENT_ID
JOIN PATIENT_TREATMENTS PT2 ON P2.PATIENT_ID = PT2.PATIENT_ID
WHERE PT1.MEDICATION_ID = PT2.MEDICATION_ID;

--

-- Operation 34: Retrieve All Patients Who Visited a Specific Doctor

-- PL/SQL Block: Retrieve all patients who visited a specific doctor

-- Question: How to retrieve all patients who have visited a specific doctor?

-- Answer:
SET SERVEROUTPUT ON;

DECLARE
    doctor_name VARCHAR2(50) := 'Dr. Alice';
    doctor_id NUMBER;
BEGIN
    -- Retrieve DOCTOR_ID for the specified doctor
    SELECT DOCTOR_ID
    INTO doctor_id
    FROM DOCTORS
    WHERE NAME = doctor_name;

    -- Display patients who visited the specified doctor
    DBMS_OUTPUT.PUT_LINE('Patients who visited "' || doctor_name || '":');
    FOR rec IN (
        SELECT DISTINCT P.NAME, P.AGE, P.GENDER
        FROM PATIENTS P
        JOIN PATIENT_TREATMENTS PT ON P.PATIENT_ID = PT.PATIENT_ID
        JOIN DOCTOR_PRESCRIPTIONS DP ON PT.MEDICATION_ID = DP.MEDICATION_ID
        WHERE DP.DOCTOR_ID = doctor_id
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Name: ' || rec.NAME || ', Age: ' || rec.AGE || ', Gender: ' || rec.GENDER);
    END LOOP;
END;
/

--

-- Operation 35: Show the First 5 Doctors in the Hospital

-- PL/SQL Block: Show the first 5 doctors in the hospital

-- Question: How to show the first 5 doctors in the hospital?

-- Answer:
SET SERVEROUTPUT ON;

DECLARE
    CURSOR doctor_cursor IS
        SELECT DOCTOR_ID, NAME
        FROM DOCTORS
        WHERE ROWNUM <= 5; -- Limit to the first 5 doctors

    doctor_record doctor_cursor%ROWTYPE; -- Variable to hold cursor data
BEGIN
    DBMS_OUTPUT.PUT_LINE('First 5 Doctors in the Hospital:');
    OPEN doctor_cursor;
    LOOP
        FETCH doctor_cursor INTO doctor_record; -- Fetch each row into doctor_record
        EXIT WHEN doctor_cursor%NOTFOUND; -- Exit when no more rows are found

        -- Display the doctor details
        DBMS_OUTPUT.PUT_LINE('Doctor ID: ' || doctor_record.DOCTOR_ID || ', Doctor Name: ' || doctor_record.NAME);
    END LOOP;
    CLOSE doctor_cursor; -- Close the cursor
END;
/

--

-- Operation 36: Identify Patients Who Have Been Prescribed the Most Medications

-- PL/SQL Block: Identify the patients who have been prescribed the most medications

-- Question: How to identify the patients who have been prescribed the most medications?

-- Answer:
SET SERVEROUTPUT ON;

DECLARE
    max_medications NUMBER;
    CURSOR max_patients_cur IS
        SELECT P.NAME, P.AGE, P.GENDER, COUNT(M.MEDICATION_ID) AS medication_count
        FROM PATIENTS P
        JOIN PATIENT_TREATMENTS PT ON P.PATIENT_ID = PT.PATIENT_ID
        JOIN MEDICATIONS M ON PT.MEDICATION_ID = M.MEDICATION_ID
        GROUP BY P.NAME, P.AGE, P.GENDER
        HAVING COUNT(M.MEDICATION_ID) = (
            SELECT MAX(medication_count)
            FROM (
                SELECT PATIENT_ID, COUNT(MEDICATION_ID) AS medication_count
                FROM PATIENT_TREATMENTS
                GROUP BY PATIENT_ID
            )
        );
BEGIN
    -- Display patients who have been prescribed the most medications
    DBMS_OUTPUT.PUT_LINE('Patients prescribed the most medications:');
    FOR patient_rec IN max_patients_cur LOOP
        DBMS_OUTPUT.PUT_LINE('Name: ' || patient_rec.NAME ||
                             ', Age: ' || patient_rec.AGE ||
                             ', Gender: ' || patient_rec.GENDER ||
                             ', Total Medications: ' || patient_rec.medication_count);
    END LOOP;
END;
/

--

-- Operation 37: Show Total Medications Prescribed by Each Doctor

-- PL/SQL Block: Show total medications prescribed by each doctor

-- Question: How to show the total medications prescribed by each doctor?

-- Answer:
SET SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Total medications prescribed by each doctor:');
    FOR rec IN (SELECT D.NAME AS DOCTOR_NAME, COUNT(DP.MEDICATION_ID) AS TOTAL_PRESCRIPTIONS
                FROM DOCTORS D
                JOIN DOCTOR_PRESCRIPTIONS DP ON D.DOCTOR_ID = DP.DOCTOR_ID
                GROUP BY D.NAME)
    LOOP
        DBMS_OUTPUT.PUT_LINE('Doctor: ' || rec.DOCTOR_NAME || ', Medications Prescribed: ' || rec.TOTAL_PRESCRIPTIONS);
    END LOOP;
END;
/

--

-- Operation 38: Show Total Medications Prescribed to Patients by Department

-- PL/SQL Block: Show total medications prescribed to patients by department

-- Question: How to show total medications prescribed to patients by department?

-- Answer:
SET SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Total medications prescribed per department:');
    FOR rec IN (
        SELECT P.DEPARTMENT, COUNT(M.MEDICATION_ID) AS TOTAL_PRESCRIPTIONS
        FROM PATIENTS P
        JOIN PATIENT_TREATMENTS PT ON P.PATIENT_ID = PT.PATIENT_ID
        JOIN MEDICATIONS M ON PT.MEDICATION_ID = M.MEDICATION_ID
        GROUP BY P.DEPARTMENT
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Department: ' || rec.DEPARTMENT || ', Total Prescribed: ' || rec.TOTAL_PRESCRIPTIONS);
    END LOOP;
END;
/

--

-- Operation 39: Show Overlapping Medications Prescribed by Multiple Doctors

-- PL/SQL Block: Show overlapping medications prescribed by multiple doctors

-- Question: How to show overlapping medications prescribed by multiple doctors?

-- Answer:
SET SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Medications prescribed by multiple doctors:');
    FOR rec IN (
        SELECT DISTINCT M.NAME AS MEDICATION_NAME
        FROM MEDICATIONS M
        WHERE M.MEDICATION_ID IN (
            SELECT MEDICATION_ID FROM DOCTOR_PRESCRIPTIONS
            INTERSECT
            SELECT MEDICATION_ID FROM DOCTOR_PRESCRIPTIONS
        )
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Medication: ' || rec.MEDICATION_NAME);
    END LOOP;
END;
/

--

-- Operation 40: Show All Patients and Their Prescribed Medications

-- PL/SQL Block: Show all patients and their prescribed medications

-- Question: How to show all patients and their prescribed medications?

-- Answer:
SET SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Patients and their prescribed medications:');
    FOR rec IN (
        SELECT P.NAME AS PATIENT_NAME, M.NAME AS MEDICATION_NAME
        FROM PATIENTS P
        JOIN PATIENT_TREATMENTS PT ON P.PATIENT_ID = PT.PATIENT_ID
        JOIN MEDICATIONS M ON PT.MEDICATION_ID = M.MEDICATION_ID
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Patient: ' || rec.PATIENT_NAME || ', Medication: ' || rec.MEDICATION_NAME);
    END LOOP;
END;
/

--

-- Operation 41: Check if a Medication Is Prescribed to a Patient

-- PL/SQL Block: Check if a medication is prescribed to a specific patient

-- Question: How to check if a medication is prescribed to a specific patient?

-- Answer:
DECLARE
    medication_id NUMBER := 1; -- Example medication ID
    patient_id NUMBER := 2;    -- Example patient ID
    medication_prescribed NUMBER;
BEGIN
    -- Check if the medication exists for the specified patient
    SELECT COUNT(*)
    INTO medication_prescribed
    FROM PATIENT_TREATMENTS
    WHERE PATIENT_ID = patient_id AND MEDICATION_ID = medication_id;

    IF medication_prescribed > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Medication prescribed to Patient ID ' || patient_id || '.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Medication not prescribed to Patient ID ' || patient_id || '.');
    END IF;
END;
/

--

-- Operation 42: Find Which Medications Were Taken by a Particular Patient

-- PL/SQL Block: Find which medications were taken by a particular patient

-- Question: How to find which medications were taken by a particular patient?

-- Answer:
SET SERVEROUTPUT ON;

DECLARE
    patient_id NUMBER := 2; -- Example patient ID
BEGIN
    DBMS_OUTPUT.PUT_LINE('Medications prescribed to Patient ID: ' || patient_id);
     
    FOR medication_rec IN (
        SELECT M.NAME AS MEDICATION_NAME
        FROM MEDICATIONS M
        JOIN PATIENT_TREATMENTS PT ON M.MEDICATION_ID = PT.MEDICATION_ID
        WHERE PT.PATIENT_ID = patient_id
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Medication: ' || medication_rec.MEDICATION_NAME);
    END LOOP;
END;
/

