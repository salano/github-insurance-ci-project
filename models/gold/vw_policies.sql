{{
  config(
        materialized = "view",
        schema='gold'
    )
}}

WITH base_query AS (
  /*---------------------------------------------------------------------------
        1) Base Query: Retrieves core columns from silver.policies
        ---------------------------------------------------------------------------*/
  SELECT
    p.[cust_id],
    p.[policy_id],
    p.[policy_type],
    p.[status] AS [policy_status],
    p.[start_date],
    p.[end_date],
    p.[coverage_amount],
    p.[annual_premium],
    p.[monthly_payment],
    p.[distribution_channel]
  FROM
    {{ ref('st_ins_policies') }} p -- noqa: AL01
  WHERE
    p.[dbt_valid_to] IS NULL

    -- Crucial: Call your custom macro at the end of the WHERE statement
    {{ tsql_empty_filter() }}

)
SELECT *
FROM
  base_query