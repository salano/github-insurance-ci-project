{{
  config(
        materialized = "view",
        schema='gold'
    )
}}

WITH base_query AS (
  /*---------------------------------------------------------------------------
        1) Base Query: Retrieves core columns from gold.claims, gold.customers and gold.policies
        ---------------------------------------------------------------------------*/
  SELECT
    cu.[cust_id],
    cu.[Date_of_Birth],
    cu.[Gender],
    cu.[Contact_Number],
    cu.[CustomerName]
  FROM
    {{ ref('st_ins_customers') }} cu
  WHERE
    cu.[dbt_valid_to] IS NULL

    -- Crucial: Call your custom macro at the end of the WHERE statement
    {{ tsql_empty_filter() }}
)
SELECT *
FROM
  base_query