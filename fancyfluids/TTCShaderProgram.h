//
//  TTShaderProgram.h
//  fancyfluids
//
//  Created by Matt Stanton on 8/2/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <Foundation/Foundation.h>

enum TTCShaderAttrib {
    TTC_ATTRIB_POSITION,
    TTC_ATTRIB_TEXCOORD,
    TTC_ATTRIB_MAX
};

@interface TTCShaderProgram : NSObject

- (BOOL) createFromShaders:(NSArray*)shaders;
- (BOOL) validate;
- (void) bindTexture2D:(GLuint)texture_id atIndex:(int)index toUniform:(NSString*)uniform;
- (int) locationForUniformWithName:(NSString*)name;

@property (nonatomic,readonly,assign) GLuint program_id;

@end
