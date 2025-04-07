#import "@preview/oxifmt:0.2.1": strfmt

#let data = yaml("metadata.yml")

#let template(doc) = [
  #set page(
    header: context {
      if counter(page).get().first() > 1 [
        #data.studentEmail
        #h(1fr)
        #data.courseCode
        #h(1fr)
        #data.courseName
      ]
    },
    footer: context {
      if counter(page).get().first() > 1 [
        #h(1fr)
        #context counter(page).display("1")
        #h(1fr)
      ] else [#context counter(page).display("1")]
    }
  )

  #set text(font: "Segoe UI", size: 11pt)

  #show heading.where(): it => {
    text(weight: "semibold", it)
  }

  #set align(center)

  #show link: underline

  #show outline.entry.where(level: 1): it => {
    v(12pt, weak: true)
    text(it)
  }

  #show figure: set block(breakable: true)

  #doc
]
