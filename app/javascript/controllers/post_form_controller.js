import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["wrapper", "tabs", "uploadList", "dropzone"];

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
		event.preventDefault();

		let files;
		if (event.dataTransfer) {
			files = event.dataTransfer.files;
		} else {
			files = event.target.files;
		}

		for (let i = 0; i < files.length; i++) {
			let file = files.item(i);

			const reader = new FileReader();

			reader.onload = (e) => {
				const image = document.createElement("img");
				image.src = e.target.result;
				const picture = document.createElement("picture");
				picture.appendChild(image);

				const removeButton = document.createElement("button");

				removeButton.innerHTML = "✕";

				removeButton.addEventListener("click", (event) => {
					event.preventDefault();
					picture.remove();
				});

				picture.appendChild(removeButton);

				this.uploadListTarget.appendChild(picture);
			};

			reader.readAsDataURL(file);
		}
	}

	uploadDragOver(event) {
		event.preventDefault();
		this.dropzoneTarget.classList.add("dragover");
	}

	uploadDrop(event) {
		this.upload(event);
		this.dropzoneTarget.classList.remove("dragover");
	}

	uploadDragLeave() {
		this.dropzoneTarget.classList.remove("dragover");
	}
}
