import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["content", "counter", "next", "previous"];

	connect() {
		this.images = this.contentTarget.querySelectorAll("img");
		this.index = 0;

		for (let i = 1; i < this.count; i++) this.moveImage(i, 1);
		this.contentTarget.classList.add("loaded");
	}

	get count() {
		return this.images.length;
	}

	moveImage(index, direction) {
		if (index >= this.count || index < 0) return;
		this.images[index].style.left = `${direction * 100}%`;
	}

	updateCounter() {
		this.counterTarget.textContent = `${this.index + 1} of ${this.count}`;
	}

	moveGallery(direction) {
		if (this.index + direction >= this.count) return;
		if (this.index + direction < 0) return;

		this.moveImage(this.index, -direction);
		this.index += direction;
		this.moveImage(this.index, 0);
		this.updateCounter();

		if (this.index == 0) {
			this.previousTarget.classList.add("hidden");
		} else {
			this.previousTarget.classList.remove("hidden");
		}

		if (this.index == this.count - 1) {
			this.nextTarget.classList.add("hidden");
		} else {
			this.nextTarget.classList.remove("hidden");
		}
	}

	next() {
		this.moveGallery(1);
	}

	previous() {
		this.moveGallery(-1);
	}
}
