import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["wrapper", "tabs"];

	connect() {}

	showTab(event) {
		const tab = event.target.dataset.tab;

		this.wrapperTarget.querySelectorAll(".tab").forEach((tab) => {
			tab.classList.add("hidden");
		});

		this.wrapperTarget
			.querySelector(`#tab${tab}`)
			.classList.remove("hidden");
	}
}
