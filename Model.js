.pragma library

// Model.js: State and formatting helpers for Predator Turbo Plugin

function parseTelemetry(rawJson) {
  try {
    if (!rawJson || rawJson.trim() === "") return null;
    return JSON.parse(rawJson);
  } catch (e) {
    return null;
  }
}

function fanSpeedText(rpm, turbo) {
  if (turbo) return "MAX RPM";
  if (rpm > 0) return rpm + " RPM";
  return "AUTO";
}

function fanRotationDuration(rpm, turbo) {
  if (turbo) return 320; // High speed smooth spin
  if (rpm > 4500) return 400;
  if (rpm > 3500) return 550;
  if (rpm > 2500) return 750;
  if (rpm > 1500) return 1100;
  if (rpm > 0) return 1600;
  return 2200; // gentle idle spin
}

function fanRpmPercent(rpm, turbo) {
  if (turbo) return 1.0;
  if (rpm <= 0) return 0.40;
  return Math.min(Math.max(rpm / 5500.0, 0.15), 1.0);
}
