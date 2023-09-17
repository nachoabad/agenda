import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "showable", "hideable" ]

  showTargets() {
    this.showableTargets.forEach(el => {
      el.hidden = false
    });

    this.hideableTargets.forEach(el => {
      el.hidden = true
    });
  }
}