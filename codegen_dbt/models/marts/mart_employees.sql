-- models/marts/mart_employees.sql
{{ config(materialized='table') }}

with enriched as (

    select * from {{ ref('int_employees_enriched') }}

),

dept_stats as (

    select
        department,
        count(*)                            as dept_headcount,
        round(avg(salary), 2)               as dept_avg_salary,
        round(min(salary), 2)               as dept_min_salary,
        round(max(salary), 2)               as dept_max_salary

    from enriched
    where is_active = true
    group by department

),

final as (

    select
        -- employee grain
        e.employee_id,
        e.manager_id,
        e.full_name,
        e.email,
        e.department,
        e.job_title,
        e.salary,
        e.salary_band,
        e.hire_date,
        e.years_at_company,
        e.is_active,

        -- department context
        d.dept_headcount,
        d.dept_avg_salary,
        d.dept_min_salary,
        d.dept_max_salary,

        -- relative position within dept
        round(
            (e.salary - d.dept_avg_salary) / nullif(d.dept_avg_salary, 0) * 100,
        2)                                  as pct_diff_from_dept_avg

    from enriched  e
    left join dept_stats d
           on e.department = d.department

)

select * from final