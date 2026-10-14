// ================================================================================================
// lib.typ
// ================================================================================================
// This is the main entry point of the ntua-thesis template.
//
// Documentation: Template-guide.pdf
// Copyright © 2026, Nikolaos Tziris
// ================================================================================================

// Package imports
#import "@preview/hydra:0.6.1": hydra
#import "@preview/glossarium:0.5.9": (
    Gls, Glspl, gls, glspl, make-glossary, print-glossary, register-glossary,
    gls-short, gls-plural, gls-long, gls-longplural,
)
#import "utils.typ": *

// Εμφανίζει τον πλήρη όρο ως «long, short» (π.χ. «State Machine Replication, SMR»), με
// τα δύο μέρη συνδεδεμένα (clickable) προς την καταχώρηση στο γλωσσάρι και μία μόνο
// back-reference. Με plural: true δίνει «longplural, plural» (π.χ. «transactions, txs»).
#let glsfull(key, plural: false) = if plural {
    [#gls-longplural(key, link: true, update: true), #link(label(key))[#gls-plural(key)]]
} else {
    [#gls-long(key, link: true, update: true), #link(label(key))[#gls-short(key)]]
}

// Main template function
#let thesis-setup(
    // Thesis
    title: [Τίτλος Διπλωματικής Εργασίας],
    subtitle: [Υπότιτλος],
    thesis_image: none,
    division: "Τομεας Τεχνολογιας Πληροφορικης και Υπολογιστων",

    // Author
    author: "Όνομα Επώνυμο",
    author_uppercase: "ΟΝΟΜΑ ΕΠΩΝΥΜΟ",
    definite_article: "του/της/των",

    // Supervisor
    supervisor_label: "Επιβλέπων",
    supervisor: "Ονοματεπώνυμο Επιβλέποντα",
    supervisor_title: "Καθηγητής Ε.Μ.Π.",

    // Co-supervisor (optional, leave empty to hide)
    co_supervisor_label: "",
    co_supervisor: "",
    co_supervisor_title: "",

    // Examination committee
    examination_date: "ΧΧη Μήνας 20ΧΧ",
    first_examiner: "Όνομα Πρώτου Εξεταστή",
    first_examiner_title: "Καθηγητής Ε.Μ.Π.",
    second_examiner: "Όνομα Δεύτερου Εξεταστή",
    second_examiner_title: "Επίκουρος Καθηγητής Ε.Μ.Π.",
    third_examiner: "Όνομα Τρίτου Εξεταστή",
    third_examiner_title: "Καθηγητής Ε.Μ.Π.",

    // Publication
    pub_place_date: "Αθήνα, Μήνας 20ΧΧ",
    copyright_year: "20ΧΧ",

    // Appearance
    accent_color: rgb("#003262"),
    secondary_color: none, // defaults to accent_color.darken(20%) if none
    serif_font: "Libertinus Serif",
    sans_font: "Libertinus Sans",
    code_font: "New Computer Modern Mono",
    font_size: 11pt,

    // Page geometry
    paper: "a4", // Paper size string, e.g. "a4" or "us-letter"
    margin_top: 2.5cm,
    margin_bottom: 2.5cm,
    margin_inside: 3.5cm, // Binding side margin
    margin_outside: 2.5cm,

    // Codly extra languages
    extra_syntaxes: (),
    extra_languages: (:),

    // Output mode
    include_covers: true, // set to false for paperback body-only PDF
    show_cover_decorations: true, // set to false for library (no border, no student logo)

    body,
) = {
    let secondary_color = if secondary_color == none { accent_color.darken(20%) } else {
        secondary_color
    }

    // Propagate colors, fonts, and metadata to utility functions via state
    accent-color-state.update(accent_color)
    secondary-color-state.update(secondary_color)
    sans-font-state.update(sans_font)
    code-font-state.update(code_font)
    author-state.update(author)
    copyright-year-state.update(copyright_year)
    pub-place-date-state.update(pub_place_date)
    division-state.update(division)

    title-state.update(title)
    subtitle-state.update(subtitle)
    definite-article-state.update(definite_article)
    author-uppercase-state.update(author_uppercase)
    supervisor-text-state.update(supervisor_label)
    supervisor-state.update(supervisor)
    supervisor-title-state.update(supervisor_title)
    co-supervisor-text-state.update(co_supervisor_label)
    co-supervisor-state.update(co_supervisor)
    co-supervisor-title-state.update(co_supervisor_title)
    examination-date-state.update(examination_date)
    first-examiner-state.update(first_examiner)
    first-examiner-title-state.update(first_examiner_title)
    second-examiner-state.update(second_examiner)
    second-examiner-title-state.update(second_examiner_title)
    third-examiner-state.update(third_examiner)
    third-examiner-title-state.update(third_examiner_title)

    // Initialize codly for styled code blocks
    // Add spacing between icon and language name for all entries
    let _spaced-languages = {
        let d = (:)
        for (k, v) in (
            codly-languages + if extra_languages == none { (:) } else { extra_languages }
        ) {
            d.insert(k, v + (name: h(0.3em) + v.name))
        }
        d
    }
    show: codly-init.with()
    codly(
        languages: _spaced-languages,
        stroke: none,
        fill: none,
        zebra-fill: none,
        number-format: n => text(fill: accent_color, weight: "bold", str(n)),
    )

    // BASIC SETUP

    // Document metadata (embedded in PDF)
    set document(author: author, title: title)

    // Default language and hyphenation
    set text(lang: "el", hyphenate: true)

    // Cover page: flat 2cm margins + decorative 1cm border with rounded inner corners
    set page(
        paper: paper,
        binding: left,
        margin: if include_covers { 2cm } else {
            (
                top: margin_top,
                bottom: margin_bottom,
                inside: margin_inside,
                outside: margin_outside,
            )
        },
        numbering: none,
        background: context {
            if include_covers and show_cover_decorations and here().page() == 1 {
                place(top + left, rect(width: 100%, height: 100%, fill: accent_color))
                place(top + left, dx: 1cm, dy: 1cm, rect(
                    width: 100% - 2cm,
                    height: 100% - 2cm,
                    fill: white,
                    radius: 0.3cm,
                ))
            }
        },
    )

    // Font
    set text(font: serif_font, size: font_size)
    show raw: set text(font: code_font)

    // Colored links, citations and cross-references
    show link: set text(fill: secondary_color)
    show cite: set text(fill: secondary_color)
    show ref: set text(fill: secondary_color)

    // Paragraph formatting
    set par(
        justify: true,
        first-line-indent: 0pt,
        leading: 1em,
        spacing: 2em,
    )

    // Default figure settings
    set figure(supplement: [Σχήμα], gap: 2em)

    // Math cases gap
    set math.cases(gap: 1em)

    // HEADING STYLES
    set heading(numbering: "1.1.1")

    // Level 0: Parts
    show figure.where(kind: "part"): it => {
        set text(font: sans_font)
        blank-pagebreak(to: "odd")
        align(
            right,
            block(
                height: 100%,
                above: 2cm,
                stack(
                    dir: ttb,
                    v(1fr),
                    if it.numbering != none {
                        text(20pt, weight: "bold", fill: accent_color, [Μέρος])
                        h(1em)
                        box(fill: accent_color, radius: 2pt, outset: 5pt, text(
                            25pt,
                            fill: white,
                            weight: "bold",
                            it.counter.display(it.numbering),
                        ))
                        linebreak()
                    },
                    v(2.5em),
                    text(26pt, weight: "bold", fill: accent_color, it.body),
                    v(2em),
                    line(length: 100%, stroke: accent_color),
                    v(2fr),
                ),
            ),
        )
        blank-pagebreak(to: "odd")
    }

    // Level 1: Chapters (or appendices when in appendix mode)
    show heading.where(level: 1): it => {
        set text(font: sans_font)
        pagebreak(weak: true)
        if it.numbering != none {
            context {
                text(
                    14pt,
                    fill: accent_color,
                    if in-appendix.get() { [Παράρτημα] } else { [Κεφάλαιο] },
                )
                h(0.5em)
                box(fill: accent_color, radius: 3pt, outset: 4pt, text(
                    23pt,
                    fill: white,
                    counter(heading).display(it.numbering),
                ))
            }
            linebreak()
        }
        text(20pt, weight: "bold", fill: accent_color, it.body)
        v(-0.5em)
        line(length: 100%, stroke: accent_color)
        v(1em)
    }
    show heading.where(level: 1): set heading(supplement: "Κεφάλαιο")

    // Level 2: Sections
    show heading.where(level: 2): it => {
        set text(font: sans_font)
        block(spacing: 1.5em, {
            if it.numbering != none {
                text(14pt, weight: "bold", fill: accent_color, counter(heading).display(it.numbering))
                h(1em)
            }
            text(14pt, weight: "bold", fill: accent_color, it.body)
        })
    }
    show heading.where(level: 2): set heading(supplement: [Ενότητα])

    // Level 3: Subsections
    show heading.where(level: 3): it => {
        set text(font: sans_font)
        block(spacing: 1.5em, {
            if it.numbering != none {
                text(12pt, weight: "bold", fill: accent_color, counter(heading).display(it.numbering))
                h(1em)
            }
            text(12pt, weight: "bold", fill: accent_color, it.body)
        })
    }
    show heading.where(level: 3): set heading(supplement: [Υποενότητα])

    // FIGURES, TABLES, AND EQUATIONS

    // Reset figure/equation counters at the start of each chapter so numbering follows the
    // "Chapter.Number" pattern (e.g. 2.3)
    show heading.where(level: 1): it => {
        counter(math.equation).update(0)
        counter(figure.where(kind: image)).update(0)
        counter(figure.where(kind: table)).update(0)
        counter(figure.where(kind: raw)).update(0)
        counter(figure.where(kind: "Code")).update(0)
        counter(figure.where(kind: "ntua-thm")).update(0)
        counter(figure.where(kind: "ntua-lem")).update(0)
        counter(figure.where(kind: "ntua-cor")).update(0)
        counter(figure.where(kind: "ntua-prop")).update(0)
        counter(figure.where(kind: "ntua-def")).update(0)
        counter(figure.where(kind: "ntua-rem")).update(0)
        counter(figure.where(kind: "ntua-ex")).update(0)
        counter(figure.where(kind: "ntua-hyp")).update(0)
        counter(figure.where(kind: "Algorithm")).update(0)
        it
    }

    // Caption formatting
    show figure.caption: set text(size: 0.9em)
    show figure.caption: set align(center)

    // Per-kind supplements with colored, bold labels
    let figure-supplement = text(fill: secondary_color, weight: "bold", [Σχήμα])
    let table-supplement = text(fill: secondary_color, weight: "bold", [Πίνακας])
    let code-supplement = text(fill: secondary_color, weight: "bold", [Κώδικας])
    let algorithm-supplement = text(fill: secondary_color, weight: "bold", [Αλγόριθμος])
    let equation-supplement = text(fill: secondary_color, weight: "bold", [Εξίσωση])

    show figure: set block(spacing: 2em)
    show figure: set place(clearance: 1em)
    show figure.where(kind: image): set figure(supplement: figure-supplement)
    show figure.where(kind: table): set figure(supplement: table-supplement)
    show figure.where(kind: "Code"): set figure(supplement: code-supplement)

    // Long listings must be able to run over a page break. A figure is laid out as a
    // single unbreakable block by default, so a listing taller than the remaining space
    // is pushed whole to the next page, and one taller than a full page overflows into
    // the footer. Making the figure's block breakable lets it flow instead.
    show figure.where(kind: "Code"): set block(breakable: true)
    show figure.where(kind: "Algorithm"): set figure(supplement: algorithm-supplement)

    // IEEE-style tables: horizontal rules only (top, below header, bottom)
    // Caption above the table by convention
    show figure.where(kind: table): set figure.caption(position: top)
    show table.cell.where(y: 0): set text(weight: "bold")
    set table(
        inset: (x: 8pt, y: 5pt),
        stroke: none,
    )

    // Chapter-relative numbering for all figures (Greek-letter prefix in appendix mode)
    set figure(numbering: num => context text(fill: secondary_color, weight: "bold", numbering(
        if in-appendix.get() { "Α.1" } else { "1.1" },
        counter(heading).get().first(),
        num,
    )))

    // Unify caption rendering: "Prefix N.M." followed by the caption body.
    // fig.supplement is already the colored/bold label, set per-kind above.
    show figure: fig => {
        let numbers = numbering(fig.numbering, ..fig.counter.at(fig.location()))
        show figure.caption: it => [#text(
                fig.supplement + " " + numbers + ".",
                weight: "bold",
            ) #it.body]
        fig
    }

    // Chapter-relative equation numbering: (Chapter.Number)
    set math.equation(
        supplement: equation-supplement,
        numbering: num => context text(fill: secondary_color, weight: "bold", numbering(
            if in-appendix.get() { "(Α.1)" } else { "(1.1)" },
            counter(heading).get().first(),
            num,
        )),
    )

    // CROSS-REFERENCES
    //
    // Every numbering function above reads the chapter counter through `context`, which
    // resolves at the point where the number is *displayed*. That is correct for the
    // element itself, but wrong for a reference to it: a reference in chapter 9 to a
    // definition in chapter 6 renders as «Ορισμός 9.9» instead of «Ορισμός 6.9», because
    // the chapter counter is read at the reference site.
    //
    // This rule recomputes both the chapter and the item number at the *referenced*
    // element's own location, so cross-chapter references are correct.
    //
    // It also honours an explicit `supplement`, which is how Greek grammar is handled:
    // `#ref(<tab-x>, supplement: [Πίνακα])` gives «Πίνακα 9.7» instead of the
    // ungrammatical «Πίνακας 9.7» after a preposition.
    let _thm-kinds = (
        "ntua-thm", "ntua-lem", "ntua-cor", "ntua-prop",
        "ntua-def", "ntua-rem", "ntua-ex", "ntua-hyp",
    )
    show ref: it => {
        let el = it.element
        if el == none {
            it
        } else if el.func() == figure {
            let loc = el.location()
            let col = if el.kind in _thm-kinds { accent_color } else { secondary_color }
            let num = numbering(
                if in-appendix.at(loc) { "Α.1" } else { "1.1" },
                counter(heading).at(loc).first(),
                counter(figure.where(kind: el.kind)).at(loc).first(),
            )
            let suppl = if it.supplement == auto {
                el.supplement
            } else {
                text(fill: col, weight: "bold", it.supplement)
            }
            link(loc, [#suppl #text(fill: col, weight: "bold", num)])
        } else if el.func() == math.equation {
            let loc = el.location()
            let num = numbering(
                if in-appendix.at(loc) { "(Α.1)" } else { "(1.1)" },
                counter(heading).at(loc).first(),
                counter(math.equation).at(loc).first(),
            )
            let suppl = if it.supplement == auto {
                equation-supplement
            } else {
                text(fill: secondary_color, weight: "bold", it.supplement)
            }
            link(loc, [#suppl #text(fill: secondary_color, weight: "bold", num)])
        } else {
            it
        }
    }

    // THEOREM-LIKE ENVIRONMENTS (IEEE style)
    // The label (e.g. «Θεώρημα 2.1.») runs inline with the body, as is the convention
    // for these environments. The body simply continues after the label and wraps
    // naturally across lines.
    let _show-thm(it, italic-body) = context {
        let ch = counter(heading.where(level: 1)).at(it.location()).first()
        let n = it.counter.at(it.location()).first()
        let ch-str = if in-appendix.get() { numbering("Α", ch) } else { str(ch) }
        let leading = par.leading
        let header = {
            text(fill: accent_color, weight: "bold")[#it.supplement~#ch-str.#n]
            if it.caption != none and it.caption.body != [] {
                text(fill: accent_color, weight: "bold")[ (#it.caption.body)]
            }
        }
        let body-raw = if italic-body { emph(it.body) } else { it.body }
        set align(left)
        set par(first-line-indent: 0pt, spacing: leading)
        block(
            width: 100%,
            above: 2 * leading,
            below: 2 * leading,
            header + h(1em) + body-raw,
        )
    }

    show figure.where(kind: "ntua-thm"): it => _show-thm(it, true)
    show figure.where(kind: "ntua-lem"): it => _show-thm(it, true)
    show figure.where(kind: "ntua-cor"): it => _show-thm(it, true)
    show figure.where(kind: "ntua-prop"): it => _show-thm(it, true)
    show figure.where(kind: "ntua-def"): it => _show-thm(it, false)
    show figure.where(kind: "ntua-rem"): it => _show-thm(it, false)
    show figure.where(kind: "ntua-ex"): it => _show-thm(it, false)
    show figure.where(kind: "ntua-hyp"): it => _show-thm(it, true)

    // OUTLINE (TABLE OF CONTENTS) STYLES

    // Outline mode. Marks the contents of every outline, so that a caption written with
    // #short-caption knows whether it is printed under its figure or in a list.
    show outline: it => {
        in-outline.update(true)
        it
        in-outline.update(false)
    }

    // Citations belong under the figure, not in the list of figures. Dropping them here means a
    // caption keeps its sources even when no short caption is given.
    show cite: it => context if in-outline.get() { none } else { it }

    // Parts
    show outline.entry: it => {
        if (
            it.element.func() == figure
                and it.element.fields().caption != none
                and it.element.fields().caption.kind == "part"
        ) {
            show repeat: none
            let loc = it.element.location()
            let mut-res = text(
                14pt,
                fill: secondary_color,
                if it.element.numbering != none {
                    numbering(it.element.numbering, ..it.element.counter.at(loc))
                }
                    + h(1em)
                    + it.element.body,
            )

            if it.fill != none {
                mut-res += [ ] + box(width: 1fr, it.fill) + [ ]
            } else {
                mut-res += h(1fr)
            }

            mut-res += text(14pt, fill: secondary_color, it.page())
            // One link over the whole line, so the gap and the page number follow the
            // title, as in every other outline entry.
            v(0.5em) + strong(link(loc, mut-res)) + v(0.5em)
        } else if it.element.func() == figure {
            // Figures, tables, code listings and algorithms.
            // Rebuild the label using the chapter number taken from the figure's own
            // location. The figure's numbering function reads counter(heading).get(),
            // which in an outline resolves at the outline's location (chapter 0), so the
            // default prefix would print the wrong chapter in these lists.
            let el = it.element
            let loc = el.location()
            let ch = counter(heading).at(loc).first()
            let n = el.counter.at(loc).first()
            let number = numbering(if in-appendix.at(loc) { "Α.1" } else { "1.1" }, ch, n)
            let label = el.supplement + [ ] + text(weight: "bold", number)
            // The link wraps the whole entry, not just the label, so the caption, the
            // dot leader and the page number are clickable too, as in the table of
            // contents. `it.inner()` is the caption + fill + page number.
            link(loc, it.indented(label, it.inner()))
        } else {
            it
        }
    }

    // Chapters (level 1)
    show outline.entry.where(level: 1): it => {
        if it.element.func() != heading { it } else {
            show repeat: none
            v(1.5em, weak: true)
            text(12pt, fill: secondary_color, weight: "bold", it)
        }
    }

    // Sections (level 2)
    show outline.entry.where(level: 2): it => {
        if it.element.func() != heading { it } else {
            v(1.1em, weak: true)
            text(11pt, fill: secondary_color, weight: "medium", it)
        }
    }

    // Subsections (level 3)
    show outline.entry.where(level: 3): it => {
        if it.element.func() != heading { it } else {
            v(1em, weak: true)
            text(11pt, fill: secondary_color, it)
        }
    }

    // Figure, Table, Code & Algorithm lists
    show outline
        .where(target: figure.where(kind: image))
        .or(outline.where(target: figure.where(kind: table)))
        .or(outline.where(target: figure.where(kind: "Code")))
        .or(outline.where(target: figure.where(kind: "Algorithm"))): it => {
        v(1em, weak: true)
        text(11pt, fill: secondary_color, it)
    }

    // FRONT MATTER

    // Title Page
    if include_covers {
        ntua-header("pyrforos.svg", division, sans_font)

        align(
            horizon + center,
            block(
                height: 100%,
                above: 2cm,
                stack(
                    dir: ttb,
                    diploma-block(
                        accent_color,
                        sans_font,
                        title,
                        subtitle,
                        definite_article,
                        author_uppercase,
                    ),
                    v(2fr),
                    if show_cover_decorations { thesis_image },
                    v(3fr),
                    supervisor-block(
                        accent_color,
                        supervisor_label,
                        supervisor,
                        supervisor_title,
                        co_supervisor_label,
                        co_supervisor,
                        co_supervisor_title,
                    ),
                    v(3fr),
                    pub_place_date,
                    v(1em),
                ),
            ),
        )
    }

    // White background and normal margins for all remaining pages
    set page(
        fill: white,
        background: none,
        margin: (
            top: margin_top,
            bottom: margin_bottom,
            inside: margin_inside,
            outside: margin_outside,
        ),
    )

    // RUNNING HEADERS & FOOTERS
    set page(
        // Header
        header: context {
            if should-suppress-running-head() { return }

            // Running heads must not inherit local body paragraph spacing
            // (e.g. the bibliography's tighter entry spacing).
            set par(spacing: 2em, leading: 1em, first-line-indent: 0pt)

            let kef = hydra(1, display: (ctx, it) => {
                if it.numbering != none {
                    if in-appendix.get() { [Παράρτημα ] } else { [Κεφάλαιο ] }
                    numbering(it.numbering, ..counter(heading).at(it.location()))
                    [ ]
                }
                it.body
            })
            let sect = hydra(2)

            if calc.odd(here().page()) and (kef != none or sect != none) {
                align(right, text(fill: accent_color, style: "italic", sect))
                v(-1.3em)
                line(length: 100%, stroke: accent_color)
            }
            if calc.even(here().page()) and (kef != none or sect != none) {
                align(
                    left,
                    text(
                        fill: accent_color,
                        style: "italic",
                        kef,
                    ),
                )
                v(-1.3em)
                line(length: 100%, stroke: accent_color)
            }
        },

        // Footer
        footer: context {
            if should-suppress-running-head() { return }

            let page-badge = box(fill: accent_color, outset: 4pt, text(
                12pt,
                fill: white,
                weight: "bold",
                str(counter(page).get().first()),
            ))
            let thesis-label = text(12pt, style: "italic", fill: accent_color, [Διπλωματική
                Εργασία])

            if calc.odd(here().page()) {
                grid(
                    columns: (auto, 1fr, auto),
                    align(left, thesis-label), [], align(right, page-badge),
                )
            } else {
                grid(
                    columns: (auto, 1fr, auto),
                    align(left, page-badge), [], align(right, thesis-label),
                )
            }
        },
    )

    // QUOTE STYLE
    show quote: it => block(
        [
            #place(rect(width: 18pt, height: 22pt, fill: white), top + left, dx: -10pt, dy: -18pt)
            #place(
                text("\u{201C}", size: 55pt, fill: accent_color),
                top + left,
                dx: -16pt,
                dy: -10pt,
            )
            #emph(it.body)
            #if it.attribution != none {
                linebreak()
                align(right, text(size: 0.9em, fill: accent_color)[#it.attribution])
            }
        ],
        inset: 8pt,
        fill: white,
        radius: 6pt,
        stroke: 1pt + accent_color,
    )

    // BODY CONTENT
    body
}
