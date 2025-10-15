import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["option"]

  connect() {
    this.updateSelection()
  }

  select(event) {
    // Remove selection from all options
    this.optionTargets.forEach(option => {
      option.classList.remove("border-blue-500", "bg-blue-50")
      option.classList.add("border-gray-300")
      
      // Hide checkmark
      const checkmark = option.querySelector(".checkmark")
      const circle = option.querySelector(".circle")
      if (checkmark) checkmark.classList.add("hidden")
      if (circle) circle.classList.remove("hidden")
    })

    // Add selection to clicked option
    const selectedOption = event.currentTarget
    selectedOption.classList.remove("border-gray-300")
    selectedOption.classList.add("border-blue-500", "bg-blue-50")
    
    // Show checkmark
    const checkmark = selectedOption.querySelector(".checkmark")
    const circle = selectedOption.querySelector(".circle")
    if (checkmark) checkmark.classList.remove("hidden")
    if (circle) circle.classList.add("hidden")
  }

  updateSelection() {
    this.optionTargets.forEach(option => {
      const radio = option.querySelector("input[type='radio']")
      if (radio && radio.checked) {
        option.classList.remove("border-gray-300")
        option.classList.add("border-blue-500", "bg-blue-50")
        
        const checkmark = option.querySelector(".checkmark")
        const circle = option.querySelector(".circle")
        if (checkmark) checkmark.classList.remove("hidden")
        if (circle) circle.classList.add("hidden")
      }
    })
  }
}
