// One place. `typ/__main__.typ` is handed this file and checks its shape.
// Named `<business>_-_<city>_-_<branch>`, since one business gets one per door.

// The business is a file of its own under `brands/`, since it outlives this door
// and the next one it takes.
#import "/examples/brands/aquafix.typ": brand as _brand

// `name` is what the plate on the building calls the place; the documents quote
// street and city as the one line a notary would write.
#let address = (
  name: "", // no copropriété registers this number
  street: "64 rue Saint-Alyre",
  city: "63000 Clermont-Ferrand",
)


// What this door adds to the brand. For "Aquafix Plombier Chauffagiste - Lyon,
// Nord", the brand is named "Aquafix" and `descriptor` is everything after it —
// the trade is the same at every door, the territory is this one's.
#let brands = (
  _brand
    + (
      descriptor: "Plombier Chauffagiste - Clermont-Ferrand",
      phone: "+33 7 57 69 12 38",
    ),
)

#let nearby = (
  // The nearest doors that carry a name of their own, whatever they sell. One
  // plaque each. A "\n" is where that plaque breaks its line, and what follows is
  // set smaller — where the trade suffix sits on a real one.
  other_businesses: (
    "Coiff & Look\nCoiffeur", // 44m
    // the 55m door is a Carrefour Market, which a reader knows without walking to it
    "Pharmacie Sainte-Claire\nPharmacie", // 67m
    "Mappa\nAssurance", // 71m
  ),
  // Plates for the doors next door, drawn like ours, one each.
  neighbours: (
    (name: "Henri Pourrat", street: "71 rue Saint-Alyre"), // 6m
  ),
)
