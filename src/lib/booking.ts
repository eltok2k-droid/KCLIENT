export type ServiceKey = "graphic" | "video" | "android" | "web";

export const serviceRanges: Record<ServiceKey, {
  minBudget: number; maxBudget: number; minDuration: string; maxDuration: string;
}> = {
  graphic: { minBudget: 200, maxBudget: 500, minDuration: "30 دقيقة", maxDuration: "ساعة ونصف" },
  video: { minBudget: 250, maxBudget: 1100, minDuration: "ساعة", maxDuration: "3 ساعات" },
  android: { minBudget: 4000, maxBudget: 23000, minDuration: "يومان", maxDuration: "أسبوعان" },
  web: { minBudget: 6000, maxBudget: 30000, minDuration: "4 أيام", maxDuration: "شهر" }
};

export function calculateDeposit(totalPrice: number, percent = 50) {
  if (!Number.isFinite(totalPrice) || totalPrice < 0) {
    throw new Error("السعر يجب أن يكون رقمًا موجبًا أو صفرًا.");
  }
  if (!Number.isFinite(percent) || percent < 0 || percent > 100) {
    throw new Error("نسبة العربون يجب أن تكون بين 0 و100.");
  }
  const deposit = Math.round((totalPrice * percent) / 100 * 100) / 100;
  return { deposit, remaining: Math.round((totalPrice - deposit) * 100) / 100 };
}

export function validateProjectDescription(value: string, kind: "new" | "similar") {
  const max = kind === "new" ? 1000 : 500;
  const length = value.trim().length;
  return { valid: length > 0 && length <= max, max, length };
}
