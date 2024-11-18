
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["stockCard"]
  static values = { currentIndex: Number }

  connect() {
    this.currentIndexValue = 0
  }

  next() {
    this.currentIndexValue = (this.currentIndexValue + 1) % 4
  }

  previous() {
    this.currentIndexValue = (this.currentIndexValue - 1 + 4) % 4
  }
}