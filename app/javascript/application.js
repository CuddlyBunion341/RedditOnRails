// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

function ajax(url, options = {}) {
	const {
		body = null,
		method = "GET",
		contentType = "json",
		debug = false,
	} = options;

	return fetch(url, {
		method,
		headers: {
			"Content-Type": `application/${contentType}`,
			"X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
				.content,
		},
		body: body ? JSON.stringify(body) : null,
	}).then((response) => {
		if (debug) {
			response.text().then((text) => console.log(text));
		}

		return response;
	});
}

export { ajax };
