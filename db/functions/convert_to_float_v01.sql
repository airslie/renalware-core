CREATE OR REPLACE FUNCTION renalware.convert_to_float(v_input text)
RETURNS FLOAT  AS $$
DECLARE v_float_value FLOAT DEFAULT NULL;
BEGIN
    -- return the value as a float or 0 if the value cannot be coerced into a float
    BEGIN
        v_float_value := v_input::FLOAT;
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Invalid float value: "%".  Returning NULL.', v_input;
        RETURN 0;
    END;
RETURN v_float_value;
END;
$$ LANGUAGE plpgsql;
