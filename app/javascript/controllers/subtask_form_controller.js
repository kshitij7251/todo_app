import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]

  connect() {
    console.log("Subtask form controller connected")
  }

  toggle() {
    console.log("Toggle clicked")
    this.formTarget.classList.toggle("hidden")
  }

  cancel() {
    console.log("Cancel clicked")
    this.formTarget.classList.add("hidden")
    // Clear form fields
    const inputs = this.formTarget.querySelectorAll("input, textarea")
    inputs.forEach(input => input.value = "")
  }
}
