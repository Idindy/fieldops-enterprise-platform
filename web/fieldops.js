export function validateSchedule(dateValue) {
  if (!dateValue) return { valid: true };
  const selected = new Date(dateValue);
  if (Number.isNaN(selected.getTime())) return { valid: false, message: "Invalid schedule date." };
  return selected > new Date()
    ? { valid: true }
    : { valid: false, message: "Scheduled work must be in the future." };
}

export async function fetchWorkOrders(baseUrl) {
  const response = await fetch(`${baseUrl}/fieldops/v1/work-orders/`, {
    headers: { Accept: "application/json" }
  });
  if (!response.ok) throw new Error(`Work-order request failed: ${response.status}`);
  return response.json();
}
