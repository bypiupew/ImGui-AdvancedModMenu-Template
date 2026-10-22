#include "CheatFeatures.hpp"

#include <algorithm>
#include <cmath>

namespace DemoFeatures {

Settings settings;

float distance(Vec2 a, Vec2 b) {
    const float dx = a.x - b.x;
    const float dy = a.y - b.y;
    return std::sqrt(dx * dx + dy * dy);
}

const Entity* nearestTarget(
    Vec2 center,
    const std::vector<Entity>& entities,
    float radius
) {
    const Entity* best = nullptr;
    float bestDistance = radius;

    for (const Entity& entity : entities) {
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

Vec2 smoothDemoAim(
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

float demoMovementSpeed(float baseSpeed) {
    if (!settings.speedEnabled)
        return baseSpeed;

    return baseSpeed * std::clamp(
        settings.speedMultiplier,
        1.0f,
        3.0f
    );
}

} // namespace DemoFeatures

void DrawDemoOverlay(
    const std::vector<DemoFeatures::Entity>& entities,
    ImVec2 screenCenter
) {
    using namespace DemoFeatures;

    ImDrawList* draw = ImGui::GetForegroundDrawList();

    if (settings.aimAssistEnabled && settings.showAimRadius) {
        draw->AddCircle(
            screenCenter,
            settings.aimRadius,
            IM_COL32(80, 180, 255, 200),
            64,
            1.5f
        );
    }

    if (!settings.espEnabled)
        return;

    for (const Entity& entity : entities) {
        if (!entity.visible || entity.health <= 0.0f)
            continue;

        const ImVec2 topLeft(
            entity.position.x - entity.width * 0.5f,
            entity.position.y - entity.height * 0.5f
        );

        const ImVec2 bottomRight(
            entity.position.x + entity.width * 0.5f,
            entity.position.y + entity.height * 0.5f
        );

        draw->AddRect(
            topLeft,
            bottomRight,
            IM_COL32(80, 255, 130, 230),
            0.0f,
            0,
            1.5f
        );

        if (settings.showHealth) {
            const float health = std::clamp(
                entity.health / 100.0f,
                0.0f,
                1.0f
            );

            draw->AddRectFilled(
                ImVec2(topLeft.x - 6.0f, topLeft.y),
                ImVec2(topLeft.x - 2.0f, bottomRight.y),
                IM_COL32(50, 50, 50, 220)
            );

            draw->AddRectFilled(
                ImVec2(topLeft.x - 6.0f,
                       bottomRight.y - entity.height * health),
                ImVec2(topLeft.x - 2.0f, bottomRight.y),
                IM_COL32(60, 230, 100, 255)
            );
        }
    }

    if (settings.aimAssistEnabled) {
        const Entity* target = nearestTarget(
            {screenCenter.x, screenCenter.y},
            entities,
            settings.aimRadius
        );

        if (target) {
            draw->AddLine(
                screenCenter,
                ImVec2(target->position.x, target->position.y),
                IM_COL32(255, 200, 60, 220),
                1.5f
            );
        }
    }
}
