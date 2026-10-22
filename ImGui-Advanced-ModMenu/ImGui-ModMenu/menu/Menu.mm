#include "Menu.hpp"
#include "CheatFeatures.hpp"
#include "imgui.h"

void DrawDemoFeatureMenu() {
    using namespace DemoFeatures;

    if (!ImGui::BeginTabItem("Features"))
        return;

    ImGui::Checkbox("ESP Overlay", &settings.espEnabled);

    if (settings.espEnabled) {
        ImGui::Indent();
        ImGui::Checkbox("Health Bars", &settings.showHealth);
        ImGui::Unindent();
    }

    ImGui::Separator();

    ImGui::Checkbox(
        "Aim Assist Visualization",
        &settings.aimAssistEnabled
    );

    if (settings.aimAssistEnabled) {
        ImGui::Indent();

        ImGui::Checkbox(
            "Show Aim Radius",
            &settings.showAimRadius
        );

        ImGui::SliderFloat(
            "Aim Radius",
            &settings.aimRadius,
            20.0f,
            300.0f,
            "%.0f px"
        );

        ImGui::SliderFloat(
            "Aim Smoothing",
            &settings.aimSmoothing,
            1.0f,
            20.0f,
            "%.1f"
        );

        ImGui::Unindent();
    }

    ImGui::Separator();

    ImGui::Checkbox(
        "Demo Speed Multiplier",
        &settings.speedEnabled
    );

    if (settings.speedEnabled) {
        ImGui::SliderFloat(
            "Speed",
            &settings.speedMultiplier,
            1.0f,
            3.0f,
            "%.1fx"
        );
    }

    ImGui::EndTabItem();
}

void DrawModMenu() {
    if (!ImGui::Begin("Advanced Mod Menu")) {
        ImGui::End();
        return;
    }

    if (ImGui::BeginTabBar("ModMenuTabs")) {
        DrawDemoFeatureMenu();

        if (ImGui::BeginTabItem("About")) {
            ImGui::TextUnformatted("Advanced Mod Menu");
            ImGui::Separator();
            ImGui::TextUnformatted("ImGui demo feature controls");
            ImGui::TextUnformatted("C++17");
            ImGui::EndTabItem();
        }

        ImGui::EndTabBar();
    }

    ImGui::End();
}
