import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["wrapper", "score", "upvote", "downvote"];

	connect() {
		this.postID = this.wrapperTarget.dataset.id;
	}

	vote(upvote) {
		const root = upvote ? `upvote` : `downvote`;
		fetch(`/${root}_post/${this.postID}`, {
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

	upvote() {
		this.vote(true);
	}

	downvote() {
		this.vote(false);
	}
}
