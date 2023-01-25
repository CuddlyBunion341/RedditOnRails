import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="user"
export default class extends Controller {
	static targets = ["avatar", "avatarWrapper", "avatarInput"];

	connect() {}

	updateAvatar(event) {
		const file = event.target.files[0];
		const reader = new FileReader();

		reader.onload = (e) => {
			this.avatarTarget.src = e.target.result;
		};

		reader.readAsDataURL(file);
	}
}
