# HD Diary

## Archiving lots in the past

Each night a rake task kicks off that does the following:

- From 1 year ago (or the date Renalware went live) up until last week (the week ends on Sunday),
check each week has a weekly diary. If the slots in any week were just filled from the master diary,
it is conceivable that a weekly diary will not have been created, though unlikely.

- Looking back across the same timespan, move any active slots in the master diary in each week - ie
where there is a slot in the master diary but none (overriding it) in the weekly diary - and copy
the master slots into the weekly diary, thus overriding the master slots. This is a way of
'freezing' the diary so changes to the master diary in the present or future do not alter the
diary in the past.

- For each weekly slot in the same time period, mark it as archived so it cannot be chaanged.
