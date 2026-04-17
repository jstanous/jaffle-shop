-- macros/generate_all_base_models.sql
{% macro generate_all_base_models() %}
    {% for source in graph.sources %}
        {% set source_name = source.source_name %}
        {% set table_name = source.name %}
        {{ codegen.generate_base_model(
            source_name=source_name,
            table_name=table_name,
            materialized='view'
        ) }}
    {% endfor %}
{% endmacro %}