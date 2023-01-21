import { Controller } from "@hotwired/stimulus";
import { ajax } from "../application.js";

// Connects to data-controller="community-select"
export default class extends Controller {
	static targets = ["list", "search", "input"];

	connect() {
		console.log("Connected to community-select controller");
		this.communities = [];
		this.community = null;
		this.fetchCommunities();
	}

	// Fetches the list of communities from the server
	fetchCommunities() {
		ajax("/communities/list")
			.then((response) => response.json())
			.then((data) => {
				this.communities = data;
				this.populateSelect();
				this.selectID(this.inputTarget.value || this.communities[0].id);
			})
			.catch((error) => {
				console.log("Error:", error);
			});
	}

	// Returns the HTML for a single community
	listItem(community) {
		return `
		<li>
			<button type="button" 
			data-value="${community.id}" data-action="click->community-select#select">
			<b>${community.shortname}</b><br>
			<span>${community.posts_count} posts</span>
			</button>
		</li>`;
	}

	// Populates the select with the list of communities
	populateSelect() {
		this.listTarget.innerHTML = this.communities
			.map(this.listItem)
			.join("");
	}

	// Selects a community by ID
	selectID(id) {
		this.community = this.communities.find((c) => c.id == id);

		this.searchTarget.value = this.community.name;

		this.inputTarget.value = this.community.id;
	}

	// Selects a community by clicking on it
	select(event) {
		event.preventDefault();
		const id = event.target.dataset.value;
		this.selectID(id);
		this.hide();
		this.showAll();
	}

	// Selects the first filtered community in the list
	selectFirst() {
		this.listTarget.querySelector("li:not(.hidden) button")?.click(); // todo: refactor using classList
	}

	// Deselects the current community
	deselect(event) {
		event.preventDefault();
		this.community = null;
		this.selectedTarget.innerHTML = "";
	}

	// Toggles the visibility of the list
	toggle() {
		this.listTarget.classList.toggle("hidden");
	}

	// Shows the list
	show() {
		this.listTarget.classList.remove("hidden");
	}

	// Hides the list
	hide() {
		this.listTarget.classList.add("hidden");
	}

	// Filters the list of communities
	filter(event) {
		console.log(event);
		console.log(event.target.value);
		if (event.key === "Enter") {
			this.confirm(event);
			return;
		}

		const search = event.target.value.toLowerCase();
		if (search.trim() === "") {
			this.showAll();
			return;
		}

		const filtered = this.communities.filter((c) => {
			return (
				c.name.toLowerCase().includes(search) ||
				c.shortname.toLowerCase().includes(search)
			);
		});

		this.listTarget.innerHTML = filtered.map(this.listItem).join("");
	}

	// Confirms the selection of the first filtered community
	confirm(event) {
		event.preventDefault();
		this.selectFirst();
		this.showAll();
		this.toggle();
	}

	// Resets the list to show all communities
	showAll() {
		this.listTarget.innerHTML = this.communities
			.map(this.listItem)
			.join("");
	}
}
