import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["score", "upvote", "downvote"];

	connect() {
		console.log("Hello, Stimulus!", this.scoreTarget);
	}

	upvote() {}

	downvote() {}
}
