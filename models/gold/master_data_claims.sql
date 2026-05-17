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
        c.[claim_id],
        c.[claim_date],
        c.[claim_amount],
        c.[status],
        c.[gender],
        c.[deductible],
        c.[claim_reason],
        c.[is_fraud],
        c.[Zip_Code],
        p.[policy_id],
        p.[policy_type],
        p.[status] AS [policy_status],
        p.[start_date],
        p.[end_date],
        p.[coverage_amount],
        p.[annual_premium],
        p.[monthly_payment],
        p.[distribution_channel],
        cu.[cust_id],
        cu.[Date_of_Birth],
        cu.[Gender],
        cu.[Contact_Number],
        cu.[CustomerName]
    FROM
        {{ ref('gt_ins_claims') }} AS c
    LEFT JOIN 
        {{ ref('st_ins_policies') }} AS p
    on p.[policy_id] = c.[policy_id]
    LEFT JOIN 
        {{ ref('st_ins_customers') }} AS cu
    on cu.[cust_id] = p.[cust_id]
    WHERE 
        p.[dbt_valid_to] IS NULL
        AND cu.[dbt_valid_to] IS NULL
)
SELECT
    *
FROM
    base_query