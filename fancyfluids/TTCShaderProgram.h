//
//  TTShaderProgram.h
//  fancyfluids
//
//  Created by Matt Stanton on 8/2/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTCShaderProgram : NSObject

- (BOOL) createFromShaders:(NSArray*)shaders;
- (BOOL) validate;

@end
