SELECT * FROM healthcare_project.healthcare_data;
SELECT COUNT(*) FROM healthcare_data;
SELECT * FROM healthcare_data LIMIT 5;

#Convert admission_date
UPDATE healthcare_data
SET admission_date = STR_TO_DATE(admission_date, '%m/%d/%Y');

#Convert discharge_date
UPDATE healthcare_data
SET discharge_date = STR_TO_DATE(discharge_date, '%m/%d/%Y')
WHERE discharge_date IS NOT NULL;

#Change Data Type
ALTER TABLE healthcare_data
MODIFY admission_date DATE;

ALTER TABLE healthcare_data
MODIFY discharge_date DATE;

/*Create Length of Stay*/
#Add Column
ALTER TABLE healthcare_data
ADD length_of_stay INT;
#Calculate
UPDATE healthcare_data
SET length_of_stay = DATEDIFF(discharge_date, admission_date);

/*Create Age Groups*/
#Add Column
ALTER TABLE healthcare_data
ADD age_group VARCHAR(20);
#Populate
UPDATE healthcare_data
SET age_group = 
CASE 
    WHEN age < 18 THEN 'Child'
    WHEN age BETWEEN 18 AND 40 THEN 'Young Adult'
    WHEN age BETWEEN 41 AND 60 THEN 'Middle Age'
    ELSE 'Senior'
END;

/*Create Billing Category*/
#Add Column
ALTER TABLE healthcare_data
ADD billing_category VARCHAR(20);
#Populate
UPDATE healthcare_data
SET billing_category =
CASE 
    WHEN billing_amount < 20000 THEN 'Low'
    WHEN billing_amount BETWEEN 20000 AND 50000 THEN 'Medium'
    ELSE 'High'
END;

/*Create Stay Category*/
#Add Column
ALTER TABLE healthcare_data
ADD stay_type VARCHAR(20);
#Populate
UPDATE healthcare_data
SET stay_type =
CASE 
    WHEN length_of_stay <= 3 THEN 'Short Stay'
    WHEN length_of_stay <= 7 THEN 'Medium Stay'
    ELSE 'Long Stay'
END;

/*Extract Month for Trend Analysis*/
#Add Column
ALTER TABLE healthcare_data
ADD admission_month VARCHAR(10);
#Populate
UPDATE healthcare_data
SET admission_month = DATE_FORMAT(admission_date, '%Y-%m');

/*FINAL VALIDATION*/
SELECT * FROM healthcare_data LIMIT 10;
SELECT 
    COUNT(*) AS total_rows,
    AVG(length_of_stay) AS avg_stay,
    SUM(billing_amount) AS total_revenue
FROM healthcare_data;

/*OVERALL KPIs*/

#Total Patients
SELECT COUNT(*) AS total_patients
FROM healthcare_data;
#Total Revenue
SELECT SUM(billing_amount) AS total_revenue
FROM healthcare_data;
#Average Length of Stay
SELECT AVG(length_of_stay) AS avg_stay
FROM healthcare_data;
#Average Billing
SELECT AVG(billing_amount) AS avg_billing
FROM healthcare_data;

/*REVENUE ANALYSIS*/

#Revenue by Medical Condition
SELECT medical_condition,
       SUM(billing_amount) AS revenue
FROM healthcare_data
GROUP BY medical_condition
ORDER BY revenue DESC;
#Revenue by Hospital
SELECT hospital,
       SUM(billing_amount) AS revenue
FROM healthcare_data
GROUP BY hospital
ORDER BY revenue DESC;

/*PATIENT DISTRIBUTION*/

#Patients by Gender
SELECT gender,
       COUNT(*) AS patients
FROM healthcare_data
GROUP BY gender;
#Patients by Age Group
SELECT age_group,
       COUNT(*) AS patients
FROM healthcare_data
GROUP BY age_group;

/*TREND ANALYSIS*/

#Patients by Admission Type
SELECT admission_type,
       COUNT(*) AS patients
FROM healthcare_data
GROUP BY admission_type;
#Monthly Admissions & Revenue
SELECT admission_month,
       COUNT(*) AS patients,
       SUM(billing_amount) AS revenue
FROM healthcare_data
GROUP BY admission_month
ORDER BY admission_month;

/*OPERATIONAL ANALYSIS*/

#Length of Stay by Condition
SELECT medical_condition,
       AVG(length_of_stay) AS avg_stay
FROM healthcare_data
GROUP BY medical_condition
ORDER BY avg_stay DESC;

#Stay Type Distribution
SELECT stay_type,
       COUNT(*) AS patients
FROM healthcare_data
GROUP BY stay_type;

/*INSURANCE ANALYSIS*/

#Patients by Insurance Provider
SELECT insurance_provider,
       COUNT(*) AS patients
FROM healthcare_data
GROUP BY insurance_provider;

#Avg Billing by Insurance
SELECT insurance_provider,
       AVG(billing_amount) AS avg_bill
FROM healthcare_data
GROUP BY insurance_provider
ORDER BY avg_bill DESC;

/*HIGH VALUE PATIENTS*/

#Top 10 High Billing Patients
SELECT name,
       billing_amount
FROM healthcare_data
ORDER BY billing_amount DESC
LIMIT 10;

/*TEST RESULTS ANALYSIS*/

#Distribution of Test Results
SELECT test_results,
       COUNT(*) AS patients
FROM healthcare_data
GROUP BY test_results;

