import { Controller } from "@hotwired/stimulus";
import { ajax } from "../application.js";

// Connects to data-controller="comment"
export default class extends Controller {
	static targets = ["wrapper"];

	connect() {
		this.commentID = this.wrapperTarget.dataset.id;
	}

	vote(upvote) {
		const root = upvote ? "upvote" : "downvote";
		ajax(`/${root}_comment/${this.commentID}`, {
			method: "POST",
		})
			.then((response) => response.json())
			.then((data) => {
				if (data.error) alert(data.error);
				else this.wrapperTarget.outerHTML = data.html;
			})
			.catch((error) => {
				console.log("Error:", error);
			});
	}

	upvote() {
		this.vote(true);
	}

	downvote() {
		this.vote(false);
	}

	save() {
		ajax(`/save_comment/${this.commentID}`, {
			method: "POST",
		})
			.then((response) => response.json())
			.then((data) => {
				if (data.error) alert(data.error);
				else this.wrapperTarget.outerHTML = data.html;
			})
			.catch((error) => {
				console.log("Error:", error);
			});
	}

	reply() {}
}
