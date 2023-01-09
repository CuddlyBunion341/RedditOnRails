import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["wrapper", "tabs", "uploadList", "dropzone", "upload"];

	connect() {
		this.files = new Map();
		this.tabs = this.wrapperTarget.querySelectorAll(".tab");

		// show selected tab
		const selectedTabElement = this.tabsTarget.querySelector(
			'input[name="post[post_type]"]:checked'
		);
		if (selectedTabElement) {
			const selectedTab = selectedTabElement.dataset.tab;
			this.showTabIndex(selectedTab);
		}

		// // TODO fix
		// document
		// 	.querySelectorAll(".post-form__attachments img")
		// 	.forEach((img) => {
		// 		const file = new File([img.src], img.src, {
		// 			type: "image/png",
		// 		});
		// 		this.files.set(img.dataset.identifier, file);
		// 	});

		// this.updateFiles();
	}

	showTabIndex(index) {
		this.tabs.forEach((tab) => {
			tab.classList.add("hidden");
		});

		this.wrapperTarget
			.querySelector(`#tab${index}`)
			.classList.remove("hidden");
	}

	showTab(event) {
		const tab = event.target.dataset.tab;
		this.showTabIndex(tab);
	}

	upload(event) {
		event.preventDefault();

		const files = event?.dataTransfer?.files || event.target.files;

		for (let i = 0; i < files.length; i++) {
			const file = files.item(i);

			const identifier = file.name + file.size + file.lastModified;

			if (this.files.has(identifier)) continue;

			this.files.set(identifier, file);

			const reader = new FileReader();

			reader.onload = (e) => {
				const image = document.createElement("img");
				image.src = e.target.result;

				const picture = document.createElement("picture");
				picture.appendChild(image);

				const removeButton = document.createElement("button");
				removeButton.classList.add("removebtn");
				removeButton.innerHTML = "✕";
				removeButton.dataset.file = identifier;
				removeButton.dataset.action = "click->post-form#removeFile";

				picture.appendChild(removeButton);
				this.uploadListTarget.appendChild(picture);
			};

			reader.readAsDataURL(file);
		}

		this.updateFiles();
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

	removeFile(event) {
		const file = event.target.dataset.file;
		this.files.delete(file);
		event.target.parentNode.remove();

		this.updateFiles();
	}

	updateFiles() {
		const dataTransfer = new DataTransfer();
		this.files.forEach((file) => {
			dataTransfer.items.add(file);
		});

		this.uploadTarget.files = dataTransfer.files;
	}
}
