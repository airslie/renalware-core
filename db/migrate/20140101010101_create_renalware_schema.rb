# Bad practice perhaps, but this migration inserted retrospectively in order to create a renalware
# schema before doing anything else, so that subsequent migrations will put objects into that
# schema. See
#   schema_search_path: "renalware,public"
# in database.yml - we look for objects in the renalware schema first.
#
# Someone developing a host application can create custom tables, views etc in the
# public schema and these will be found provided either
# - their name is unique does not clash with a name in the renalware schema, or
# - they specify the schema in the model. For example if they are creating their own Patient model
#   and `patients` table, they will need to use
#     self.table_name = "public.patients"
#   in order to avoid a clash with renalware.patients, which is the first entry
#   in schema_search_path.
# - . This lets us ring fence renalware db objects and prevent
# name clashes as long as if for instance a host app defines a patients table in the public schema
# they reference it as public.patients otherwise renalware.patients will be used.
#
# An alternative to inserting this migration at the head would be to create a new tail migration
# that executes the following for every table, view and fn (indexes moved automatically)
#   ALTER table xx SET SCHEMA renalware
# but a this point we have not gone live so thus seems like unnecessary work and more error prone.
#
class CreateRenalwareSchema < ActiveRecord::Migration[4.2]
  def change
    execute "CREATE SCHEMA IF NOT EXISTS renalware"
  end
end
