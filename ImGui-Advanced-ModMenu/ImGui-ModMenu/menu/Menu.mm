
#include "Menu.hpp"
#include "HUD.h"
#include "ModuleManager.hpp"

#include "../util/ColorH.hpp"
#include "../util/Obf.hpp"
#include "../IMGUI/Fonts.hpp"

#include "../include.h"
#include <vector>

// Sets the colors.
void Menu::setColors() {
    style->Colors[ImGuiCol_WindowBg] = *winCol;
    style->Colors[ImGuiCol_Border] = ImColor(0, 0, 0, 0);
    style->Colors[ImGuiCol_Button] = *bgCol;
    style->Colors[ImGuiCol_ButtonActive] = *btnActiveCol;
    style->Colors[ImGuiCol_ButtonHovered] = *btnHoverCol;
    style->Colors[ImGuiCol_FrameBg] = *bgCol;
    style->Colors[ImGuiCol_FrameBgActive] = *frameCol;
    style->Colors[ImGuiCol_FrameBgHovered] = *hoverCol;
    style->Colors[ImGuiCol_Text] = *textCol;
    style->Colors[ImGuiCol_ChildBg] = *childCol;
    style->Colors[ImGuiCol_CheckMark] = *itemActiveCol;
    style->Colors[ImGuiCol_SliderGrab] = *itemCol;
    style->Colors[ImGuiCol_SliderGrabActive] = *itemActiveCol;
    style->Colors[ImGuiCol_Header] = *itemActiveCol;
    style->Colors[ImGuiCol_HeaderHovered] = *itemCol;
    style->Colors[ImGuiCol_HeaderActive] = *itemActiveCol;
    style->Colors[ImGuiCol_ResizeGrip] = *resizeGripCol;
    style->Colors[ImGuiCol_ResizeGripHovered] = *resizeGripHoverCol;
    style->Colors[ImGuiCol_ResizeGripActive] = *itemActiveCol;
    style->Colors[ImGuiCol_SeparatorHovered] = *resizeGripHoverCol;
    style->Colors[ImGuiCol_SeparatorActive] = *itemActiveCol;
    style->Colors[ImGuiCol_TitleBgActive] = *itemActiveCol;
}

// Load fonts.
void Menu::loadFont() {
    ImGuiIO& io = ImGui::GetIO();
    (void)io;

    io.Fonts->Clear();

    ImFontConfig font_cfg;
    font_cfg.FontDataOwnedByAtlas = false;

    io.Fonts->AddFontFromMemoryTTF(
        (void*)poppinsFont,
        sizeof(poppinsFont),
        isIphone ? 20 : 24,
        &font_cfg
    );

    static const ImWchar icons_ranges[] = {
        ICON_MIN_FA, ICON_MAX_FA, 0
    };

    ImFontConfig icons_config;
    icons_config.MergeMode = true;
    icons_config.PixelSnapH = true;
    icons_config.FontDataOwnedByAtlas = false;

    io.Fonts->AddFontFromMemoryTTF(
        (void*)fontAwesome,
        sizeof(fontAwesome),
        isIphone ? 20 : 24,
        &icons_config,
        icons_ranges
    );

    ImFontConfig bigFontCfg;
    bigFontCfg.FontDataOwnedByAtlas = false;

    bigFont = io.Fonts->AddFontFromMemoryTTF(
        (void*)poppinsFont,
        sizeof(poppinsFont),
        isIphone ? 24 : 30,
        &bigFontCfg
    );

    io.Fonts->AddFontFromMemoryTTF(
        (void*)fontAwesome,
        sizeof(fontAwesome),
        isIphone ? 20 : 24,
        &icons_config,
        icons_ranges
    );
}

// Load the theme.
void Menu::loadTheme() {
    loadFont();

    style = &ImGui::GetStyle();

    style->WindowRounding = 6;
    style->ChildRounding = 6;
    style->FrameRounding = 2;
    style->GrabRounding = 2;
    style->PopupRounding = 2;

    style->ScrollbarSize = 9;
    style->FramePadding = ImVec2(6, 3);
    style->ItemSpacing = ImVec2(4, 4);

    setColors();
}

// Top-left logo.
void Menu::renderLogo() {
    ImGui::BeginGroup();

    ImGui::BeginChild(
        obf("Logo").c_str(),
        ImVec2(isIphone ? 118.5f : 158.0f,
               isIphone ? 37.5f : 50.0f),
        true
    );

    ImGui::PushFont(bigFont);
    ImGui::SameLine();
    ImGui::SetCursorPosY(isIphone ? 5.0f : 11.0f);
    ImGui::TextUnformatted(obf("MOD MENU").c_str());
    ImGui::PopFont();

    ImGui::EndChild();
    ImGui::EndGroup();
}

// Bottom-left user panel.
void Menu::renderUser() {
    int height = isIphone ? 60 : 80;

    ImGui::Dummy(
        ImVec2(
            0.0f,
            ImGui::GetContentRegionAvail().y -
                height - style->ItemSpacing.y
        )
    );

    ImGui::BeginChild(
        obf("User").c_str(),
        ImVec2(isIphone ? 118.5f : 158.0f, (float)height),
        true
    );

    ImGui::Text("UserTest1");
    ImGui::EndChild();
}

// Draw the left panel.
void Menu::renderPanel() {
    renderLogo();
    ImGui::Spacing();
    renderTabs();
    renderUser();
}

// Navigation buttons.
void Menu::renderTabs() {
    ImGui::BeginChild(
        obf("tabs").c_str(),
        ImVec2(isIphone ? 118.5f : 158.0f,
               isIphone ? 165.0f : 220.0f),
        true
    );

    ImGui::Spacing();

    ImVec4 col(0, 0, 0, 0);

    ImGui::PushStyleVar(ImGuiStyleVar_FrameRounding, 10);

    std::string tabNames[] = {
        obf(ICON_FA_CROSSHAIRS " Main"),
        obf(ICON_FA_EYE " Visuals"),
        obf(ICON_FA_COG " Misc"),
        obf(ICON_FA_TOOLS " Settings")
    };

    float buttonWidth = isIphone ? 100.0f : 140.0f;
    float buttonHeight = isIphone ? 30.0f : 40.0f;

    for (int i = 0; i < sizeof(tabNames) / sizeof(tabNames[0]); i++) {
        std::string it = tabNames[i];

        ImGui::PushStyleVar(
            ImGuiStyleVar_ButtonTextAlign,
            ImVec2(0, 0.5f)
        );

        ImGui::PushStyleColor(
            ImGuiCol_Button,
            selectedTab == i
                ? style->Colors[ImGuiCol_ButtonActive]
                : col
        );

        ImGui::PushStyleColor(
            ImGuiCol_Text,
            selectedTab == i
                ? style->Colors[ImGuiCol_Text]
                : *notSelectedTextColor
        );

        if (ImGui::Button(it.c_str(), ImVec2(buttonWidth, buttonHeight))) {
            selectedTab = i;
        }

        ImGui::PopStyleVar();
        ImGui::PopStyleColor(2);
    }

    ImGui::PopStyleVar();
    ImGui::EndChild();
}

// Main tab.
void Menu::renderSubTab0() {
    std::vector<std::string> arr = {
        obf("TAB1"),
        obf("TAB2"),
        obf("TAB3")
    };

    ImGuiHelper::drawTabHorizontally(
        obf("subtab-0"),
        ImVec2(ImGuiHelper::getWidth(), 50),
        arr,
        selectedSubTab0
    );

    ImGui::Spacing();

    ImGui::PushStyleColor(
        ImGuiCol_ChildBg,
        ImVec4(0, 0, 0, 0)
    );

    ImGui::BeginChild(
        obf("modules-wrapper").c_str(),
        ImVec2(
            ImGui::GetContentRegionAvail().x,
            ImGui::GetContentRegionAvail().y
        ),
        false
    );

    ImGui::PopStyleColor();

    switch (selectedSubTab0) {
        case 0: {
            ImGui::Columns(2, nullptr, false);
            ImGui::SetColumnOffset(1, 300);

            ImGui::BeginChild(
                obf("aimassist").c_str(),
                ImVec2(ImGuiHelper::getWidth(), 300),
                true
            );

            // Weapon modification toggle states.
            ImGui::Text("Weapon Modifications");
            ImGui::Separator();

            ImGui::Checkbox(
                "Perfect Accuracy (No Spread)",
                &NoSpreadActive
            );

            ImGui::Checkbox(
                "God Mode (Invincibility)",
                &GodModeActive
            );

            ImGui::EndChild();

            ImGui::Spacing();

            ImGui::BeginChild(
                obf("aimassist2").c_str(),
                ImVec2(
                    ImGuiHelper::getWidth(),
                    ImGuiHelper::getHeight()
                ),
                true
            );

            // Existing content placeholder.
            ImGui::EndChild();

            ImGui::NextColumn();

            ImGui::BeginChild(
                obf("aimassist3").c_str(),
                ImVec2(
                    ImGuiHelper::getWidth(),
                    ImGuiHelper::getHeight()
                ),
                true
            );

            // Existing content placeholder.
            ImGui::EndChild();

            break;
        }

        case 1:
            break;

        case 2:
            break;
    }

    ImGui::EndChild();
}

// Visuals tab.
void Menu::renderSubTab1() {
    ImGuiHelper::drawTabHorizontally(
        obf("subtab-1"),
        ImVec2(ImGuiHelper::getWidth(), 50),
        {obf("ESP"), obf("World"), obf("Other")},
        selectedSubTab1
    );

    ImGui::Spacing();

    ImGui::PushStyleColor(
        ImGuiCol_ChildBg,
        ImVec4(0, 0, 0, 0)
    );

    ImGui::BeginChild(
        obf("modules-wrapper").c_str(),
        ImVec2(
            ImGuiHelper::getWidth(),
            ImGuiHelper::getHeight()
        ),
        false
    );

    ImGui::PopStyleColor();

    switch (selectedSubTab1) {
        case 0: {
            ImGui::Columns(2, nullptr, false);
            ImGui::SetColumnOffset(1, 300);

            ImGui::BeginChild(
                obf("esp").c_str(),
                ImVec2(ImGuiHelper::getWidth(), 300),
                true
            );

            // Existing ESP content placeholder.
            ImGui::EndChild();

            ImGui::Spacing();

            ImGui::BeginChild(
                obf("Markers").c_str(),
                ImVec2(
                    ImGuiHelper::getWidth(),
                    ImGuiHelper::getHeight()
                ),
                true
            );

            // Existing markers content placeholder.
            ImGui::EndChild();

            ImGui::NextColumn();

            ImGui::BeginChild(
                obf("esp2").c_str(),
                ImVec2(
                    ImGuiHelper::getWidth(),
                    ImGuiHelper::getHeight()
                ),
                true
            );

            // Existing ESP content placeholder.
            ImGui::EndChild();

            break;
        }

        case 1:
            break;

        case 2:
            break;
    }

    ImGui::EndChild();
}

// Miscellaneous and GUI settings.
void Menu::renderSubTab2() {
    std::vector<std::string> arr = {
        obf("General"),
        obf("Other")
    };

    ImGuiHelper::drawTabHorizontally(
        obf("subtab-2"),
        ImVec2(ImGuiHelper::getWidth(), 50),
        arr,
        selectedSubTab2
    );

    ImGui::Spacing();

    ImGui::PushStyleColor(
        ImGuiCol_ChildBg,
        ImVec4(0, 0, 0, 0)
    );

    ImGui::BeginChild(
        obf("modules-wrapper").c_str(),
        ImVec2(
            ImGuiHelper::getWidth(),
            ImGuiHelper::getHeight()
        ),
        false
    );

    ImGui::PopStyleColor();

    switch (selectedSubTab2) {
        case 0: {
            ImGui::Columns(2, nullptr, false);
            ImGui::SetColumnOffset(1, 300);

            ImGui::BeginChild(
                obf("misc##0-0").c_str(),
                ImVec2(ImGuiHelper::getWidth(), 300),
                true
            );

            // Existing miscellaneous setting.
            ImGui::Checkbox("Streamer Mode", &StreamerMode);

            ImGui::EndChild();
            ImGui::Spacing();

            ImGui::BeginChild(
                obf("misc##0-1").c_str(),
                ImVec2(
                    ImGuiHelper::getWidth(),
                    ImGuiHelper::getHeight()
                ),
                true
            );

            // Existing content placeholder.
            ImGui::EndChild();

            ImGui::NextColumn();

            ImGui::BeginChild(
                obf("misc##0-2").c_str(),
                ImVec2(
                    ImGuiHelper::getWidth(),
                    ImGuiHelper::getHeight()
                ),
                true
            );

            // Existing content placeholder.
            ImGui::EndChild();

            break;
        }

        case 1: {
            ImGui::Columns(2, nullptr, false);
            ImGui::SetColumnOffset(1, 300);

            ImGui::BeginChild(
                obf("gui").c_str(),
                ImVec2(ImGui::GetContentRegionAvail().x, 300),
                true
            );

            ImGui::ColorEdit4(
                obf("Window Color##1").c_str(),
                (float*)winCol,
                ImGuiColorEditFlags_NoInputs |
                    ImGuiColorEditFlags_AlphaBar
            );

            ImGui::ColorEdit4(
                obf("BackGround Color##1").c_str(),
                (float*)childCol,
                ImGuiColorEditFlags_NoInputs |
                    ImGuiColorEditFlags_AlphaBar
            );

            ImGui::ColorEdit4(
                obf("Frame Color##1").c_str(),
                (float*)frameCol,
                ImGuiColorEditFlags_NoInputs |
                    ImGuiColorEditFlags_AlphaBar
            );

            ImGui::ColorEdit4(
                obf("Button Color##1").c_str(),
                (float*)bgCol,
                ImGuiColorEditFlags_NoInputs |
                    ImGuiColorEditFlags_AlphaBar
            );

            ImGui::ColorEdit4(
                obf("Button Hovered Color##1").c_str(),
                (float*)btnHoverCol,
                ImGuiColorEditFlags_NoInputs |
                    ImGuiColorEditFlags_AlphaBar
            );

            ImGui::ColorEdit4(
                obf("Button Active Color##1").c_str(),
                (float*)btnActiveCol,
                ImGuiColorEditFlags_NoInputs |
                    ImGuiColorEditFlags_AlphaBar
            );

            ImGui::ColorEdit4(
                obf("Item Color##1").c_str(),
                (float*)itemCol,
                ImGuiColorEditFlags_NoInputs |
                    ImGuiColorEditFlags_AlphaBar
            );

            ImGui::ColorEdit4(
                obf("Item Active Color##1").c_str(),
                (float*)itemActiveCol,
                ImGuiColorEditFlags_NoInputs |
                    ImGuiColorEditFlags_AlphaBar
            );

            setColors();

            ImGui::EndChild();
            ImGui::Spacing();

            ImGui::BeginChild(
                obf("smth").c_str(),
                ImVec2(
                    ImGuiHelper::getWidth(),
                    ImGuiHelper::getHeight()
                ),
                true
            );

            // Existing content placeholder.
            ImGui::EndChild();

            ImGui::NextColumn();

            ImGui::BeginChild(
                obf("whoknows").c_str(),
                ImVec2(
                    ImGuiHelper::getWidth(),
                    ImGuiHelper::getHeight()
                ),
                true
            );

            // Existing content placeholder.
            ImGui::EndChild();

            break;
        }
    }

    ImGui::EndChild();
}

// Render the menu.
void Menu::render() {
    if (ImGui::Begin(
            "ModMenu",
            nullptr,
            ImGuiWindowFlags_NoCollapse |
                ImGuiWindowFlags_NoTitleBar)) {

        ImGuiWindow* CurrentWindow = ImGui::GetCurrentWindow();

        MenuSize = CurrentWindow->Size;
        MenuOrigin = CurrentWindow->Pos;

        ImGui::Columns(2);
        ImGui::SetColumnOffset(
            1,
            isIphone ? 129.75f : 173.0f
        );

        renderPanel();

        // Right side.
        ImGui::NextColumn();

        switch (selectedTab) {
            case 0:
                renderSubTab0();
                break;

            case 1:
                renderSubTab1();
                break;

            case 2:
                renderSubTab2();
                break;

            case 3:
                break;
        }

        ImGui::End();
    }
}
