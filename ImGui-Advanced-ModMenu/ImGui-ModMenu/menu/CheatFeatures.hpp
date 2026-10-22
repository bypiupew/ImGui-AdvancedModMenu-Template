// CheatFeatures.hpp
#pragma once

#include <algorithm>
#include <cmath>
#include <string>
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

inline Settings settings;

inline float distance(Vec2 a, Vec2 b) {
    const float dx = a.x - b.x;
    const float dy = a.y - b.y;
    return std::sqrt(dx * dx + dy * dy);
}

inline const Entity* nearestTarget(
    Vec2 center,
    const std::vector<Entity>& entities,
    float radius
) {
    const Entity* best = nullptr;
    float bestDistance = radius;

    for (const auto& entity : entities) {
        if (!entity.visible || entity.health <= 0.0f)
            continue;

        const float d = distance(center, entity.position);
        if (d < bestDistance) {
            bestDistance = d;
            best = &entity;
        }
    }

    return best;
}

inline Vec2 smoothDemoAim(
    Vec2 current,
    Vec2 target,
    float smoothing,
    float deltaTime
) {
    const float factor = std::clamp(
        deltaTime * std::max(smoothing, 1.0f),
        0.0f,
        1.0f
    );

    return {
        current.x + (target.x - current.x) * factor,
        current.y + (target.y - current.y) * factor
    };
}

inline float demoMovementSpeed(float baseSpeed) {
    if (!settings.speedEnabled)
        return baseSpeed;

    return baseSpeed * std::clamp(
        settings.speedMultiplier,
        1.0f,
        3.0f
    );
}

} // namespace DemoFeatures
