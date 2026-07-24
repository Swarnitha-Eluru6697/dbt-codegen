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
        emp_id,
        

        -- employment details
        joining_date,
        salary,


    from source

)

select * from renamed
