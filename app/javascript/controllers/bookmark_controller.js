import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="bookmark"
export default class extends Controller {
  static values = { tripId: Number }

  connect() {
    const items = this.element.querySelectorAll("li")

    items.forEach((li) => {
      if (li.querySelector("strong")) {
        li.insertAdjacentHTML(
          "afterbegin",
          '<button type="button" class="bookmark-star" label="favori" data-action="click->bookmark#save">☆</button>'
        )
      }
    })
  }

  save(event) {
    const button = event.currentTarget
    const li = button.closest("li")
    const name = li.querySelector("strong").innerText
    const description = li.innerText.split(":").slice(1).join(":").trim()

    fetch(`/trips/${this.tripIdValue}/bookmarks`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",                                         // on envoie du JSON
        "Accept": "application/json",                                               // on attend du JSON en retour
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content   // sinon Rails refuse
      },
      body: JSON.stringify({ bookmark: { name: name, description: description } })  // la forme attendue par bookmark_params
    })
      // le retour visuel
      .then((response) => {
        if (response.ok) {
          button.innerText = "★"
          button.disabled = true
        }
      })
  }
}
