
# Show unique birth years from patients and order them by ascending.

SELECT distinct year(birth_date) as birth_date
FROM patients
order by birth_date

  
# Show unique first names from the patients table which only occurs once in the list.

SELECT first_name
FROM patients
group by first_name
HAVING COUNT(*) = 1


# Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.

SELECT patient_id, first_name
FROM patients
where first_name like 'S%' AND first_name LIKE '%S' and length (first_name) >= 6


# Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.

select patient_id, first_name, last_name
From patients p
join admissions a
    using(patient_id)
where diagnosis = 'Dementia'
  

# Display every patient's first_name.Order the list by the length of each name and then by alphbetically

select first_name
from patients
order by len(first_name), first_name

  
# Show the total amount of male patients and the total amount of female patients in the patients table.Display the two results in the same row.

SELECT
(SELECT count(*) FROM patients WHERE gender='M') AS male_count,
(SELECT count(*) FROM patients WHERE gender='F') AS female_count;


# Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. Show results ordered ascending by allergies then by first_name then by last_name.

select first_name, last_name, allergies
from patients
where allergies in ( 'Penicillin', 'Morphine')
order by allergies, first_name, last_name


# Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.

select patient_id, diagnosis
from admissions
group by patient_id, diagnosis
having count(*) > 1;

  

# Show the city and the total number of patients in the city. Order from most to least patients and then by city name ascending.

select city, count(patient_id) as total
from patients
group by city
order by total desc , city


# Show first name, last name and role of every person that is either patient or doctor. The roles are either "Patient" or "Doctor"

select first_name,last_name, "Patient" as role
from patients
union all
select first_name,last_name, "Doctor" as role
from doctors


# Show all allergies ordered by popularity. Remove NULL values from query.

select allergies, count(allergies) as num_allergies
from patients
where allergies is not null
group by allergies
order by num_allergies desc


# Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.

select first_name, last_name, birth_date
from patients
where birth_date like '197%'
order by birth_date

  
# Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.

select province_id, sum(height)
from patients
group by province_id
having sum(height) >= 7000

  
# Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'

select max(weight)-min(weight)
from patients
where last_name = 'Maroni'

  
# Show all columns for patient_id 542's most recent admission_date.

select *
from admissions
where patient_id = 542 and admission_date =
    (select max(admission_date)
    from admissions
    where patient_id = 542)

  
# For each doctor, display their id, full name, and the first and last admission date they attended.

SELECT d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS full_name,
    MIN(a.admission_date) AS first_admission_date,
    MAX(a.admission_date) AS last_admission_date
FROM doctors d
JOIN admissions a ON d.doctor_id = a.attending_doctor_id
GROUP BY d.doctor_id, full_name

  

# We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending order

select concat(upper(last_name),',', lower(first_name)) as full_name
from patients
order by first_name desc

  
# Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.

select day(admission_date), count(*)
from admissions
group by day(admission_date)
order by count(*) desc


# Show first_name, last_name, and the total number of admissions attended for each doctor. Every admission has been attended by a doctor.

select first_name, last_name, count(attending_doctor_id)
from doctors d
join admissions a
    on a.attending_doctor_id = d.doctor_id
group by first_name, last_name

  
# Display the total amount of patients for each province. Order by descending.

select province_name, count(patient_id) as num_patient
from patients p
join province_names pn
    using(province_id)
group by province_name
order by num_patient desc

  
# For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem.

select concat(p.first_name, ' ', p.last_name) as fullname_patient,
    a.diagnosis,
    concat(d.first_name, ' ', d.last_name)
from patients p
join admissions a
    using(patient_id)
join doctors d
    on d.doctor_id = a.attending_doctor_id

  
# Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria: 1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.     2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.

select patient_id, attending_doctor_id, diagnosis
from admissions
where (patient_id%2 != 0 and attending_doctor_id in (1,5,19))
or
(attending_doctor_id like '%2%' and length(patient_id) = 3)


# display the number of duplicate patients based on their first_name and last_name.

select first_name, last_name,count(*)
from patients
group by first_name, last_name
having count(*) > 1


# Display patient's full name, height in the units feet rounded to 1 decimal, weight in the unit pounds rounded to 0 decimals, birth_date, gender non abbreviated. Convert CM to feet by dividing by 30.48. Convert KG to pounds by multiplying by 2.205.

select concat(first_name, ' ', last_name) as full_name, 			round(height/30.48,1) as height , round(weight*2.205,0) as weight, birth_date,
    case when gender = 'M' then 'MALE'
    WHEN gender = 'F' THEN 'FEMALE'
    else 'unknown'
    end as gender
from patients

  
# Show the ProductName, CompanyName, CategoryName from the products, suppliers, and categories table

select p.product_name, s.company_name, c.category_name
from products p
join categories c
    using(category_id)
join suppliers s
    using(supplier_id)


# Show the category_name and the average product unit price for each category rounded to 2 decimal places.

select c.category_name, round(avg(p.unit_price),2) avg_price
from categories c
join products p
    using(category_id)
group by c.category_name

  
# Show the city, company_name, contact_name from the customers and suppliers table merged together. Create a column which contains 'customers' or 'suppliers' depending on the table it came from.

select city, company_name, contact_name, 'customers' as customers
from customers
union
select city, company_name, contact_name, 'suppliers' as customers
from suppliers