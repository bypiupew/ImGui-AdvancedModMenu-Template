#include "Set.hpp"

Set::Set(bool val, std::string ID, std::string ID2) {
	bval = val;
	typeID = SET_TYPE_BOOL;
	this->ID = ID;
	this->ID2 = ID2;
}
Set::Set(int val, std::string ID, std::string ID2) {
	ival = val;
	typeID = SET_TYPE_INT;
	this->ID = ID;
	this->ID2 = ID2;
}
Set::Set(float val, std::string ID, std::string ID2) {
	fval = val;
	typeID = SET_TYPE_FLOAT;
	this->ID = ID;
	this->ID2 = ID2;
}
Set::Set(double val, std::string ID, std::string ID2) {
	dval = val;
	typeID = SET_TYPE_DOUBLE;
	this->ID = ID;
	this->ID2 = ID2;
}
Set::Set(int val, int min, int max, std::string ID, std::string ID2) {
	vec3i = Vec3i(val, min, max);
	typeID = SET_TYPE_SLIDER_I;
	this->ID = ID;
	this->ID2 = ID2;
}
Set::Set(float val, float min, float max, std::string ID, std::string ID2) {
	vec3f = Vec3f(val, min, max);
	typeID = SET_TYPE_SLIDER_F;
	this->ID = ID;
	this->ID2 = ID2;
}
Set::Set(double val, double min, double max, std::string ID, std::string ID2) {
	vec3d = Vec3d(val, min, max);
	typeID = SET_TYPE_SLIDER_D;
	this->ID = ID;
	this->ID2 = ID2;
}
Set::Set(ImVec4 v, std::string ID, std::string ID2) {
	vec4 = v;
	typeID = SET_TYPE_VEC4;
	this->ID = ID;
	this->ID2 = ID2;
}

bool& Set::getBVal() {
	return bval;
}
int& Set::getIVal() {
	return ival;
}
float& Set::getFVal() {
	return fval;
}
double& Set::getDVal() {
	return dval;
}
ImVec4& Set::getVec4() {
	return vec4;
}
Vec3i& Set::getVec3i() {
	return vec3i;
}
Vec3f& Set::getVec3f() {
	return vec3f;
}
Vec3d& Set::getVec3d() {
	return vec3d;
}

void Set::setBVal(bool val) {
	bval = val;
}
void Set::setIVal(int val) {
	ival = val;
}
void Set::setFVal(float val) {
	fval = val;
}
void Set::setDVal(double val) {
	dval = val;
}
void Set::setVec4(ImVec4 v) {
	vec4 = v;
}
void Set::setVec3i(int val, int min, int max) {
	vec3i = Vec3i(val, min, max);
}
void Set::setVec3f(float val, float min, float max) {
	vec3f = Vec3f(val, min, max);
}
void Set::setVec3d(double val, double min, double max) {
	vec3d = Vec3d(val, min, max);
}


bool  Set::isBool() {
	return typeID == SET_TYPE_BOOL;
}
bool  Set::isInt() {
	return typeID == SET_TYPE_INT;
}
bool  Set::isFloat() {
	return typeID == SET_TYPE_FLOAT;
}
bool  Set::isDouble() {
	return typeID == SET_TYPE_DOUBLE;
}
bool  Set::isISlider() {
	return typeID == SET_TYPE_SLIDER_I;
}
bool  Set::isFSlider() {
	return typeID == SET_TYPE_SLIDER_F;
}
bool  Set::isDSlider() {
	return typeID == SET_TYPE_SLIDER_D;
}
bool  Set::isVec4() {
	return typeID == SET_TYPE_VEC4;
}#include <substrate.h>
#include <mach-o/dyld.h>

// 1. Linking our Menu Switches to global variables
bool NoSpreadActive = false;
bool GodModeActive = false;

// 2. Define our Ghidra function hook signature
void (*orig_WeaponSpreadCalc)(float p1, float p2, long p3);
void hooked_WeaponSpreadCalc(float param_1, float param_2, long param_3) {
    // If the checkbox in our menu is turned ON, force calculation to zero spread
    if (NoSpreadActive) {
        param_1 = 0.0f;
        param_2 = 0.0f;
    }
    orig_WeaponSpreadCalc(param_1, param_2, param_3);
}

// 3. This automatically maps the hook the exact millisecond the game opens
__attribute__((constructor)) static void run_mod_menu_offsets() {
    uint64_t dynamic_base_address = (uint64_t)_dyld_get_image_header(0);
    uint64_t weapon_offset = 0x9445d0; // Your exact Ghidra calculation!
    
    MSHookFunction((void*)(dynamic_base_address + weapon_offset), 
                   (void*)&hooked_WeaponSpreadCalc, 
                   (void**)&orig_WeaponSpreadCalc);
}
