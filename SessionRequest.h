//
//  SessionRequest.h
//  Googleplace
//
//  Created by Roei Baruch on 22/11/2016.
//  Copyright © 2016 Roei Baruch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionRequest : NSObject
typedef void (^NoError)(BOOL ok);
@property(nonatomic, strong) NSData *DateFromSession;
@property(nonatomic, strong) NSError *ErrorFromSession;





-(void)DataTask:(NoError)callback;

@end
