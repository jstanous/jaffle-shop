-- macros/generate_schema_name.sql
{% macro generate_schema_name(custom_schema_name, node) %}

    {% set default_schema = target.schema %}

    {# seeds go in a global `raw` schema #}
    {% if target.name == 'dev' %}
        {{ default_schema }}_{{ custom_schema_name | trim }}

    {# non-specified schemas go to the default target schema #}
    {% elif custom_schema_name is not none %}
        {{ custom_schema_name }}

    {# specified custom schemas go to the default target schema for non-prod targets #}
    {% else %}
        {{ default_schema }}
    {% endif %}

{% endmacro %}