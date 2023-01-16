import { Controller } from "@hotwired/stimulus";

function ajax(url, options = {}) {
	const { body = null, method = "GET", contentType = "json" } = options;

	return fetch(url, {
		method,
		headers: {
			"Content-Type": `application/${contentType}`,
			"X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
				.content,
		},
		body: body ? JSON.stringify(body) : null,
	});
}

export default class extends Controller {
	static targets = ["wrapper"];

	connect() {
		this.postID = this.wrapperTarget.dataset.id;
		this.varname = this.wrapperTarget.dataset.variant;
	}

	vote(upvote) {
		const root = upvote ? `upvote` : `downvote`;
		ajax(`/${root}_post/${this.postID}`, {
			method: "POST",
			body: { variant: this.varname },
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
		ajax(`/save_post/${this.postID}`, {
			method: "POST",
			body: { variant: this.varname },
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
		if (!window.confirm("Are you sure you want to archive this post?"))
			return;

		ajax(`/archive_post/${this.postID}`, {
			method: "POST",
			body: { variant: this.varname },
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

	delete() {
		if (!window.confirm("Are you sure you want to delete this draft?"))
			return;

		ajax(`/posts/${this.postID}`, {
			method: "DELETE",
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
