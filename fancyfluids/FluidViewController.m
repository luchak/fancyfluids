//
//  FluidViewController.m
//  fancyfluids
//
//  Created by Matt Stanton on 8/1/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "FluidViewController.h"

#import "TTCQuad.h"
#import "TTCShaderLibrary.h"
#import "TTCSurface.h"

@interface FluidViewController () {
    TTCShaderProgram* _program;
    TTCSurface* _surface;
}
@property (strong, nonatomic) EAGLContext* context;
@property (strong, nonatomic) TTCShaderProgram* shader_program;
@property (strong, nonatomic) TTCSurface* surface;

@end

@implementation FluidViewController

@synthesize context = _context;
@synthesize shader_program = _shader_program;
@synthesize surface = _surface;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create OpenGL ES context.");
    }
    
    GLKView* view = (GLKView*)self.view;
    view.context = self.context;
    [EAGLContext setCurrentContext:self.context];
    
    TTCShaderLibrary* shader_library = [[TTCShaderLibrary alloc] init];
    [shader_library compileVertexShaderWithName:@"vertex_default"];
    [shader_library compileFragmentShaderWithName:@"mandelbrot"];
    [shader_library compileFragmentShaderWithName:@"sum"];
    [shader_library compileFragmentShaderWithName:@"show_texture"];
    self.shader_program = [shader_library programWithShaders:[NSArray arrayWithObjects:@"mandelbrot", @"vertex_default", nil] error:NULL];
    [self.shader_program validate];
    
    TTCShaderProgram* texture_program = [shader_library programWithShaders:[NSArray arrayWithObjects:@"mandelbrot", @"vertex_default", nil] error:NULL];
    [texture_program validate];
    self.surface = [[TTCSurface alloc] initWithWidth:self.view.bounds.size.width height:self.view.bounds.size.height depth:3 fullFloat:NO];
    [self.surface bindAsOutput];
    [[TTCQuad quad] drawWithProgram:texture_program];
    [self.surface unbindAsOutput];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;
    
    self.shader_program = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView*)view drawInRect:(CGRect)rect {
    [((GLKView*)self.view) bindDrawable];
    glViewport(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    [self.shader_program bindTexture2D:self.surface.texture_id atIndex:0 toUniform:@"tex0"];
    [[TTCQuad quad] drawWithProgram:self.shader_program];
}

#pragma mark - GLKViewControllerDelegate

- (void)update {
    ;
}

@end
