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

@interface FluidViewController () {
    TTCShaderLibrary* _shader_library;
    TTCShaderProgram* _program;
}
@property (strong, nonatomic) EAGLContext* context;
@property (strong, nonatomic) TTCShaderLibrary* shader_library;
@property (strong, nonatomic) TTCShaderProgram* shader_program;

@end

@implementation FluidViewController

@synthesize context = _context;
@synthesize shader_library = _shader_library;
@synthesize shader_program = _shader_program;

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
    
    self.shader_library = [[TTCShaderLibrary alloc] init];
    [self.shader_library compileVertexShaderWithName:@"vertex_test"];
    [self.shader_library compileFragmentShaderWithName:@"fragment_test"];
    self.shader_program = [self.shader_library programWithShaders:[NSArray arrayWithObjects:@"fragment_test", @"vertex_test", nil] error:NULL];
    [self.shader_program validate];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;
    
    self.shader_library = nil;
    self.shader_program = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView*)view drawInRect:(CGRect)rect {
    glClearColor(0.0, 0.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [[TTCQuad quad] drawWithProgram:self.shader_program];
}

#pragma mark - GLKViewControllerDelegate

- (void)update {
    ;
}

@end
