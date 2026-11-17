import { fas as free } from "@fortawesome/free-solid-svg-icons";

export * from "@fortawesome/free-solid-svg-icons";

// pro icon -> free icon drawn in its place
const substitutes = {
  "paper-plane-top": "paper-plane",
  "hexagon-exclamation": "circle-exclamation",
  "wifi-exclamation": "plug-circle-exclamation",
  "gear-code": "code",
  "gamepad-modern": "gamepad",
  "shield-slash": "ban",
};

const byName = Object.fromEntries(Object.values(free).map((d) => [d.iconName, d]));

export const fas = { ...free };
for (const [pro, name] of Object.entries(substitutes)) {
  if (!byName[name]) throw new Error(`no free icon "${name}" to stand in for "${pro}"`);
  fas[pro] = { ...byName[name], iconName: pro };
}
