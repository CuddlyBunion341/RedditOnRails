import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["wrapper", "tabs"];

	connect() {}

	showTab(event) {
		event.preventDefault();
		const tab = event.target.dataset.tab;

		this.tabsTarget.querySelectorAll("button").forEach((button) => {
			button.classList.remove("active");
		});
		event.target.classList.add("active");
	}
}
