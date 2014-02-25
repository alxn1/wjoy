//
//  WiimoteProtocolUtils.h
//  Wiimote
//
//  Created by alxn1 on 06.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#define WiimoteDeviceFloatEpsilon 0.025f

#define WiimoteDeviceIsFloatEqual(a, b) \
			(fabs(((a) - (b))) <= WiimoteDeviceFloatEpsilon)

#define WiimoteDeviceIsFloatEqualEx(a, b, epsilon) \
			(fabs(((a) - (b))) <= (epsilon))

#define WiimoteDeviceIsPointEqual(a, b) \
			(WiimoteDeviceIsFloatEqual((a).x, (b).x) && \
			 WiimoteDeviceIsFloatEqual((a).y, (b).y))

#define WiimoteDeviceIsPointEqualEx(a, b, epsilon) \
			(WiimoteDeviceIsFloatEqualEx((a).x, (b).x, (epsilon)) && \
			 WiimoteDeviceIsFloatEqualEx((a).y, (b).y, (epsilon)))

#define WiimoteDeviceCheckStickCalibration(stickCalibration, minValue, centerValue, maxValue) \
            { \
				if((stickCalibration).x.min == (maxValue)) \
                    (stickCalibration).x.min = (minValue); \
			\
				if((stickCalibration).y.min == (maxValue)) \
                    (stickCalibration).y.min = (minValue); \
			\
                if((stickCalibration).x.center == (minValue) || (stickCalibration).x.center == (maxValue)) \
                    (stickCalibration).x.center = (centerValue); \
            \
                if((stickCalibration).y.center == (minValue) || (stickCalibration).y.center == (maxValue)) \
                    (stickCalibration).y.center = (centerValue); \
            \
                if((stickCalibration).x.max == (minValue)) \
                    (stickCalibration).x.max = (maxValue); \
            \
                if((stickCalibration).y.max == (minValue)) \
                    (stickCalibration).y.max = (maxValue); \
            }

#define WiimoteDeviceNormalizeStickCoordinateEx(value, min, center, max, result) \
            { \
                CGFloat wiimote_device_norm_value_; \
            \
                if((value) <= (center)) \
                { \
                    wiimote_device_norm_value_ = ((CGFloat)(value) - (CGFloat)(min)) / \
                                                 ((CGFloat)(center) - (CGFloat)(min)) - 1.0f; \
                } \
                else \
                { \
                    wiimote_device_norm_value_ = ((CGFloat)(value) - (CGFloat)(center)) / \
                                                 ((CGFloat)(max) - (CGFloat)(center)); \
                } \
            \
                if(wiimote_device_norm_value_ < -1.0f) \
                    wiimote_device_norm_value_ = -1.0f; \
            \
                if(wiimote_device_norm_value_ > 1.0f) \
                    wiimote_device_norm_value_ = 1.0f; \
            \
                result = wiimote_device_norm_value_; \
            }

#define WiimoteDeviceNormalizeStickCoordinate(value, result) \
                WiimoteDeviceNormalizeStickCoordinateEx((value), 0, 127, 255, (result))

#define WiimoteDeviceNormalizeStick(pointX, pointY, stickCalibrationData, resultPoint) \
            { \
                WiimoteDeviceNormalizeStickCoordinateEx( \
                                                (pointX), \
                                                (stickCalibrationData).x.min, \
                                                (stickCalibrationData).x.center, \
                                                (stickCalibrationData).x.max, \
                                                (resultPoint).x); \
            \
                WiimoteDeviceNormalizeStickCoordinateEx( \
                                                (pointY), \
                                                (stickCalibrationData).y.min, \
                                                (stickCalibrationData).y.center, \
                                                (stickCalibrationData).y.max, \
                                                (resultPoint).y); \
            }

#define WiimoteDeviceNormilizeShift(shiftValue, min, center, max, result) \
            WiimoteDeviceNormalizeStickCoordinateEx((shiftValue), (min), (center), (max), (result)); \
            (result) = ((result) + 1.0f) * 0.5f
