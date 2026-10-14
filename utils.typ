// ================================================================================================
// utils.typ
// ================================================================================================
// This file provides utility functions and reusable components for ntua-thesis.
//
// Documentation: Template-guide.pdf
// Copyright © 2026, Nikolaos Tziris
// ================================================================================================

// Package imports
#import "@preview/droplet:0.3.1": dropcap
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.10": *
#import "@preview/algorithmic:1.0.7": (
    Assign, Break, Comment, Else, ElseIf, For, Function, If, Line, LineComment, Procedure, Return,
    While, algorithm as _algo-algorithm,
)
#import "@preview/zebra:0.1.0": qrcode
#import "@preview/tiaoma:0.3.0": ean

// State variables
#let accent-color-state = state("ntua-accent-color", black)
#let secondary-color-state = state("ntua-secondary-color", blue)
#let sans-font-state = state("ntua-sans-font", "Libertinus Sans")
#let code-font-state = state("ntua-code-font", "New Computer Modern Mono")
#let perilipsi-content-state = state("ntua-perilipsi-content", none)
#let perilipsi-gap-state = state("ntua-perilipsi-gap", 3pt)
#let author-state = state("ntua-author", "")
#let copyright-year-state = state("ntua-copyright-year", "")
#let pub-place-date-state = state("ntua-pub-place-date", "")
#let division-state = state("ntua-division", "")
#let title-state = state("ntua-title", [])
#let subtitle-state = state("ntua-subtitle", [])
#let definite-article-state = state("ntua-definite-article", "")
#let author-uppercase-state = state("ntua-author-uppercase", "")
#let supervisor-text-state = state("ntua-supervisor-text", "")
#let supervisor-state = state("ntua-supervisor", "")
#let supervisor-title-state = state("ntua-supervisor-title", "")
#let co-supervisor-text-state = state("ntua-co-supervisor-text", "")
#let co-supervisor-state = state("ntua-co-supervisor", "")
#let co-supervisor-title-state = state("ntua-co-supervisor-title", "")
#let examination-date-state = state("ntua-examination-date", "")
#let first-examiner-state = state("ntua-first-examiner", "")
#let first-examiner-title-state = state("ntua-first-examiner-title", "")
#let second-examiner-state = state("ntua-second-examiner", "")
#let second-examiner-title-state = state("ntua-second-examiner-title", "")
#let third-examiner-state = state("ntua-third-examiner", "")
#let third-examiner-title-state = state("ntua-third-examiner-title", "")

// Appendix mode: when true, level-1 headings render as «Παράρτημα Α» (Greek-letter
// numbering) instead of «Κεφάλαιο 1», and figures/equations/theorems number as «Α.1».
#let in-appendix = state("ntua-in-appendix", false)

// Outline mode: true while the entries of an outline are laid out. Captions read it through
// #short-caption to print a different text in the lists of figures and tables.
#let in-outline = state("ntua-in-outline", false)

// Short caption, the equivalent of LaTeX's \caption[short]{long}. The first argument is printed
// in the list of figures (or tables), the second one under the figure itself:
//     caption: short-caption([Σύντομος τίτλος])[Μακρά περιγραφή με λεπτομέρειες @source.]
// Citations are removed from the lists anyway, so a short title never needs to carry them.
#let short-caption(short, long) = context if in-outline.get() { short } else { long }

// Page utilies

// Determines if the current page is a filler page
#let is-filler-page() = {
    let page-num = here().page()
    let starts = query(<filler-start>)
    let ends = query(<filler-end>)
    let n = calc.min(starts.len(), ends.len())
    for i in range(n) {
        let sp = starts.at(i).location().page()
        let ep = ends.at(i).location().page()
        if sp < page-num and page-num < ep {
            return true
        }
    }
    false
}

// Returns true if the current page contains a full-page divider (Part) or a dedication
#let is-special-page() = {
    let page-num = here().page()
    query(figure.where(kind: "part").or(figure.where(kind: "dedication"))).any(
        it => it.location().page() == page-num,
    )
}

// Unified check to determine if running headers and footers should be hidden
#let should-suppress-running-head() = {
    is-filler-page() or is-special-page()
}

// Performs a pagebreak and marks the resulting "skipped" pages as fillers.
// The break is weak by default: two consecutive calls (e.g. the one after a #part page and the
// one at the top of the following chapter file) would otherwise emit an extra page that carries
// a running head and a page number, because it lies outside the <filler-start>/<filler-end> pair.
#let blank-pagebreak(to: none, weak: true) = {
    [#metadata(none) <filler-start>]
    pagebreak(to: to, weak: weak)
    [#metadata(none) <filler-end>]
}

// Drop Cap (Historiated Initial)
#let histinit(body, gap: 3pt) = context {
    let fill = accent-color-state.get()
    dropcap(
        height: 2,
        gap: gap,
        hanging-indent: 0em,
        overhang: 0pt,
        fill: fill,
        body,
    )
}

// Loads pyrforos.svg as a white-tinted image (used on colored back-cover backgrounds)
#let _pyrforos-white(width: auto, height: 3cm) = image(
    bytes(read("pyrforos.svg").replace("#000000", "#ffffff")),
    format: "svg",
    width: width,
    height: height,
)

// Renders the back-cover bottom row: [QR code] [pyrforos centered] [ISBN barcode].
// Each slot is omitted gracefully when its source is not provided.
#let _back-cover-bottom-row(accent_color, github_url, isbn) = {
    let qr = if github_url != none {
        let mod-size = 2.5pt
        let badge-modules = 11
        let inset-modules = 1
        let badge-side = badge-modules * mod-size + 0.3pt
        let icon-side = (badge-modules - 2 * inset-modules) * mod-size
        box[
            #qrcode(
                github_url,
                fill: white,
                background-fill: none,
                module-size: mod-size,
                options: (ec-level: "h"),
            )
            #place(center + horizon, box(
                fill: accent_color,
                width: badge-side,
                height: badge-side,
                inset: inset-modules * mod-size,
                image(
                    "github-mark-white.svg",
                    format: "svg",
                    width: icon-side,
                    height: icon-side,
                    fit: "contain",
                ),
            ))
        ]
    } else { none }

    let barcode = if isbn != none {
        let isbn-digits = isbn.replace("-", "")
        ean(isbn-digits, options: (fg-color: white, bg-color: luma(0, 0%)), height: 2cm)
    } else { none }

    let pyrforos-white = _pyrforos-white()

    if qr != none or barcode != none {
        grid(
            columns: (1fr, auto, 1fr),
            align: horizon,
            if qr != none { align(left, qr) } else { [] },
            align(center, pyrforos-white),
            if barcode != none { align(right, barcode) } else { [] },
        )
    } else {
        align(center, pyrforos-white)
    }
}

// Renders the final pages of the thesis: a blank sheet followed by a colored back-cover
// (always ending on an even page)
#let back-cover(content: none, content_gap: 3pt, github_url: none, isbn: none) = context {
    let accent-color = accent-color-state.get()

    let bottom-row = _back-cover-bottom-row(accent-color, github_url, isbn)

    // Ensure we start the back sheet on a new odd page
    blank-pagebreak(to: "odd")

    // Create the "Inside Back Cover" (Odd page)
    page(header: none, footer: none)[#hide[.]]

    // Create the "Outside Back Cover" (Even page)
    page(
        margin: 1cm,
        fill: accent-color,
        header: none,
        footer: none,
    )[
        #block(
            width: 100%,
            height: 85%,
            fill: white,
            radius: 0.3cm,
            inset: 1.5em,
            clip: true,
        )[
            #if content != none { histinit(content, gap: content_gap) }
        ]
        #v(1fr)
        #bottom-row
    ]
}

// Content Selectors & Helpers

// Part: a level-0 structural division rendered as a full-page separator
#let part = figure.with(
    kind: "part",
    numbering: "I",
    supplement: "Μέρος",
    caption: [],
)

// Selector that matches both parts and headings
#let parts-and-headings = (
    figure.where(kind: "part", outlined: true).or(heading.where(outlined: true))
)

// Wraps content in a heading with numbering suppressed
#let numless(it) = {
    set heading(numbering: none)
    it
}

// Switches the document into appendix mode. Call once before the first appendix,
// then `set heading(numbering: "Α.1.1", supplement: [Παράρτημα])`. Resets the heading
// counter so the first appendix becomes «Παράρτημα Α».
#let start-appendices() = {
    in-appendix.update(true)
    counter(heading).update(0)
    // Reset the level-1-only counter too, so theorem/figure environments defined inside
    // appendices number from «Α» rather than continuing the chapter count.
    counter(heading.where(level: 1)).update(0)
}

// Convenience wrapper for code listing figures
//
// `font-size` scales the listing only, not its caption. `none` keeps the size the block
// inherits; a relative length such as 0.9em shrinks a listing that would otherwise
// overflow, an absolute one such as 8pt pins it.
#let code-figure(body, caption: [], label: none, font-size: none) = context {
    let ac = accent-color-state.get()

    // `clip` is what keeps the frame clean: codly lays out the listing as a table whose
    // zebra rows run the full width of the block, so without clipping they paint over the
    // border and the right edge comes out broken. Clipping also trims them to the rounded
    // corners. It does not stop the block from breaking: a clipped breakable block splits
    // across pages and each fragment gets its own clipped frame.
    let visual-body = block(
        width: 100%,
        breakable: true,
        clip: true,
        stroke: 0.75pt + ac,
        radius: 4pt,
        fill: white,
        grid(
            columns: (4pt, 1fr),
            rows: (auto,),
            grid.cell(fill: ac)[],
            // `local` and not a bare `codly(..)` call: the latter is a state update that
            // applies from this point to the end of the document, so the zebra stripes
            // would leak into every plain code block that follows the first listing.
            local(
                {
                    set par(first-line-indent: 0pt)
                    set align(left)
                    // 1em is the identity here: text sizes are relative to the parent em,
                    // so the unset case leaves the inherited size untouched.
                    set text(size: if font-size == none { 1em } else { font-size })
                    body
                },
                zebra-fill: luma(248),
            ),
        ),
    )

    let fig = figure(visual-body, kind: "Code", caption: caption)
    if label != none [ #fig #label ] else { fig }
}

// Styled text box with accent left bar, thin border, and light grey background
#let accent-box(body, color: none) = context {
    let c = if color != none { color } else { accent-color-state.get() }

    block(
        width: 100%,
        breakable: true,
        stroke: 0.75pt + c,
        radius: 4pt,
        clip: true,
        grid(
            columns: (4pt, 1fr),
            rows: (auto,),
            grid.cell(fill: c)[],
            grid.cell(fill: luma(248), inset: (left: 10pt, right: 10pt, top: 8pt, bottom: 8pt))[
                #body
            ],
        ),
    )
}

// Wrapper for algorithm (pseudocode) figures using the algorithmic package
#let algorithm-figure(
    caption: [],
    label: none,
    title: none,
    input: none,
    output: none,
    body,
) = context {
    let ac = accent-color-state.get()
    let sc = secondary-color-state.get()
    let sf = sans-font-state.get()
    let cf = code-font-state.get()

    let algo-content = {
        set text(font: cf)
        set par(first-line-indent: 0pt)
        set align(left)
        _algo-algorithm(
            vstroke: 0.5pt + ac.lighten(60%),
            line-numbers-format: n => text(fill: ac, [#n]),
            ..body,
        )
    }

    let rows = (grid.hline(stroke: 1.5pt + ac),)
    if title != none {
        let title-row = context {
            let ch = counter(heading).get().first()
            let n = counter(figure.where(kind: "Algorithm")).at(here()).first()
            align(start, text(font: sf, fill: sc, weight: "bold")[
                Αλγόριθμος #numbering("1.1", ch, n). #title
            ])
        }
        rows.push(title-row)
        rows.push(grid.hline(stroke: 0.5pt + ac))
    }
    if input != none {
        rows.push(align(start, text(font: cf)[#text(fill: ac, weight: "bold")[Input:] #text(
                style: "italic",
                input,
            )]))
    }
    if output != none {
        rows.push(align(start, text(font: cf)[#text(fill: ac, weight: "bold")[Output:] #text(
                style: "italic",
                output,
            )]))
    }
    rows.push(algo-content)
    rows.push(grid.hline(stroke: 1.5pt + ac))

    let visual-body = block(
        breakable: true,
        grid(columns: 1, stroke: none, inset: (x: 5pt, y: 4pt), ..rows),
    )

    let fig = figure(visual-body, kind: "Algorithm", caption: caption)
    if label != none [ #fig #label ] else { fig }
}

// Abstract & Keywords

// Shared layout for the Περίληψη and Abstract pages
#let _abstract-layout(content, keywords, keywords-heading, histinit_gap: 3pt) = context {
    let keywords_color = accent-color-state.get()
    let sans-font = sans-font-state.get()
    grid(
        columns: (0cm, 1fr, 0cm),
        fill: none,
        column-gutter: 2pt,
        [], histinit(content, gap: histinit_gap), [],
        [],
        stack(
            dir: ttb,
            v(2em),
            text(14pt, weight: "bold", fill: keywords_color, font: sans-font, keywords-heading),
            v(1.5em),
            keywords,
        ),
        v(1em),

        [],
    )
}

// Greek abstract page with "Λέξεις Κλειδιά" heading
#let perilipsi(content, keywords, histinit_gap: 3pt) = {
    perilipsi-content-state.update(content)
    perilipsi-gap-state.update(histinit_gap)
    _abstract-layout(content, keywords, "Λέξεις Κλειδιά", histinit_gap: histinit_gap)
}

// English abstract page with "Keywords" heading.
#let abstract(content, keywords, histinit_gap: 3pt) = _abstract-layout(
    content,
    keywords,
    "Keywords",
    histinit_gap: histinit_gap,
)

// Dedication

// Renders a right-aligned dedication on its own odd page spread
#let dedication(it) = {
    blank-pagebreak(to: "odd")
    align(right, block(height: 100%, stack(
        dir: ttb,
        v(1fr),
        figure(kind: "dedication", text(13pt, style: "italic", it), supplement: []),
        v(1fr),
    )))
    blank-pagebreak(to: "odd")
}

// Reusable Page Components

// pyrforos logo + university/school/division
#let ntua-header(logo-path, division, sans_font) = {
    align(center)[
        #grid(
            columns: 2,
            align: horizon,
            column-gutter: 1em,
            image(logo-path, width: 2.5cm),
            grid(
                rows: 3,
                align: left,
                row-gutter: 12pt,
                upper(text(font: sans_font, weight: "bold", size: 19pt)[Εθνικο Μετσοβιο
                    Πολυτεχνειο]),
                upper(text(font: sans_font, size: 12pt)[Σχολη Ηλεκτρολογων Μηχανικων και Μηχανικων
                    Υπολογιστων]),
                upper(text(font: sans_font, size: 12pt, division)),
            ),
        )
    ]
}

// Supervisor and optional co-supervisor
#let supervisor-block(
    accent_color,
    supervisor_label,
    supervisor,
    supervisor_title,
    co_supervisor_label,
    co_supervisor,
    co_supervisor_title,
) = {
    grid(
        columns: (auto, 1fr, auto),
        rows: 1,
        grid(
            rows: 2,
            columns: (auto, auto),
            column-gutter: 11pt,
            row-gutter: 11pt,
            align: left,
            text(weight: "bold", fill: accent_color, supervisor_label + ":"), supervisor,

            [], supervisor_title,
        ),
        [],
        if co_supervisor_label not in (none, "") and co_supervisor not in (none, "") and co_supervisor_title not in (none, "") [
            #grid(
                rows: 2,
                columns: (auto, auto),
                column-gutter: 11pt,
                row-gutter: 11pt,
                align: left,
                text(weight: "bold", fill: accent_color, co_supervisor_label + ":"), co_supervisor,

                [], co_supervisor_title,
            )
        ],
    )
}

// Title + subtitle + "ΔΙΠΛΩΜΑΤΙΚΗ ΕΡΓΑΣΙΑ" + author name block
#let diploma-block(
    accent_color,
    sans_font,
    title,
    subtitle,
    definite_article,
    author_uppercase,
) = {
    set text(font: sans_font)
    grid(
        rows: 3,
        row-gutter: 1.5em,
        text(size: 16pt, weight: "bold", fill: accent_color, title),
        text(size: 13pt, style: "italic", fill: accent_color, subtitle),
        line(length: 25%, stroke: accent_color),
    )
    v(2.5em)
    grid(
        rows: 3,
        row-gutter: 1.5em,
        upper(text(size: 14pt, fill: accent_color)[Διπλωματικη Εργασια]),
        text(size: 14pt, style: "italic", fill: accent_color, definite_article),
        upper(text(
            size: 14pt,
            weight: "bold",
            fill: accent_color,
            author_uppercase,
        )),
    )
}

// Theorem-like Environments (IEEE style)
#let _ntua-thm(kind, suppl, name, body) = figure(
    body,
    kind: kind,
    supplement: context text(fill: accent-color-state.get(), weight: "bold", suppl),
    caption: if name != none { name } else { none },
    outlined: false,
    numbering: num => context text(
        fill: accent-color-state.get(),
        weight: "bold",
        numbering(
            if in-appendix.get() { "Α.1" } else { "1.1" },
            counter(heading.where(level: 1)).get().first(),
            num,
        ),
    ),
)

#let theorem(name: none, body) = _ntua-thm("ntua-thm", [Θεώρημα], name, body)
#let lemma(name: none, body) = _ntua-thm("ntua-lem", [Λήμμα], name, body)
#let corollary(name: none, body) = _ntua-thm("ntua-cor", [Πόρισμα], name, body)
#let proposition(name: none, body) = _ntua-thm("ntua-prop", [Πρόταση], name, body)
#let definition(name: none, body) = _ntua-thm("ntua-def", [Ορισμός], name, body)
#let remark(name: none, body) = _ntua-thm("ntua-rem", [Παρατήρηση], name, body)
#let example(name: none, body) = _ntua-thm("ntua-ex", [Παράδειγμα], name, body)

// Unnumbered proof block ending with a QED square
#let proof(name: none, body) = context {
    let ac = accent-color-state.get()
    set align(left)
    set par(first-line-indent: 0pt)
    block(
        width: 100%,
        above: 2em,
        below: 2em,
        {
            if name != none {
                text(fill: ac, weight: "bold")[Απόδειξη (#name).]
            } else {
                text(fill: ac, weight: "bold")[Απόδειξη.]
            }
            [ ]
            body
            h(1fr)
            sym.square.filled
        },
    )
}

// Unnumbered result block (like proof but with colon, no QED square)
#let result(name: none, body) = context {
    let ac = accent-color-state.get()
    set align(left)
    set par(first-line-indent: 0pt)
    block(
        width: 100%,
        above: 2em,
        below: 2em,
        {
            if name != none {
                text(fill: ac, weight: "bold")[Αποτέλεσμα (#name):]
            } else {
                text(fill: ac, weight: "bold")[Αποτέλεσμα:]
            }
            [ ]
            body
        },
    )
}

#let hypothesis(name: none, body) = _ntua-thm("ntua-hyp", [Υπόθεση], name, body)

// Book Cover Spread

// Generates a single-page book cover spread: back cover + spine + front cover
#let cover-wrap(
    // Front cover
    title: [Τίτλος Διπλωματικής Εργασίας],
    subtitle: [Υπότιτλος],
    thesis_image: none,
    division: "Τομεας Τεχνολογιας Πληροφορικης και Υπολογιστων",
    author_uppercase: "ΟΝΟΜΑΤΕΠΩΝΥΜΟ ΦΟΙΤΗΤΗ/ΦΟΙΤΗΤΡΙΑΣ",
    definite_article: "του/της/των",
    supervisor_label: "Επιβλέπων",
    supervisor: "Ονοματεπώνυμο Επιβλέποντα",
    supervisor_title: "Καθηγητής Ε.Μ.Π.",
    co_supervisor_label: "",
    co_supervisor: "",
    co_supervisor_title: "",
    pub_place_date: "Αθήνα, Μήνας 20ΧΧ",

    // Back cover
    content: none,
    content_gap: 3pt,
    github_url: none,
    isbn: none,

    // Appearance
    accent_color: rgb("#003262"),
    secondary_color: none,
    serif_font: "Libertinus Serif",
    sans_font: "Libertinus Sans",
    font_size: 11pt,
    spine_title_font_size: auto,
    spine_label_font_size: auto,

    // Canvas geometry
    page_count: 200,
    page_width: auto,
    page_height: auto,
    paper_thickness_per_page: 0.1mm,
    spine_safe_margin: 2mm,

    // Body-only fields passed via ..config, accepted here so ..config works for both functions
    extra_syntaxes: none,
    extra_languages: none,
    author: none,
    examination_date: none,
    first_examiner: none,
    first_examiner_title: none,
    second_examiner: none,
    second_examiner_title: none,
    third_examiner: none,
    third_examiner_title: none,
    copyright_year: none,
    code_font: none,
    paper: none,
    margin_top: none,
    margin_bottom: none,
    margin_inside: none,
    margin_outside: none,

    _body, // intentionally discarded (cover is fully self-contained)
) = {
    let paper-sizes = (
        "a4": (width: 210mm, height: 297mm),
        "a3": (width: 297mm, height: 420mm),
        "a5": (width: 148mm, height: 210mm),
        "us-letter": (width: 215.9mm, height: 279.4mm),
        "us-legal": (width: 215.9mm, height: 355.6mm),
    )
    let _dims = paper-sizes.at(paper, default: (width: 210mm, height: 297mm))
    let page_width = if page_width == auto { _dims.width } else { page_width }
    let page_height = if page_height == auto { _dims.height } else { page_height }

    let bleed = 3mm
    let spine_color = if secondary_color != none { secondary_color } else {
        accent_color.darken(20%)
    }
    let spine_width = page_count * paper_thickness_per_page
    let canvas_w = bleed + page_width + spine_width + page_width + bleed
    let canvas_h = bleed + page_height + bleed

    // Trim-line coordinates
    let x_back_left = bleed
    let x_spine_left = bleed + page_width
    let x_spine_right = bleed + page_width + spine_width
    let x_front_right = bleed + page_width + spine_width + page_width
    let y_top = bleed
    let y_bottom = bleed + page_height

    // Front cover
    let front-cover-content = {
        set text(lang: "el", font: serif_font)
        block(width: page_width, height: page_height, clip: true)[
            #place(top + left, rect(width: 100%, height: 100%, fill: accent_color))
            #place(top + left, dx: 1cm, dy: 1cm, rect(
                width: 100% - 2cm,
                height: 100% - 2cm,
                fill: white,
                radius: 0.3cm,
            ))

            // Content inside 2cm margins
            #pad(2cm)[
                #ntua-header("pyrforos.svg", division, sans_font)
                #block(width: 100%, height: 1fr, above: 2cm)[
                    #set align(center)
                    #stack(
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
                        thesis_image,
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
                    )
                ]
            ]
        ]
    }

    // Back cover

    let bottom-row = _back-cover-bottom-row(accent_color, github_url, isbn)

    let back-cover-content = {
        set text(lang: "el", font: serif_font)
        block(width: page_width, height: page_height, fill: accent_color, clip: true)[
            #pad(1cm)[
                #block(
                    width: 100%,
                    height: 85%,
                    fill: white,
                    radius: 0.3cm,
                    inset: 1.5em,
                    clip: true,
                )[
                    #set text(size: font_size)
                    #set par(
                        justify: true,
                        first-line-indent: 0pt,
                        leading: 1em,
                        spacing: 2em,
                    )
                    #if content != none {
                        dropcap(
                            height: 2,
                            gap: content_gap,
                            hanging-indent: 0em,
                            overhang: 0pt,
                            fill: accent_color,
                            content,
                        )
                    }
                ]
                #v(1fr)
                #bottom-row
            ]
        ]
    }

    // Canvas

    page(
        width: canvas_w,
        height: canvas_h,
        margin: 0pt,
        fill: accent_color,
        header: none,
        footer: none,
    )[
        // Cover panels (placed at trim-line positions, no bleed extension needed)
        #place(top + left, dx: x_back_left, dy: y_top, back-cover-content)
        #place(top + left, dx: x_spine_right, dy: y_top, front-cover-content)

        // Spine column
        #place(top + left, dx: x_spine_left, dy: 0pt, block(
            width: spine_width,
            height: canvas_h,
            fill: spine_color,
        ))

        #let spine_text_w = spine_width - 2 * spine_safe_margin
        #let spine_top_margin = 1cm
        #let pyrforos_size = calc.min(spine_text_w, 2cm)
        #let pyrforos_gap = 5mm
        #let rotated_h = (y_bottom - y_top) - 2 * spine_top_margin - pyrforos_gap - pyrforos_size
        #let spine_title_font_size_ = if spine_title_font_size == auto {
            calc.min(calc.max(spine_text_w * 0.60, 6pt), 16pt)
        } else { spine_title_font_size }
        #let spine_label_font_size_ = if spine_label_font_size == auto {
            calc.min(calc.max(spine_text_w * 0.50, 6pt), 14pt)
        } else { spine_label_font_size }

        #if spine_text_w >= 4mm {
            place(
                top + left,
                dx: x_spine_left + spine_safe_margin,
                dy: y_top + spine_top_margin,
                box(width: spine_text_w, height: rotated_h, clip: true, place(
                    top + left,
                    dx: spine_text_w,
                    rotate(90deg, origin: top + left, box(
                        width: rotated_h,
                        height: spine_text_w,
                        grid(
                            columns: (1fr, 5mm, auto, 5mm, auto),
                            rows: (auto,),
                            align: center + horizon,
                            text(
                                fill: white,
                                font: sans_font,
                                size: spine_title_font_size_,
                                title,
                            ),
                            [],
                            block(width: 0.5pt, height: spine_text_w, fill: white),
                            [],
                            text(
                                fill: white,
                                font: sans_font,
                                size: spine_label_font_size_,
                                tracking: 1pt,
                                "ΔΙΠΛΩΜΑΤΙΚΗ ΕΡΓΑΣΙΑ",
                            ),
                        ),
                    )),
                )),
            )

            place(
                top + left,
                dx: x_spine_left + spine_safe_margin,
                dy: y_bottom - spine_top_margin - pyrforos_size,
                box(
                    width: spine_text_w,
                    height: pyrforos_size,
                    align(center + horizon, _pyrforos-white(
                        width: pyrforos_size,
                        height: pyrforos_size,
                    )),
                ),
            )
        }

        // Corner crop marks
        #let mk = stroke(thickness: 0.5pt, paint: white)
        #let ml = 2.5mm
        #place(top + left, dx: x_back_left - ml, dy: y_top, line(length: ml, stroke: mk))
        #place(top + left, dx: x_back_left, dy: y_top - ml, line(
            angle: 90deg,
            length: ml,
            stroke: mk,
        ))
        #place(top + left, dx: x_front_right, dy: y_top, line(length: ml, stroke: mk))
        #place(top + left, dx: x_front_right, dy: y_top - ml, line(
            angle: 90deg,
            length: ml,
            stroke: mk,
        ))
        #place(top + left, dx: x_back_left - ml, dy: y_bottom, line(length: ml, stroke: mk))
        #place(top + left, dx: x_back_left, dy: y_bottom, line(
            angle: 90deg,
            length: ml,
            stroke: mk,
        ))
        #place(top + left, dx: x_front_right, dy: y_bottom, line(length: ml, stroke: mk))
        #place(top + left, dx: x_front_right, dy: y_bottom, line(
            angle: 90deg,
            length: ml,
            stroke: mk,
        ))

        // Spine folding guides
        #place(top + left, dx: x_spine_left, dy: y_top - ml, line(
            angle: 90deg,
            length: ml,
            stroke: mk,
        ))
        #place(top + left, dx: x_spine_left - ml, dy: y_top, line(length: ml, stroke: mk))
        #place(top + left, dx: x_spine_right, dy: y_top - ml, line(
            angle: 90deg,
            length: ml,
            stroke: mk,
        ))
        #place(top + left, dx: x_spine_right, dy: y_top, line(length: ml, stroke: mk))
        #place(top + left, dx: x_spine_left, dy: y_bottom, line(
            angle: 90deg,
            length: ml,
            stroke: mk,
        ))
        #place(top + left, dx: x_spine_left - ml, dy: y_bottom, line(length: ml, stroke: mk))
        #place(top + left, dx: x_spine_right, dy: y_bottom, line(
            angle: 90deg,
            length: ml,
            stroke: mk,
        ))
        #place(top + left, dx: x_spine_right, dy: y_bottom, line(length: ml, stroke: mk))
    ]
}

// DECLINED CROSS-REFERENCES (Greek grammar)
//
// Typst always renders a reference supplement in the nominative, which is
// ungrammatical in Greek after a preposition or in a genitive construction:
// «στον Πίνακας 9.7» instead of «στον Πίνακα 9.7». These helpers resolve the
// referenced element, decline its supplement, and compute the chapter-relative
// number at the element's own location (a plain `@label` would read the chapter
// counter at the reference site instead, which is wrong across chapters).
//
//   @def-object          ->  «Ορισμός 6.9»   nominative, plain reference
//   #refg(<def-object>)  ->  «Ορισμού 6.9»   genitive
//   #refa(<def-object>)  ->  «Ορισμό 6.9»    accusative
#let _ntua-declensions = (
    "ntua-thm": ("Θεωρήματος", "Θεώρημα"),
    "ntua-lem": ("Λήμματος", "Λήμμα"),
    "ntua-cor": ("Πορίσματος", "Πόρισμα"),
    "ntua-prop": ("Πρότασης", "Πρόταση"),
    "ntua-def": ("Ορισμού", "Ορισμό"),
    "ntua-rem": ("Παρατήρησης", "Παρατήρηση"),
    "ntua-ex": ("Παραδείγματος", "Παράδειγμα"),
    "ntua-hyp": ("Υπόθεσης", "Υπόθεση"),
    "Code": ("Κώδικα", "Κώδικα"),
    "Algorithm": ("Αλγορίθμου", "Αλγόριθμο"),
)

#let _ntua-declined(kind, idx) = {
    if kind == image { ("Σχήματος", "Σχήμα").at(idx) } else if kind == table {
        ("Πίνακα", "Πίνακα").at(idx)
    } else if type(kind) == str and kind in _ntua-declensions {
        _ntua-declensions.at(kind).at(idx)
    } else { none }
}

#let _ntua-xref(target, idx) = context {
    let els = query(target)
    if els.len() == 0 {
        text(fill: red)[#target]
    } else {
        let el = els.first()
        let loc = el.location()
        let word = if el.func() == math.equation {
            ("Εξίσωσης", "Εξίσωση").at(idx)
        } else { _ntua-declined(el.kind, idx) }

        if word == none {
            ref(target)
        } else {
            let is-thm = type(el.kind) == str and el.kind.starts-with("ntua-")
            let col = if is-thm {
                accent-color-state.get()
            } else { secondary-color-state.get() }
            let num = if el.func() == math.equation {
                numbering(
                    if in-appendix.at(loc) { "(Α.1)" } else { "(1.1)" },
                    counter(heading).at(loc).first(),
                    counter(math.equation).at(loc).first(),
                )
            } else {
                numbering(
                    if in-appendix.at(loc) { "Α.1" } else { "1.1" },
                    counter(heading).at(loc).first(),
                    counter(figure.where(kind: el.kind)).at(loc).first(),
                )
            }
            link(loc, text(fill: col, weight: "bold", [#word #num]))
        }
    }
}

// Genitive reference, e.g. «του Ορισμού 6.9»
#let refg(target) = _ntua-xref(target, 0)

// Accusative reference, e.g. «κατά τον Ορισμό 6.9»
#let refa(target) = _ntua-xref(target, 1)
