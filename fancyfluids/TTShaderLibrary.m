//
//  TTShaderLibrary.m
//  fancyfluids
//
//  Created by Matt Stanton on 8/2/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "TTShaderLibrary.h"

@interface TTShaderLibrary () {
    NSString* _path;
}

- (void) compileShaderWithName:(NSString*)name ofType:(GLenum) type;

@property (strong, nonatomic) NSString* path;

@end

@implementation TTShaderLibrary

@synthesize path = _path;

- (id) init {
    return [self initWithBasePath:nil];
}

- (id) initWithBasePath:(NSString *)path {
    self = [super init];
    if (self) {
        self.path = path;
    }
    return self;
}

- (void) compileFragmentShaderWithName:(NSString*)name {
    [self compileShaderWithName:name ofType:GL_FRAGMENT_SHADER];
}

- (void) compileVertexShaderWithName:(NSString*)name {
    [self compileShaderWithName:name ofType:GL_VERTEX_SHADER];
}

- (void) compileShaderWithName:(NSString*)name ofType:(GLenum)type {
    NSString* extension;
    switch (type) {
        case GL_FRAGMENT_SHADER:
            extension = @".fsh";
            break;
            
        case GL_VERTEX_SHADER:
            extension = @".vsh";
            break;
            
        default:
            NSLog(@"Unrecognized shader type: %d", type);
            return;
            break;
    }
    NSString* shader_path = [[NSBundle mainBundle] pathForResource:name ofType:extension inDirectory:self.path];
    GLchar* shader_text = (GLchar*)[[NSString stringWithContentsOfFile:shader_path encoding:NSUTF8StringEncoding error:nil] UTF8String];
    
    
}

@end
