
#import "include.h"
#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import "../IMGUI/theme.h"
#import "../menu/Console.hpp"
#import "../menu/Menu.hpp"
#import "../menu/CheatFeatures.hpp"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kScale [UIScreen mainScreen].scale

#pragma mark - MTKViewDelegate

@interface ImGuiDrawView () <MTKViewDelegate>

@property (nonatomic, strong) id<MTLDevice> device;
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;

@end

@implementation ImGuiDrawView

static bool MenDeal = true;
bool StreamerMode = false;

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
                         bundle:(nullable NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];

    if (!self) {
        return nil;
    }

    _device = MTLCreateSystemDefaultDevice();
    _commandQueue = [_device newCommandQueue];

    if (!_device || !_commandQueue) {
        abort();
    }

    IMGUI_CHECKVERSION();
    ImGui::CreateContext();

    Menu::loadTheme();

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // loadSettings();
    });

    ImGui_ImplMetal_Init(_device);

    return self;
}

+ (void)showChange:(BOOL)open
{
    MenDeal = open;
}

+ (BOOL)isMenuShowing
{
    return MenDeal;
}

- (MTKView *)mtkView
{
    return (MTKView *)self.view;
}

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    self.view = [[MTKView alloc] initWithFrame:frame];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.mtkView.device = self.device;
    self.mtkView.delegate = self;
    self.mtkView.clearColor = MTLClearColorMake(0, 0, 0, 0);
    self.mtkView.backgroundColor =
        [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.mtkView.clipsToBounds = YES;
}

- (void)updateIOWithTouchEvent:(UIEvent *)event
{
    UITouch *anyTouch = event.allTouches.anyObject;

    if (anyTouch) {
        CGPoint touchLocation = [anyTouch locationInView:self.view];
        ImGuiIO &io = ImGui::GetIO();
        io.MousePos = ImVec2(
            static_cast<float>(touchLocation.x),
            static_cast<float>(touchLocation.y)
        );
    }

    BOOL hasActiveTouch = NO;

    for (UITouch *touch in event.allTouches) {
        if (touch.phase != UITouchPhaseEnded &&
            touch.phase != UITouchPhaseCancelled) {
            hasActiveTouch = YES;
            break;
        }
    }

    ImGui::GetIO().MouseDown[0] = hasActiveTouch;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches
               withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)drawInMTKView:(MTKView *)view
{
    hideRecordTextfield.secureTextEntry = StreamerMode;

    ImGuiIO &io = ImGui::GetIO();

    io.DisplaySize = ImVec2(
        static_cast<float>(view.bounds.size.width),
        static_cast<float>(view.bounds.size.height)
    );

    CGFloat framebufferScale =
        view.window.screen.nativeScale
            ? view.window.screen.nativeScale
            : UIScreen.mainScreen.nativeScale;

    io.DisplayFramebufferScale = ImVec2(
        static_cast<float>(framebufferScale),
        static_cast<float>(framebufferScale)
    );

    io.DeltaTime = 1.0f / static_cast<float>(
        view.preferredFramesPerSecond
            ? view.preferredFramesPerSecond
            : 60
    );

    id<MTLCommandBuffer> commandBuffer =
        [self.commandQueue commandBuffer];

    if (MenDeal) {
        [self.view setUserInteractionEnabled:YES];
        [self.view.superview setUserInteractionEnabled:YES];
        [menuTouchView setUserInteractionEnabled:YES];
    } else {
        [self.view setUserInteractionEnabled:NO];
        [self.view.superview setUserInteractionEnabled:NO];
        [menuTouchView setUserInteractionEnabled:NO];
    }

    MTLRenderPassDescriptor *renderPassDescriptor =
        view.currentRenderPassDescriptor;

    if (renderPassDescriptor != nil) {
        id<MTLRenderCommandEncoder> renderEncoder =
            [commandBuffer renderCommandEncoderWithDescriptor:
                renderPassDescriptor];

        [renderEncoder pushDebugGroup:@"Dear ImGui Rendering"];

        ImGui_ImplMetal_NewFrame(renderPassDescriptor);
        ImGui::NewFrame();

        // Keep your existing theme and font configuration.
        ImFont *font = ImGui::GetFont();

        if (font && font->FontSize > 0.0f) {
            font->Scale = isIpad
                ? 15.0f / font->FontSize
                : 10.0f / font->FontSize;
        }

        CGFloat screenWidth =
            [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight =
            [UIScreen mainScreen].bounds.size.height;

        CGFloat windowWidth = isIphone ? 600.0 : 800.0;
        CGFloat windowHeight = isIphone ? 375.0 : 500.0;

        CGFloat xPos = screenWidth - windowWidth - 10.0;
        CGFloat yPos = 10.0;

        ImGui::SetNextWindowPos(
            ImVec2(
                static_cast<float>(xPos),
                static_cast<float>(yPos)
            ),
            ImGuiCond_FirstUseEver
        );

        ImGui::SetNextWindowSize(
            ImVec2(
                static_cast<float>(windowWidth),
                static_cast<float>(windowHeight)
            ),
            ImGuiCond_FirstUseEver
        );

        if (MenDeal) {
            // Existing template menu.
            Menu::render();

            // Separate demo feature controls.
            DrawModMenu();
        }

        ImGui::Render();

        ImDrawData *draw_data = ImGui::GetDrawData();

        ImGui_ImplMetal_RenderDrawData(
            draw_data,
            commandBuffer,
            renderEncoder
        );

        [renderEncoder popDebugGroup];
        [renderEncoder endEncoding];

        if (view.currentDrawable) {
            [commandBuffer presentDrawable:view.currentDrawable];
        }
    }

    [commandBuffer commit];
}

- (void)mtkView:(MTKView *)view
 drawableSizeWillChange:(CGSize)size
{
}

@end
