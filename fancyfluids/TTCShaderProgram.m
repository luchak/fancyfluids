//
//  TTShaderProgram.m
//  fancyfluids
//
//  Created by Matt Stanton on 8/2/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import "TTCShaderProgram.h"

typedef struct {
    GLuint location;
    GLenum type;
} VariableInfo;

@interface TTCShaderProgram () {
    BOOL _program_created;
    GLuint _program_id;
    NSDictionary* _uniform_info;
    NSDictionary* _attrib_info;
}

- (BOOL) linkUsingShaders:(NSArray*)shaders;
- (void) fillUniformInfo;
- (void) fillAttribInfo;

@property (assign) BOOL program_created;
@property (assign) GLuint program_id;
@property (strong,nonatomic) NSDictionary* uniform_info;
@property (strong,nonatomic) NSDictionary* attrib_info;

@end

@implementation TTCShaderProgram

@synthesize program_created = _program_created;
@synthesize program_id = _program_id;
@synthesize uniform_info = _uniform_info;
@synthesize attrib_info = _attrib_info;

- (id) init {
    self = [super init];
    if (self) {
        self.program_created = NO;
    }
    return self;
}

- (void) dealloc {
    if (self.program_created) {
        glDeleteProgram(self.program_id);
    }
    self.program_created = NO;
}

- (BOOL) createFromShaders:(NSArray*)shaders {
    self.program_created = NO;
    
    self.program_id = glCreateProgram();
    
    self.program_created = [self linkUsingShaders:shaders];
    if (self.program_created) {
        [self fillAttribInfo];
        [self fillUniformInfo];
    }
    
    return self.program_created;
}

- (BOOL) validate {
    glValidateProgram(self.program_id);
    
    GLint validated_successfully;
    glGetProgramiv(self.program_id, GL_VALIDATE_STATUS, &validated_successfully);
    if (!validated_successfully) {
        GLint log_length;
        glGetProgramiv(self.program_id, GL_INFO_LOG_LENGTH, &log_length);

        if (log_length > 0) {
            GLchar* log = (GLchar*)malloc(log_length);
            glGetProgramInfoLog(self.program_id, log_length, &log_length, log);
            NSLog(@"Validation log for program %d:\n%s", self.program_id, log);
            free(log);
        }
        return NO;
    } else {
        return YES;
    }
}

- (BOOL) linkUsingShaders:(NSArray*) shaders {
    for (NSNumber* shader_id in shaders) {
        glAttachShader(self.program_id, [shader_id intValue]);
    }
    glLinkProgram(self.program_id);
    
    GLint did_link;
    glGetProgramiv(self.program_id, GL_LINK_STATUS, &did_link);
    if (did_link != GL_TRUE) {
        NSLog(@"Failed to link program with id %d.", self.program_id);
#if defined(DEBUG)
        GLint log_length;
        glGetProgramiv(self.program_id, GL_INFO_LOG_LENGTH, &log_length);
        if (log_length > 0) {
            GLchar* log = (GLchar*)malloc(log_length);
            glGetProgramInfoLog(self.program_id, log_length, &log_length, log);
            NSLog(@"Program link log:\n%s", log);
            free(log);
        }
#endif
        glDeleteProgram(self.program_id);
        return NO;
    } else {
        return YES;
    }
}

- (void) fillUniformInfo {
    GLint num_uniforms;
    glGetProgramiv(self.program_id, GL_ACTIVE_UNIFORMS, &num_uniforms);
    GLint max_length;
    glGetProgramiv(self.program_id, GL_ACTIVE_UNIFORM_MAX_LENGTH, &max_length);
    GLchar* name = malloc(max_length);
    for (int i = 0; i < num_uniforms; ++i) {
        VariableInfo variable_info;
        GLint length;
        GLint size;
        glGetActiveUniform(self.program_id, i, max_length, &length, &size, &(variable_info.type), name);        
        variable_info.location = glGetUniformLocation(self.program_id, name);

        [self.uniform_info setValue:[NSValue valueWithBytes:&variable_info objCType:@encode(VariableInfo)] forKey:[NSString stringWithCString:name encoding:NSUTF8StringEncoding]];
    }
    free(name);
}

- (void) fillAttribInfo {
    GLint num_attribs;
    glGetProgramiv(self.program_id, GL_ACTIVE_ATTRIBUTES, &num_attribs);
    GLint max_length;
    glGetProgramiv(self.program_id, GL_ACTIVE_ATTRIBUTE_MAX_LENGTH, &max_length);
    GLchar* name = malloc(max_length);
    for (int i = 0; i < num_attribs; ++i) {
        VariableInfo variable_info;
        GLint length;
        GLint size;
        glGetActiveAttrib(self.program_id, i, max_length, &length, &size, &(variable_info.type), name);        
        variable_info.location = glGetAttribLocation(self.program_id, name);
        
        [self.attrib_info setValue:[NSValue valueWithBytes:&variable_info objCType:@encode(VariableInfo)] forKey:[NSString stringWithCString:name encoding:NSUTF8StringEncoding]];
    }
    free(name);
}

@end

