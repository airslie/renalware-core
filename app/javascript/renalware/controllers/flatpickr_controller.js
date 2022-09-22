// Inspired by stimulus-flatpickr
import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"
import { english } from "flatpickr/dist/l10n/default"

export default class extends Controller {
  initialize() {
    this.config = {
      locale: {
        firstDayOfWeek: 1,
        months: {
          ...english.months,
          shorthand: [
            ...english.months.shorthand,
            // Allow users to input numbers in date field instead of Jan, Feb
            // Because we can't directly change `tokenRegex`, add the numbers to the
            // month shorthand locale, so they'll end up in the regexp string
            // See https://github.com/flatpickr/flatpickr/blob/614568f20daff9fdef906e8451876d8918c68d3c/src/index.ts#L2160
            "01",
            "02",
            "03",
            "04",
            "05",
            "06",
            "07",
            "08",
            "09",
            "10",
            "11",
            "12",
          ],
        },
      },
      dateFormat: "d-M-Y",
      allowInput: true,
    }
  }

  connect() {
    this.fp = flatpickr(this.element, {
      ...this.config,
    })
  }

  disconnect() {
    this.fp.destroy()
  }
}
