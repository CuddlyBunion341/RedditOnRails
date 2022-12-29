import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["wrapper", "tabs", "uploadList"];

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

	upload(event) {
		const files = event.target.files;

		for (let i = 0; i < files.length; i++) {
			let file = files.item(i);

			const reader = new FileReader();

			reader.onload = (e) => {
				const image = document.createElement("img");
				image.src = e.target.result;
				this.uploadListTarget.appendChild(image);
			};

			reader.readAsDataURL(file);
		}
	}
}
