{% macro verify_setup_target() %}
    {% if target.database | upper != 'CONFIDO_INTERVIEWS' or target.schema | upper != 'ZACHARY' %}
        {{ exceptions.raise_compiler_error('Setup is restricted to CONFIDO_INTERVIEWS.ZACHARY.') }}
    {% endif %}
    {% if execute %}
        {% set schemas = run_query("select schema_name from CONFIDO_INTERVIEWS.information_schema.schemata where schema_name = 'ZACHARY'") %}
        {% if schemas.rows | length != 1 %}
            {{ exceptions.raise_compiler_error('Assigned ZACHARY schema does not exist or is not accessible.') }}
        {% endif %}
    {% endif %}
    {{ return('select 1') }}
{% endmacro %}
