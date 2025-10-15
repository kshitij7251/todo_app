import { Controller } from "@hotwired/stimulus"

// Manages the items per page selector in the tasks list
export default class extends Controller {
  changeItemsPerPage(event) {
    const searchParams = new URLSearchParams(window.location.search)
    searchParams.set('items', event.target.value)
    window.location.search = searchParams.toString()
  }
}