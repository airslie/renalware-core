# Suppress the generic notice for non-ASCII text, including the supported micro sign.
# This does not suppress IncompatibleStringEncoding for characters without font coverage.
Prawn::Fonts::AFM.hide_m17n_warning = true
