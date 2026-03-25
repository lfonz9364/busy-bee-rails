(function () {
  function formatABNInput(input) {
    if (!input) return;

    let value = input.value || "";
    value = value.replace(/\D/g, "").slice(0, 11);

    if (value.length > 8) {
      value =
        value.slice(0, 2) +
        " " +
        value.slice(2, 5) +
        " " +
        value.slice(5, 8) +
        " " +
        value.slice(8);
    } else if (value.length > 5) {
      value =
        value.slice(0, 2) + " " + value.slice(2, 5) + " " + value.slice(5);
    } else if (value.length > 2) {
      value = value.slice(0, 2) + " " + value.slice(2);
    }

    input.value = value;
  }

  function bindABNFormatting() {
    var input = document.querySelector("[data-abn-format='true']");
    if (!input) return;

    formatABNInput(input);

    if (input.dataset.abnBound === "true") return;
    input.dataset.abnBound = "true";

    input.addEventListener("input", function () {
      formatABNInput(input);
    });
  }

  document.addEventListener("DOMContentLoaded", bindABNFormatting);
  document.addEventListener("turbo:load", bindABNFormatting);
})();
