// Inspired by stimulus-flatpickr
import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"
import { english } from "flatpickr/dist/l10n/default"
import { parse, isMatch } from "date-fns"

const dateConfig = {
  parseDate: (datestr, _format) => {
    let pattern
    if (isMatch(datestr, "dd-MM-yyyy")) {
      pattern = "dd-MM-yyyy"
    } else if (isMatch(datestr, "dd/MM/yyyy")) {
      pattern = "dd/MM/yyyy"
    } else if (isMatch(datestr, "dd MMM yyyy")) {
      pattern = "dd MMM yyyy"
    } else if (isMatch(datestr, "yyyy-MM-dd")) {
      pattern = "yyyy-MM-dd"
    } else {
      pattern = "dd-MMM-yyyy"
    }
    return parse(datestr, pattern, new Date())
  },
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
        // Alternative and cleaner approach would be to set our own `config.parseDate()` function
        // which has custom tokenRegex that fit our needs best.
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
}

const timeConfig = {
  enableTime: true,
  noCalendar: true,
  time_24hr: true,
  dateFormat: "H:i",
}

const dateWithTimeConfig = {
  parseDate: (datestr, _format) => {
    let pattern
    if (isMatch(datestr, "dd-MM-yyyy H:m")) {
      pattern = "dd-MM-yyyy H:m"
    } else if (isMatch(datestr, "dd/MM/yyyy H:m")) {
      pattern = "dd/MM/yyyy H:m"
    } else if (isMatch(datestr, "dd MMM yyyy H:m")) {
      pattern = "dd MMM yyyy H:m"
    } else if (isMatch(datestr, "yyyy-MM-dd H:m")) {
      pattern = "yyyy-MM-dd H:m"
    } else {
      pattern = "dd-MMM-yyyy H:m"
    }
    return parse(datestr, pattern, new Date())
  },
  enableTime: true,
  dateFormat: "d-M-Y H:i",
}

export default class extends Controller {
  static values = {
    timeOnly: Boolean,
    dateWithTime: Boolean,
  }

  connect() {
    let config

    if (this.dateWithTimeValue) {
      config = dateWithTimeConfig
    } else if (this.timeOnlyValue) {
      config = timeConfig
    } else {
      config = dateConfig
    }

    config["maxDate"] = this.element.dataset.flatpickrMaxDate
    config["minDate"] = this.element.dataset.flatpickrMinDate
    config["allowInput"] = true

    this.fp = flatpickr(this.element, config)
  }

  disconnect() {
    this.fp.destroy()
  }
}
