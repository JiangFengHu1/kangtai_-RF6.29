//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "HTTPService.h"
#import "AFNetworking.h"
#import "ZASyncURLConnection.h"
#import "Gogle.h"

@implementation HTTPService



#pragma GET请求

+ (void)GetHttpToServerWith:(NSString *)urlString  WithParameters:(NSDictionary *)paras success:(void (^) (NSDictionary *dic))result error:(void (^) (NSError *error))error_
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        
        result(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        error_(error);
    }];
}

#pragma post请求

+ (void)POSTHttpToServerWith:(NSString *)urlString WithParameters:(NSDictionary *)paras success:(void (^) (NSDictionary *dic))result error:(void (^) (NSError *error))error_
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        result(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        error_(error);
    }];
}



#pragma mark-上传图片和数据多上传
+ (void)PostHttpToServerImageAndDataWith:(NSString *)urlString WithParmeters:(NSDictionary *)paras WithFilePath:(NSString *)Path  imageName:(NSString *)name andImageFile:(UIImage *)image success:(void (^) (NSDictionary *dic))result error:(void (^) (NSError *error))error_
{
    NSLog(@"dictayt===%@",paras);

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:paras constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

        [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"file" fileName:name mimeType:@"image/png"];

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        result(responseObject);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        error_(error);

    }];
}


#pragma mark-下载文件
+ (void)downloadWithFilePathString:(NSString *)urlString downLoadPath:(void (^) (NSString *filePath))filePath_ error:(void (^)(NSError *error))error_

{
    if (iOS7) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURL *URL = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            NSLog(@"File downloaded to: %@", filePath);
            
            NSLog(@"response==%@",response);
            NSString *tempUrl = [NSString stringWithFormat:@"%@",filePath];
            
            filePath_(tempUrl);
            error_(error);
            
        }];
        [downloadTask resume];

    } else {
        NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL,  kCFStringEncodingUTF8));
        
        [ZASyncURLConnection request:encodedString completeBlock:^(NSData *data) {
            
        } completePathBlock:^(NSString *pathString) {
            NSLog(@"path ==== %@", pathString);
        
            filePath_(pathString);
        } errorBlock:^(NSError *error) {
            NSLog(@"error == %@", error);
        }];
    }
}


#pragma mark-上传文件
+ (void)uploadToServerWithFilePathString:(NSString *)urlString WithServerPath:(NSString *)path success:(void (^) (NSDictionary *dic))result error:(void (^) (NSError *error))error_

{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURL *filePath = [NSURL fileURLWithPath:path];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            error_(error);
            NSLog(@"Error: %@", error);
        } else {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            result(dic);

            NSLog(@"Success: %@ %@", response, responseObject);
        }
    }];
    [uploadTask resume];
}

@end
