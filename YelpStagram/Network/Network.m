//
//  Network.m
//   
//
//  Copyright © 2020 Sam Meech-Ward. All rights reserved.
//

#import "Network.h"

@interface Network()

@property (nonatomic, readonly) NSURLSession *session;
@property (nonatomic, readonly) NSString *bearer;

@end

@implementation Network

- (NSString *)bearer {
  NSString *token = @"XKeZYGstxEIQcJO2-SvNXnPnyIw4RDDRwolFV_Nmm21CySg3nUZWFUmgZb5sUz9ISpoKmOP-B9hxpCBUsvuoiwbORpQp5P90wry5-sEkNVN4kRw31sJo7SpDoBq5XXYx";
  
  return [NSString stringWithFormat:@"Bearer %@", token];
}

- (NSURLSession *)session {
  return [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
}

- (NSURLComponents *)components {
  NSURLComponents *comp = [[NSURLComponents alloc] init];
  comp.scheme = @"https";
  comp.host = @"api.yelp.com";
  return comp;
}

- (NSURLRequest *)businessUrl:(NSString *)businessId {
  NSURLComponents *comp = [self components];
  comp.path = [NSString stringWithFormat:@"/v3/businesses/%@", businessId];
  
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:comp.URL];
  [request setValue:self.bearer forHTTPHeaderField:@"Authorization"];
  
  return request.copy;
}

- (NSURLRequest *)queryUrl:(NSString *)term {
  NSURLComponents *comp = [self components];
  comp.path = @"/v3/businesses/search";
  
//  var qi = [URLQueryItem]()
  NSMutableArray *queryItems = [[NSMutableArray alloc] init];

  [queryItems addObject:[NSURLQueryItem queryItemWithName:@"term" value: term]];
  [queryItems addObject:[NSURLQueryItem queryItemWithName:@"latitude" value: @"49.281815"]];
  [queryItems addObject:[NSURLQueryItem queryItemWithName:@"longitude" value: @"-123.108414"]];
  [queryItems addObject:[NSURLQueryItem queryItemWithName:@"limit" value: @"4"]];
  
  comp.queryItems = queryItems;
  
  
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:comp.URL];
  [request setValue:self.bearer forHTTPHeaderField:@"Authorization"];
  
  return request.copy;
}

- (void)getPlaces:(NSString *)name completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
  NSURLSessionTask *task = [self.session dataTaskWithRequest:[self queryUrl:name] completionHandler:completionHandler];
  [task resume];
}

- (void) getPlaceWithId:(NSString *)placeId completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
  
    NSURLSessionTask *task = [self.session dataTaskWithRequest:[self businessUrl:placeId] completionHandler:completionHandler];
    [task resume];
  }

@end
