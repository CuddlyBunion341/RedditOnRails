import { Controller } from "@hotwired/stimulus"

function ajax(url, options = {}) {
  const { body = null, method = "GET", contentType = "json", debug = false } = options;

  return fetch(url, {
    method,
    headers: {
      "Content-Type": `application/${contentType}`,
      "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
    },
    body: body ? JSON.stringify(body) : null
  })
    .then((response) => {
      if (debug) {
        response.text().then(
          text => console.log(text)
        )
      }

      return response;
    });
}

// Connects to data-controller="comments"
export default class extends Controller {
  static targets = ["wrapper"]

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
}
