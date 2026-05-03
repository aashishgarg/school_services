import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  mark() {
    this.element.closest("form")?.querySelectorAll("select[name^='statuses']")?.forEach((sel) => {
      sel.value = "present"
    })
  }
}
