//
//  AcaiaManager.h
//  AcaiaSDK
//
//  Created by Michael Wu on 2018/6/30.
//  Copyright © 2018 acaia Corp. All rights reserved.
//
#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

extern NSString * const AcaiaScaleDidConnected;
extern NSString * const AcaiaScaleDidDisconnected;
extern NSString * const AcaiaScaleWeight;
extern NSString * const AcaiaScaleTimer;
extern NSString * const AcaiaScaleDeviceListChanged;
extern NSString * const AcaiaScaleDidFinishScan;
extern NSString * const AcaiaScaleConnectFailed;
extern NSString * const AcaiaScaleUserInfoKeyUnit;
extern NSString * const AcaiaScaleUserInfoKeyWeight;
extern NSString * const AcaiaScaleUserInfoKeyTimer;

typedef NS_ENUM(NSInteger, AcaiaScaleWeightUnit) {
    AcaiaScaleWeightUnitGram,
    AcaiaScaleWeightUnitOunce
};


@class AcaiaScale;

@interface AcaiaManager : NSObject

@property (readonly) BOOL isReady;
@property (readonly) NSArray<AcaiaScale*>* scaleList;
@property (nullable, readonly) AcaiaScale *connectedScale;

@property (nonatomic, readwrite) BOOL enableBackgroundRecovery;

+ (instancetype)sharedManager;
- (void)startScan:(NSTimeInterval)interval;
- (void)stopScan;

@end


@interface AcaiaScale : NSObject

@property (readonly) NSString *uuid;
@property (readonly) NSString *name;
@property (readonly) NSString *modelName;

- (instancetype)initWithDevice:(id)device;

- (void)startTimer;
- (void)stopTimer;
- (void)pauseTimer;
- (void)tare;
- (void)connect;
- (void)disconnect;

@end


NS_ASSUME_NONNULL_END
