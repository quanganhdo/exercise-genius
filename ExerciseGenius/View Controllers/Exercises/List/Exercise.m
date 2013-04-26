//
//  Created by Anh Quang Do on 4/25/13.
//  Copyright Anh Quang Do. All rights reserved.
//


#import "Exercise.h"


@implementation Exercise {

}

- (NSString *)description {
    return [NSString stringWithFormat:@"%d minutes • %.2f miles • %@ min/mi",
                                      (int) (_interval / SECONDS_PER_MINUTE),
                                      _distance / METERS_PER_MILE,
                                      stringFromInterval(_interval / (_distance / METERS_PER_MILE))];
}

- (NSString *)healthVaultXMLValue {
    // TODO: Timezone
    NSUInteger calendarUnits = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CDT"]];
    NSDateComponents *components = [calendar components:calendarUnits fromDate:_date];
    NSInteger year  = [components year];
    NSInteger month = [components month];
    NSInteger day   = [components day];

    NSInteger hour   = [components hour];
    NSInteger minute = [components minute];

    return [NSString stringWithFormat:@""
                                              "<thing>\n"
                                              "    <type-id>85a21ddb-db20-4c65-8d30-33c899ccf612</type-id>\n"
                                              "    <data-xml>\n"
                                              "        <exercise>\n"
                                              "            <when>\n"
                                              "                <structured>\n"
                                              "                    <date>\n"
                                              "                        <y>%i</y>\n"
                                              "                        <m>%i</m>\n"
                                              "                        <d>%i</d>\n"
                                              "                    </date>\n"
                                              "                    <time>\n"
                                              "                        <h>%i</h>\n"
                                              "                        <m>%i</m>\n"
                                              "                    </time>\n"
                                              "                    <tz>\n"
                                              "                        <text>Central Time</text>\n"
                                              "                        <code>\n"
                                              "                            <value>1089</value>\n"
                                              "                            <type>time-zones</type>\n"
                                              "                            <version>1</version>\n"
                                              "                        </code>\n"
                                              "                    </tz>\n"
                                              "                </structured>\n"
                                              "            </when>\n"
                                              "            <activity>\n"
                                              "                <text>Running</text>\n"
                                              "                <code>\n"
                                              "                    <value>Running</value>\n"
                                              "                    <type>exercise-activities</type>\n"
                                              "                    <version>1</version>\n"
                                              "                </code>\n"
                                              "            </activity>\n"
                                              "            <title></title>\n"
                                              "            <distance>\n"
                                              "                <m>%f</m>\n"
                                              "            </distance>\n"
                                              "            <duration>%f</duration>\n"
                                              "        </exercise>\n"
                                              "    </data-xml>\n"
                                              "</thing>\n",
                                      year, month, day, hour, minute, _distance, _interval / SECONDS_PER_MINUTE];
}

- (NSNumber *)boxedInterval {
    return @(_interval);
}

- (NSNumber *)boxedDistance {
    return @(_distance);
}

#pragma mark - Keyed

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.healthVaultID forKey:@"healthVaultID"];
    [encoder encodeObject:self.healthVaultVersionStamp forKey:@"healthVaultVersionStamp"];
    [encoder encodeInteger:self.type forKey:@"type"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeDouble:self.distance forKey:@"distance"];
    [encoder encodeDouble:self.interval forKey:@"interval"];
    [encoder encodeObject:self.detail forKey:@"detail"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.healthVaultID           = [decoder decodeObjectForKey:@"healthVaultID"];
        self.healthVaultVersionStamp = [decoder decodeObjectForKey:@"healthVaultVersionStamp"];
        self.type                    = (ExerciseType) [decoder decodeIntegerForKey:@"type"];
        self.title                   = [decoder decodeObjectForKey:@"title"];
        self.date                    = [decoder decodeObjectForKey:@"date"];
        self.distance                = [decoder decodeDoubleForKey:@"distance"];
        self.interval                = [decoder decodeDoubleForKey:@"interval"];
        self.detail                  = [decoder decodeObjectForKey:@"detail"];
    }
    return self;
}

@end