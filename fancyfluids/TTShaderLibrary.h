//
//  TTShaderLibrary.h
//  fancyfluids
//
//  Created by Matt Stanton on 8/2/12.
//  Copyright (c) 2012 Carnegie Mellon University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTShaderLibrary : NSObject

- (id) init;
- (id) initWithBasePath:(NSString*)path;
- (void) compileFragmentShaderWithName:(NSString*)name;
- (void) compileVertexShaderWithName:(NSString*)name;

@end
