//
//  EPRC4Cryptor.m


#import "EPRC4Cryptor.h"

@interface EPRC4Cryptor() {
    UInt8 _engineState[256];
    int _x;
    int _y;
}
@end

@implementation EPRC4Cryptor

-(instancetype)initWith:(UInt8 *)key lenght:(int)lenght {
    self = [super init];
    if(self) {
        [self updateKey:key lenght:lenght];
    }
    return self;
}

-(void)doFinal:(UInt8*)cipher input:(UInt8 *)input lenght:(int)lenght {
    for (int i = 0; i < lenght; i++) {
        _x = (_x + 1) & 0xff;
        _y = (_engineState[_x] + _y) & 0xff;
        
        [EPRC4Cryptor swap:_engineState forIndex:_x andIndex:_y];

        cipher[i] = input[i] ^ _engineState[(_engineState[_x] + _engineState[_y]) & 0xff];
    }
}

-(void)updateKey:(UInt8 *)key lenght:(int)lenght {
    _x = 0;
    _y = 0;
    
    for (int i = 0; i < 256; i++) {
        _engineState[i] = i;
    }
    
    int i1 = 0;
    int i2 = 0;
    for (int i = 0; i < 256; i++) {
        i2 = ((key[i1] & 0xff) + _engineState[i] + i2) & 0xff;
        [EPRC4Cryptor swap:_engineState forIndex:i andIndex:i2];
        i1 = (i1 + 1) % lenght;
    }
}

+ (void)byteArr:(UInt8 *)array forString:(NSString *)string {
    for (int p = 0; p < (int)string.length; p++) {
        array[p] = [string characterAtIndex:p];
    }
}

+ (void)swap:(UInt8 *)a forIndex:(int)firstIndex andIndex:(int)secondIndex {
    UInt8 temp = a[firstIndex];
    a[firstIndex] = a[secondIndex];
    a[secondIndex] = temp;
}
@end
