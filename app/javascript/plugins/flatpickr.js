import flatpickr from "flatpickr";
import { French } from "flatpickr/dist/l10n/fr.js";
import "flatpickr/dist/flatpickr.min.css";

flatpickr(".datepicker", {
  "locale": French,
  altInput: true
});

export { flatpickr };
