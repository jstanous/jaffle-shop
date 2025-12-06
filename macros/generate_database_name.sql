-- macros/generate_database_name.sql
{% macro generate_database_name(custom_database_name, node) -%}

    {% if target.name == 'prod' %}
        {# In prod, respect any explicit override #}
        {% if custom_database_name is not none %}
            {{ custom_database_name }}
        {% else %}
            {{ target.database }}
        {% endif %}
    {% else %}
        {# In non-prod (dev, default, etc.), force DBT_DEV #}
        DBT_DEV
    {% endif %}

{%- endmacro %}
