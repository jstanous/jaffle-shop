-- macros/generate_schema_name.sql
{% macro generate_schema_name(custom_schema_name, node) -%}

    {% if target.name == 'prod' %}
        {# In prod, respect any explicit override #}
        {% if custom_schema_name is not none %}
            {{ custom_schema_name }}
        {% else %}
            {{ target.schema }}
        {% endif %}
    {% else %}
        {# In non-prod (dev, default, etc.), build schema as user + folder #}
        {{ node.fqn[1] }}_{{ target.user | lower }}
    {% endif %}

{%- endmacro %}