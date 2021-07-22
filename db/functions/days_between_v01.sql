CREATE OR REPLACE FUNCTION days_between(t_start timestamp, t_end timestamp)
RETURNS integer
AS $$
  begin
    -- calculate the days between 2 timestamps
    return (select (EXTRACT(epoch from age(t_end, t_start)) / 86400)::integer);
  end
$$
LANGUAGE plpgsql
IMMUTABLE
RETURNS NULL ON NULL INPUT;
