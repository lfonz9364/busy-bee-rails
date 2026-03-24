$(document).on("turbo:load ready", () => {
  const $roleSelect = $("[data-role-toggle='true']");
  const $skillsetWrapper = $("[data-skillset-wrapper]");
  const $skillsetInput = $skillsetWrapper.find("input");

  if ($roleSelect.length === 0 || $skillsetWrapper.length === 0) return;

  toggleSkillset();
  $roleSelect.off("change.roleToggle").on("change.roleToggle", toggleSkillset);

  function toggleSkillset() {
    const role = $roleSelect.val();

    if (role === "developer") {
      $skillsetWrapper.removeClass("hidden");
      $skillsetInput.attr("required", true);
    } else {
      $skillsetWrapper.addClass("hidden");
      $skillsetInput.removeAttr("required").val("");
    }
  }
});
