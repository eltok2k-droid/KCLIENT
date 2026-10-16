import { describe, expect, it } from "vitest";
import { calculateDeposit, validateProjectDescription, serviceRanges } from "../src/lib/booking";

describe("deposit calculation", () => {
  it("calculates a 50% deposit and remainder", () => {
    expect(calculateDeposit(1000)).toEqual({ deposit: 500, remaining: 500 });
  });
  it("supports fractional amounts safely to two decimal places", () => {
    expect(calculateDeposit(799.99)).toEqual({ deposit: 400, remaining: 399.99 });
  });
  it("rejects negative prices and invalid percentages", () => {
    expect(() => calculateDeposit(-1)).toThrow();
    expect(() => calculateDeposit(100, 101)).toThrow();
  });
});

describe("project description validation", () => {
  it("allows a non-empty new request up to 1000 characters", () => {
    expect(validateProjectDescription("x".repeat(1000), "new").valid).toBe(true);
    expect(validateProjectDescription("x".repeat(1001), "new").valid).toBe(false);
  });
  it("limits similar-work notes to 500 characters", () => {
    expect(validateProjectDescription("x".repeat(500), "similar").valid).toBe(true);
    expect(validateProjectDescription("x".repeat(501), "similar").valid).toBe(false);
  });
});

describe("service estimates", () => {
  it("contains all four service ranges from the brief", () => {
    expect(Object.keys(serviceRanges)).toEqual(["graphic", "video", "android", "web"]);
    expect(serviceRanges.graphic.minBudget).toBe(200);
    expect(serviceRanges.video.maxBudget).toBe(1100);
    expect(serviceRanges.android.minBudget).toBe(23000 - 0); // max
    expect(serviceRanges.web.minBudget).toBe(6000);
  });
});
