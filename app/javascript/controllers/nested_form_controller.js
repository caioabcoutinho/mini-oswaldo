import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  
  static targets = ["links", "container", "template"]

  add(event) {
    event.preventDefault()

    let fields = this.templateTarget.dataset.fields

    let new_id = new Date().getTime()
    let new_fields = fields.replace(new RegExp(this.templateTarget.dataset.id, "g"), new_id)

    this.containerTarget.insertAdjacentHTML('beforeend', new_fields)
  }

  remove(event) {
    event.preventDefault()

    let wrapper = event.target.closest('.nested-fields')

    if (wrapper) {
      let destroyField = wrapper.querySelector("input[name*='_destroy']")
      if (destroyField) {
        destroyField.value = '1'
        wrapper.style.display = 'none'
      } else {
        wrapper.remove()
      }
    }
  }
}

