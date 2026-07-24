{{
  config(
    materialized = 'view'
  )
}}

with source as (

    select * from {{ source('public', 'employees') }}

),

renamed as (

    select
        -- keys
        employee_id,
        job_id,
        manager_id,
        department_id,

        -- contact info
        email,
        phone_number,

        -- employment details
        hire_date,
        salary,

        -- metadata
        created_at,
        updated_at

    from source

)

select * from renamed
