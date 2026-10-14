// ================================================================================================
// back_cover.typ: Back cover (οπισθόφυλλο) content
// ================================================================================================
// Used by both main.typ (spiral binding) and cover.typ (paperback binding).
// ================================================================================================

// The text that appears on the back cover
#let back-cover-text = [
    Γράψτε εδώ το κείμενο του οπισθόφυλλου. Θα μπορούσε να είναι η περίληψη της εργασίας ή κάποιο
    άλλο κείμενο της επιλογής σας.
]

// Gap between the drop-cap initial and the body text
#let back-cover-content-gap = 3pt

// Optional: link to your code repository
// Set to none to omit.
#let back-cover-github-url = none

// Optional: ISBN. Renders as a white EAN-13 barcode on the back cover
// Set to none to omit
#let back-cover-isbn = none
