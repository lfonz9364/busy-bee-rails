(function () {
  function toggleSkillsetField() {
    var roleSelect = document.querySelector("[data-role-toggle='true']");
    var skillsetWrapper = document.querySelector("[data-skillset-wrapper]");
    if (!roleSelect || !skillsetWrapper) return;

    var skillsetInput = skillsetWrapper.querySelector("input");

    if (roleSelect.value === "developer") {
      skillsetWrapper.classList.remove("hidden");
      if (skillsetInput) skillsetInput.setAttribute("required", "required");
    } else {
      skillsetWrapper.classList.add("hidden");
      if (skillsetInput) {
        skillsetInput.removeAttribute("required");
        skillsetInput.value = "";
      }
    }
  }

  function bindRoleToggle() {
    var roleSelect = document.querySelector("[data-role-toggle='true']");
    if (!roleSelect) return;

    toggleSkillsetField();

    if (roleSelect.dataset.roleToggleBound === "true") return;
    roleSelect.dataset.roleToggleBound = "true";

    roleSelect.addEventListener("change", toggleSkillsetField);
  }

  document.addEventListener("DOMContentLoaded", bindRoleToggle);
  document.addEventListener("turbo:load", bindRoleToggle);
})();
