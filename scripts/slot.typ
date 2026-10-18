// One print a verification film shows, letterboxed to the aspect of its surface in the footage, its long side 10in:
//   typst compile --root . --input place=/place/place.typ --input print=sheet --input aspect=1.45 --ppi 300 scripts/slot.typ out.png
// Under scripts/, so the placed build never renders it; `nix run .#render` does.
#import "/typ/__main__.typ": address, brands, lang
#import "/typ/brand/lib.typ": card-back, card-front, lockup, poster-face
#import "/typ/documents/facture.typ": facture-face
#import "/typ/utils.typ": recent-date

#let brand = brands.first()
#let door = (descriptor: brand.descriptor, street: address.street, city: address.city)
#let print = sys.inputs.print
#let aspect = float(sys.inputs.aspect)

// the drawing at its own size, and what fills the page around it: its own ground
#let (drawing, ground) = if print in ("sheet", "car_sign") {
  (poster-face(brand, lang, false, door: door), white)
} else if print in ("sign", "screen") {
  (poster-face(brand, lang, true, door: door), brand.primary)
} else if print == "card_front" {
  (card-front(brand, lang, door), brand.primary)
} else if print == "card_back" {
  (card-back(brand, lang, door), white)
} else if print == "logo" {
  (
    {
      set text(font: "Liberation Sans")
      pad(40pt, lockup(brand, 90pt, brand.primary, stacked: aspect < 1.5))
    },
    white,
  )
} else if print in ("address", "house_number") {
  // offset: house numbers along the listing's street from its own, for a neighbour's
  let m = address.street.match(regex("^(\d+)(.*)$"))
  assert(m != none, message: "the listing's street starts with no house number: " + address.street)
  let number = int(m.captures.first()) + int(sys.inputs.offset)
  assert(number > 0, message: "offset " + sys.inputs.offset + " walks off the start of the street")
  let label = if print == "address" { str(number) + m.captures.last() } else if aspect < 1 { stack(dir: ttb, spacing: 4pt, ..str(number).clusters()) } else { str(number) }
  (pad(x: 18pt, y: 6pt, text(font: "Liberation Sans", weight: "bold", size: 60pt, fill: luma(20), top-edge: "cap-height", bottom-edge: "descender", label)), white)
} else if print == "invoice" {
  (facture-face(lang: lang, date: recent-date(seed: 1)), white)
} else {
  panic(print + " is no print verif_tools draws")
}

#let long = 254mm
#let (width, height) = if aspect >= 1 { (long, long / aspect) } else { (long * aspect, long) }
#set page(width: width, height: height, margin: 0pt, fill: ground)
#context {
  let size = measure(drawing)
  place(center + horizon, scale(calc.min(width / size.width, height / size.height) * 100%, reflow: true, drawing))
}
