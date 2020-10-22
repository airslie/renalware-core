## Changing which pathology test results are displayed

When you view a table of pathology results, for example in a patient's Recent Pathology screen,
the list and order of pathology codes (aka OBX codes, or in renalware database parlance,
observation_descriptions) is determined by data.

There are are currently 3 mechanisms at work, but we are migrating all to option 1 over time.

### 1. Pathology Code Groups

### The pathology_code_groups table

A code group is defined in the 'pathology_code_group' table.
It represents a set of observation descriptions that are displayed together, for example on a letter on or an  MDM screen.
We don't always want to display the same set of results. For example in the context of an HD MDM we might want to display only HD-relevant results, while in the main historical pathology view we want to see a wide set of results. By defining a group with a name like 'recent_pathology' or 'hd_mdm' we can load and display only the results in that group.

### The pathology_code_group_memberships table

An ObservationDescription can be a member of many code groups.
Within each group, say, 'letters', a description might be in a sub group (which merely serves group together related results when displayed) and within that group it might have a position, which
determines its order in the subgroup.

Code Groups are currently used in:

- HD Protocol (Session form) print out using the group nanme 'hd_session_form_recent'

At some point we will add some superadmin functionality allow
configuring code groups in the UI. Up until then it is a SQL task.

### 2. (Legacy) display_group/display_order columns

Before CodeGroups, pathology display was driven by various columns on the
`pathology_observation_descriptions` table, which allows for two groups of codes, one for
general use and one for letters.

| Column | Purpose |
|---|---|
| display_group | (integer) If not null then code is displayed in most pathology tables (eg recent pathology). Groups together related codes |
| display_order | (integer) Determines the display order of the code within display_group (if set) |
| letter_group | As above but for display on letters |
| letter_order | As above but for display on letters |

You can see that that this mechanism is not very extensible, and if needing to define another 'set' of codes, you
would have to add 2 more columns to the pathology_observation_descriptions table each time. This is
the problem that pathology_code_group_memberships tries to solve.

This mechanism is still used in these places:
- current pathology
- recent pathology
- historical pathology

### 3. (Legacy) Hard-coded code sets

Originally certain arrays of OBX codes where hard coded. We are migrating these
to data-driven lists using Option 1.

This mechanism in used in these places
- pathology on letters (see Renalware::Letters::RelevantObservationDescription)
- recent pathology in MDMs
