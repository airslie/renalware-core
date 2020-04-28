# PET and Adequacy tests

There are test done on PD patients. They are not dependent on each other but are often
regarded as being connected, probably because they are often (but not always) done on the same day.

## PET

A PET (Peritoneal Equilibration Test) helps to establish the efficiency of the peritonoeum
during PD (pertioneal dialysis). If creatinine comes out quickly then patient can have shorter
dwells, otherwise longer dwells needed.

There are *full* and *fast* tests.

In a *full* PET the process is for example
- the PD patient visits clinic
- they are drained
- an (e.g.) 2.27% dextrose bag is attached
- during a 4 hour dwell period, dialysate samples are taken at 0, 2 and 4 hours
- the fluid is drained at 4hr (volume out)
- the dialysate samples (serum) (including an overnight - usually 6hrs - sample) are sent for the
  following tests
  - Ur
  - Cr
  - glc
  - Na
  - protein
- bloods are taken

In a *fast* PET, patients may put in the 2.27% bag at home and come to clinic at the correct time
for a 4hr drain to be done, allowing `volume out` and the `4hr sample` concentration to be measured;
0h, 2h and overnight samples are not neccessarily collected.

At Barts the fast test is more usual.


## Adequacy

This test is done at least every 6 months and  measures how much toxin is removed from the body
through the peritoneum via PD and through urine via the residual renal function. In theory toxins
through the peritoneum will not go up much, but toxin through urine will rise as renal function
worsens.

### Measurements

*Blood*

- SerumUrea
- SerumCreatinine
- PlasmaGlc
- SerumAb
- SerumNa

*Urine*

- Urine Urea
- Urine Creatinine
- Urine Na
- Urine K
- Urine Protein

*Dialysate*

- Dialysate Urea
- Dialysate Creatinine
- Dialysate glc
- Dialysate Na
- Dialysate Protein

## UI Workflow

Both tests happen in phases
- collect patient samples
- enter pathology (manually or automatically) when it returns from the lab
- store calculated data

### When is a test finished?

#### PET

If there is (calculated) D/Pcr showing in table, then the test is finished.

#### Adequacy

If there is a Total kt/v, then clearly the test is finished as both the Peritoneal
and the Residual Renal Function component has been calculated.

*If patient brought up Peritoneal Part of Adequacy but not the 24hr Urine*

or

*If patient brought up the 24hr Urine but not the Peritoneal Part of Adequacy*

Then once kt/v_Perit null, then the test is finished (kt/v_RRF and no kt/v_T will be null).
