-- Note there is already a convert_to_float function but that remains untouched - this version
-- has different arguments so is a new (overlaoded) function.
CREATE OR REPLACE FUNCTION renalware.convert_to_float(v_input text, default_value_if_cannot_be_coerced float)
RETURNS float AS $$
DECLARE v_float_value float DEFAULT NULL;
BEGIN
    BEGIN
        v_float_value := v_input::float;
    EXCEPTION WHEN OTHERS THEN
        RETURN default_value_if_cannot_be_coerced;
    END;
RETURN v_float_value;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION renalware.convert_to_float(text, float) IS
'Tries to coerce v_input into a float (double precision) and it it cannot,
returns default_value_if_cannot_be_coerced';
