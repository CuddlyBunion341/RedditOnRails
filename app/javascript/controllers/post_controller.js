import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["wrapper"];

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
			.then((data) => {
				if (data.error) alert(data.error);
				else this.wrapperTarget.outerHTML = data.html;
			})
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

	save() {
		fetch(`/save_post/${this.postID}`, {
			method: "POST",
			headers: {
				"Content-Type": "application/json",
				"X-CSRF-Token": document.querySelector(
					'meta[name="csrf-token"]'
				).content,
			},
		})
			.then((response) => response.json())
			.then((data) => {
				if (data.error) alert(data.error);
				else this.wrapperTarget.outerHTML = data.html;
			})
			.catch((error) => {
				console.error("Error:", error);
			});
	}

	archive() {
		if (
			window.confirm("Are you sure you want to archive this post?") ==
			false
		)
			return;

		fetch(`/archive_post/${this.postID}`, {
			method: "GET",
			headers: {
				"Content-Type": "application/json",
				"X-CSRF-Token": document.querySelector(
					'meta[name="csrf-token"]'
				).content,
			},
		})
			.then((response) => response.json())
			.then((data) => {
				if (data.error) alert(error);
				else this.wrapperTarget.outerHTML = data.html;
			})
			.catch((error) => {
				console.error("Error:", error);
			});
	}
}
