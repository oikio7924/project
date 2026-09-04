import { reactive } from 'vue';

export const notificationState = reactive({
  toasts: [],
  confirm: null
});

let toastSequence = 0;
let toastTimer = null;

export function notify(message, type = 'success') {
  const id = ++toastSequence;
  if (toastTimer) { clearTimeout(toastTimer); toastTimer = null; }
  notificationState.toasts.splice(0, notificationState.toasts.length, { id, message, type });
  toastTimer = window.setTimeout(() => { notificationState.toasts.splice(0); toastTimer = null; }, 3500);
}

export function dismissToast(id) {
  const index = notificationState.toasts.findIndex((toast) => toast.id === id);
  if (index !== -1) notificationState.toasts.splice(index, 1);
  if (toastTimer) { clearTimeout(toastTimer); toastTimer = null; }
}

export function confirmAction({
  title = '작업 확인',
  message,
  confirmText = '확인',
  danger = false
}) {
  return new Promise((resolve) => {
    notificationState.confirm = { title, message, confirmText, danger, resolve };
  });
}

export function resolveConfirm(result) {
  const current = notificationState.confirm;
  notificationState.confirm = null;
  current?.resolve(result);
}
