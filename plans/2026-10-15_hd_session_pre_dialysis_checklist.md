# HD session pre dialysis checklist

- Two fields stored in the HD session jsonb document under `pre_dialysis_checklist` (`completed` yes/no with no default, `findings` text). No migration.
- Shown above "Put on by" on the HD session form and on the session show page only when `Renalware.config.hd_sessions_require_pre_dialysis_checklist` is true (env `HD_SESSIONS_REQUIRE_PRE_DIALYSIS_CHECKLIST`, default false).
- Validated only when a session is closed (signed off): `completed` must be answered, `findings` required when `completed` is no.
