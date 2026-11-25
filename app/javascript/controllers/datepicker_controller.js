import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

// Connects to data-controller="datepicker"
export default class extends Controller {
  static targets = ["range", "startDate", "endDate"]

  connect() {
    flatpickr(this.rangeTarget, {
      mode: "range",       // on choisit une période : 2 dates
      dateFormat: "d-m-Y",  // format 01-12-2026
      onChange: (selectedDates, dateStr, instance) => {
        if (selectedDates.length === 2) {
          this.startDateTarget.value = instance.formatDate(selectedDates[0], "Y-m-d")
          this.endDateTarget.value = instance.formatDate(selectedDates[1], "Y-m-d")
        }
      }
    })
  }
}
