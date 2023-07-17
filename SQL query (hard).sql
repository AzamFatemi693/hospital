# Show all of the patients grouped into weight groups. Show the total amount of patients in each weight group. Order the list by the weight group decending.

SELECT (weight / 10) * 10 AS weight_group, COUNT(*) AS patients_in_this_weight_group
FROM patients
GROUP BY weight_group
ORDER BY weight_group DESC

  
# Show patient_id, weight, height, isObese from the patients table. Display isObese as a boolean 0 or 1. Obese is defined as weight(kg)/(height(m)2) >= 30. weight is in units kg. height is in units cm.

select patient_id, weight, height,
    (case when weight/(power((height*0.01),2)) >= 30 then 1
    else 0
    end) as isObes
from patients

  

# Show patient_id, first_name, last_name, and attending doctor's specialty.Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'. Check patients, admissions, and doctors tables for required information.

select patient_id, p.first_name, p.last_name, d.specialty
from patients p
join admissions a
    using(patient_id)
join doctors d
    on a.attending_doctor_id = d.doctor_id
where diagnosis = 'Epilepsy' and d.first_name = 'Lisa'

# All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.

# The password must be the following, in order: 1. patient_id, 2. the numerical length of patient's last_name, 3. year of patient's birth_date

select distinct patient_id, concat(patient_id, cast(length(last_name) as numeric), year(birth_date)) as temp_password
from patients
join admissions
using(patient_id)
where admission_date is not null

  

# Each admission costs $50 for patients without insurance, and $10 for patients with insurance. All patients with an even patient_id have insurance. Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. Add up the admission_total cost for each has_insurance group.

select
    case when patient_id%2 == 0 then 'Yes'
    else 'No'
    end as has_insurance,
    sum(case when patient_id%2 == 0 then 10
    else 50
    end) as admission_cost
from admissions
group by has_insurance


# Show the provinces that has more patients identified as 'M' than 'F'. Must only show full province_name

select province_name
from province_names pn
join patients p
    using(province_id)
group by province_name
having sum(gender = 'M') > sum(gender = 'F')

  
# We are looking for a specific patient. Pull all columns for the patient who matches the following criteria: First_name contains an 'r' after the first two letters. Identifies their gender as 'F'. Born in February, May, or December, Their weight would be between 60kg and 80kg,  Their patient_id is an odd number,  They are from the city 'Kingston'

SELECT *
FROM patients
WHERE first_name LIKE '%__r%'
    AND gender = 'F'
    AND month(birth_date) IN (2, 5, 12)
    and weight between 60 and 80
    and patient_id%2 != 0
a   nd city = 'Kingston'

  
# Show the percent of patients that have 'M' as their gender. Round the answer to the nearest hundreth number and in percent form.

select concat(round(sum(case when gender = 'M' then 1 else 0 end)*100.0/count(*),2),'%') percent_of_patients_male
from patients


# For each day display the total amount of admissions on that day. Display the amount changed from the previous date.

SELECT admission_date,
    COUNT(admission_date) AS admission_day,
    COUNT(admission_date) - LAG(COUNT(admission_date)) OVER (ORDER BY admission_date) AS admission_count_change
FROM admissions
GROUP BY admission_date

  
# Sort the province names in ascending order in such a way that the province 'Ontario' is always on top.

select province_name
from province_names
order by case when province_name = 'Ontario' then 0 else 1 end, province_name
# or
select province_name
from province_names
order by
province_name = 'Ontario' desc,
province_name
