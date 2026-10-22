#pragma once

#include "../IMGUI/imgui.h"
#include <vector>

namespace DemoFeatures {

struct Vec2 {
    float x = 0.0f;
    float y = 0.0f;
};

struct Entity {
    int id = 0;
    Vec2 position;
    float width = 36.0f;
    float height = 72.0f;
    float health = 100.0f;
    bool visible = true;
};

struct Settings {
    bool espEnabled = true;
    bool showHealth = true;
    bool aimAssistEnabled = false;
    bool showAimRadius = true;
    float aimRadius = 120.0f;
    float aimSmoothing = 8.0f;
    bool speedEnabled = false;
    float speedMultiplier = 1.0f;
};

extern Settings settings;

float distance(Vec2 a, Vec2 b);

const Entity* nearestTarget(
    Vec2 center,
    const std::vector<Entity>& entities,
    float radius
);

Vec2 smoothDemoAim(
    Vec2 current,
    Vec2 target,
    float smoothing,
    float deltaTime
);

float demoMovementSpeed(float baseSpeed);

} // namespace DemoFeatures

void DrawDemoOverlay(
    const std::vector<DemoFeatures::Entity>& entities,
    ImVec2 screenCenter
);

void DrawDemoFeatureMenu();
