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

	fetchCommunities() {
		ajax("/communities/list", { debug: false })
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

	populateSelect() {
		this.listTarget.innerHTML = this.communities
			.map((community) => {
				console.log(community);
				return `
				<li>
					<button type="button" 
					data-value="${community.id}" data-action="click->community-select#select">
					<b>${community.shortname}</b><br>
					<span>${community.posts_count} posts</span>
					</button>
				</li>
				`;
			})
			.join("");
	}

	selectID(id) {
		this.community = this.communities.find((c) => c.id == id);

		this.searchTarget.value = this.community.name;

		this.inputTarget.value = this.community.id;
	}

	select(event) {
		event.preventDefault();
		const id = event.target.dataset.value;
		this.selectID(id);
	}

	deselect(event) {
		event.preventDefault();
		this.community = null;
		this.selectedTarget.innerHTML = "";
	}

	toggle() {
		this.listTarget.classList.toggle("hidden");
	}

	search(event) {
		event.preventDefault();
		const search = event.target.value;
		const matches = this.communities.filter(
			(c) =>
				c.name.toLowerCase().includes(search.toLowerCase()) ||
				c.shortname.toLowerCase().includes(search.toLowerCase())
		);
		this.listTarget.innerHTML = matches
			.map((community) => {
				return `
				<li>
					<button type="button" 
					data-value="${community.id}" data-action="click->community-select#select">
					<b>${community.shortname}</b><br>
					<span>${community.posts_count} posts</span>
					</button>
				</li>
				`;
			})
			.join("");
	}
}
