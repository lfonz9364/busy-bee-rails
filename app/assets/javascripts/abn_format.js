$(document).on("ready turbolinks:load turbo:load", () => {
  const $abn = $("[data-abn-format='true']");
  if ($abn.length === 0) return;

  formatABN();
  $abn.off("input.abn").on("input.abn", formatABN);

  function formatABN() {
    let value = $abn.val() || "";

    value = value.replace(/\D/g, "");
    value = value.slice(0, 11);

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

    $abn.val(value);
  }
});
