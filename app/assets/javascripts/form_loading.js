document.addEventListener("submit", (event) => {
  const form = event.target;
  const submit = event.submitter || form.querySelector('[type="submit"]');
  if (!submit) return;

  const loadingText = submit.dataset.loadingText;
  if (!loadingText) return;

  if (submit.matches('input[type="submit"]')) {
    submit.value = loadingText;
  } else {
    submit.textContent = loadingText;
  }

  submit.disabled = true;
});
