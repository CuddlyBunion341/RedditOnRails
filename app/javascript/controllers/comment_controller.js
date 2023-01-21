import { Controller } from "@hotwired/stimulus";
import { ajax } from "../application.js";

// Connects to data-controller="comment"
export default class extends Controller {
	static targets = ["wrapper", "replyBody"];

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

	toggleReply() {
		if (this.wrapperTarget.querySelector(".comment-reply")) {
			this.wrapperTarget.querySelector(".comment-reply").remove();
			return;
		}

		const replyForm = document.createElement("form");
		replyForm.classList.add("comment-reply");
		replyForm.action = "/comments";
		replyForm.method = "post";
		replyForm.innerHTML = `
			<input type="hidden" name="comment[parent_id]" value="${this.commentID}">
			<textarea name="comment[body]" placeholder="Write a reply..." data-comment-target="replyBody" required></textarea>
			<input type="submit" value="Reply" data-action="comment#reply">
		`;
		this.wrapperTarget.appendChild(replyForm);
		this.replyBodyTarget.focus();
	}

	reply(event) {
		event.preventDefault();
		const body = this.replyBodyTarget.value;
		ajax(`/comments/${this.commentID}/reply`, {
			method: "POST",
			body: {
				comment: { parent_id: this.commentID, body },
			},
		})
			.then((response) => response.json())
			.then((data) => {
				if (data.error) alert(data.error);
				else {
					this.wrapperTarget.querySelector(".comment-reply").remove();
					this.wrapperTarget.insertAdjacentHTML(
						"afterend",
						data.html
					);
				}
			})
			.catch((error) => {
				console.log("Error:", error);
			});
	}
}
