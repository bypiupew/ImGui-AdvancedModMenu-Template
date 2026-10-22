
#pragma once

namespace CheatFeatures {
    inline bool espEnabled = false;
    inline bool aimbotEnabled = false;
    inline bool fastSpeedEnabled = false;

    inline float speedMultiplier = 1.5f;

    inline bool showLabels = true;
    inline bool showDistance = true;

    inline void Reset() {
        espEnabled = false;
        aimbotEnabled = false;
        fastSpeedEnabled = false;
        speedMultiplier = 1.5f;
        showLabels = true;
        showDistance = true;
    }
}
