{% macro tsql_empty_filter() -%}

    {#-- Checks if the dbt --empty flag is currently active #}
    {% if flags.EMPTY %}
        AND 1 = 0
    {% endif %}
    
{%- endmacro %}