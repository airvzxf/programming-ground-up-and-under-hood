--- typst-layout.lua – place the table of contents in the PDF edition.
---
--- A `::: {#toc}` div in book.md marks where the table of contents goes in
--- the PDF (after the copyright page). HTML and ePUB place their own
--- navigation, so the div is removed there.

function Div(el)
  if el.identifier == 'toc' then
    if FORMAT == 'typst' then
      return pandoc.RawBlock('typst', '#book-outline()')
    end
    return {}
  end
end
