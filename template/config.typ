// ================================================================================================
// config.typ: Thesis configuration
// ================================================================================================
// All parameters for the thesis body (main.typ) and the book cover (cover.typ) are defined here.
// ================================================================================================

#let config = (
    // Thesis identity
    title: [Τίτλος Διπλωματικής Εργασίας],
    subtitle: [Υπότιτλος],
    thesis_image: image("assets/figures/logo-placeholder.svg", height: 25%),
    division: "Τομεας Τεχνολογιας Πληροφορικης και Υπολογιστων",

    // Author
    author: "Όνομα Επώνυμο",
    author_uppercase: "ΟΝΟΜΑΤΕΠΩΝΥΜΟ ΦΟΙΤΗΤΗ/ΦΟΙΤΗΤΡΙΑΣ",
    definite_article: "του/της/των", // "του" / "της" / "των"

    // Supervisor
    supervisor_label: "Επιβλέπων/Επιβλέπουσα", // Επιβλέπων ή Επιβλέπουσα
    supervisor: "Ονοματεπώνυμο επιβλέποντα/επιβλέπουσας",
    supervisor_title: "Τίτλος/ιδιότητα επιβλέποντα/επιβλέπουσας",

    // Co-supervisor (none to hide)
    co_supervisor_label: none, // Επιβλέπων ή Επιβλέπουσα ή none
    co_supervisor: none,
    co_supervisor_title: none,

    // Examination committee
    examination_date: "ΧΧη Μήνας 20ΧΧ",
    first_examiner: "Όνομα Πρώτου Εξεταστή",
    first_examiner_title: "Τίτλος Πρώτου Εξεταστή",
    second_examiner: "Όνομα Δεύτερου Εξεταστή",
    second_examiner_title: "Τίτλος Δεύτερου Εξεταστή",
    third_examiner: "Όνομα Τρίτου Εξεταστή",
    third_examiner_title: "Τίτλος Τρίτου Εξεταστή",

    // Publication
    pub_place_date: "Αθήνα, Μήνας 20ΧΧ",
    copyright_year: "20ΧΧ",

    // Appearance
    accent_color: rgb("#6A500F"),
    secondary_color: none, // none = accent_color.darken(20%)
    serif_font: "Libertinus Serif",
    sans_font: "Libertinus Sans",
    code_font: "Ioskeley Mono",
    font_size: 11pt,

    // Page geometry
    paper: "a4",
    margin_top: 2.5cm,
    margin_bottom: 2.5cm,
    margin_inside: 3.5cm,
    margin_outside: 2.5cm,

    // Extra languages (syntax highlighting + codly badge)
    // Set extra_syntaxes: none or () to disable; extra_languages: none or (:) to disable.
    extra_syntaxes: none,
    extra_languages: none,
)
