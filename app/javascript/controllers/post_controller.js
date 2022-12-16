import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["wrapper", "score", "upvote", "downvote"];

	connect() {
		console.log("Hello, Stimulus!", this.scoreTarget);
	}

	upvote() {
		fetch("/upvote/1", {
			method: "POST",
			headers: {
				"Content-Type": "application/json",
				"X-CSRF-Token": document.querySelector(
					'meta[name="csrf-token"]'
				).content,
			},
		})
			.then((response) => response.json())
			.then((data) => (this.wrapperTarget.outerHTML = data.html))
			.catch((error) => {
				console.error("Error:", error);
			});
	}

	downvote() {}
}
