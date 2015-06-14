#import "MetalDispatch.h"
@import Metal;

struct BrightenParameters {
    float amount;
};

@interface MetalDispatch() 

@end

@implementation MetalDispatch {
    id<MTLDevice> mtlDevice;
    id<MTLLibrary> mtlLibrary;
    id<MTLCommandQueue> mtlQueue;
}

-(id) init {
    self = [super init];
    if (self) {
        // Metal Initialization
        mtlDevice = MTLCreateSystemDefaultDevice();
        if (!mtlDevice) {
            NSLog(@"Metal Device is NULL");
        }

        // Load Bundle that holds the Metal File
        NSString* bundlePath = [[NSBundle mainBundle] pathForResource:@"MetalBuild" ofType:@"bundle"];
        NSBundle* metalBundle = [NSBundle bundleWithPath:bundlePath];
        NSString* libraryName = [metalBundle pathForResource:@"filters" ofType:@"metallib"];

        // Load Library and Grab Dispatchable Functions
        NSError* errors;
        mtlLibrary = [mtlDevice newLibraryWithFile:libraryName error:&errors];

        // Setup Command Execution Objects
        mtlQueue = [mtlDevice newCommandQueue];
    }
    return self;
}

-(id<MTLTexture>) MTLTextureFromImage:(UIImage*) image {
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    NSUInteger bytesPerRow = CGImageGetBytesPerRow(imageRef);

    MTLTextureDescriptor* descriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatRGBA8Unorm
                                                                                          width:width height:height mipmapped:NO];
    if (!descriptor) {
        NSLog(@"Failed to create MTLTextureDescriptor");
        return NULL;
    }

    id<MTLTexture> texture = [mtlDevice newTextureWithDescriptor:descriptor];
    if (!texture) {
        NSLog(@"Failed to create MTLTexture");
        return NULL;
    }

    unsigned char* data = [self GetRawByteDataFromImage:image];

    MTLRegion size = MTLRegionMake2D(0, 0, width, height);
    NSLog(@"%d %d", width, height);
    NSLog(@"%d %d", size.size.width, size.size.height);
    [texture replaceRegion:size mipmapLevel:0 withBytes:(const void*)data bytesPerRow:bytesPerRow];
    NSLog(@"%d %d %d", texture.width, texture.height, texture.depth);
    NSLog(@"%d %d", descriptor.width, descriptor.height);

    delete[] data;
    return texture;
}

-(UIImage*) GenericMetalDispatch:(id<MTLFunction>)function Input:(UIImage*)input Parameters:(id<MTLBuffer>) params {
    CGImageRef imageRef = [input CGImage];
    NSUInteger bytesPerRow = CGImageGetBytesPerRow(imageRef);

    // Create Textures that we pass to the Metal function for the input image and the output image
    id<MTLTexture> inputImage = [self MTLTextureFromImage:input];
    MTLTextureDescriptor* outputDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatRGBA8Uint
                                                                                          width:inputImage.width height:inputImage.height mipmapped:NO];
    id<MTLTexture> outputImage = [mtlDevice newTextureWithDescriptor:outputDescriptor];

    NSError* errors;
    id<MTLCommandBuffer> buffer = [mtlQueue commandBuffer];
    id<MTLComputeCommandEncoder> encoder = [buffer computeCommandEncoder];
    id<MTLComputePipelineState> state = [mtlDevice newComputePipelineStateWithFunction:function error:&errors];
    [encoder setComputePipelineState:state];
    [encoder setTexture:inputImage atIndex:0];
    [encoder setTexture:outputImage atIndex:1];
    [encoder setBuffer:params offset:0 atIndex:0];

    MTLSize threadsPerGroup = {16, 16, 1};
    MTLSize numThreadGroups = {inputImage.width / threadsPerGroup.width, inputImage.height / threadsPerGroup.height, 1};
    [encoder dispatchThreadgroups:numThreadGroups threadsPerThreadgroup:threadsPerGroup];
    [encoder endEncoding];
    [buffer commit];
    [buffer waitUntilCompleted];

    unsigned char* outputImageData = new unsigned char[outputImage.width * outputImage.height * 4];
    MTLRegion size = {{0, 0}, {outputImage.width, outputImage.height}};
    [outputImage getBytes:outputImageData bytesPerRow:bytesPerRow fromRegion:size mipmapLevel:0];
    // TODO: Figure out channels in a better way :P
    UIImage* retImage = [self GetUIImageFromRawByteData:outputImageData Width:outputImage.width Height:outputImage.height Channels:4];
    return retImage;
}

-(UIImage*) Brighten:(UIImage*) image {
    id<MTLFunction> brighten = [mtlLibrary newFunctionWithName:@"brighten"];

    BrightenParameters params;
    params.amount = 0.25f;

    id<MTLBuffer> parameters = [mtlDevice newBufferWithBytes:&params length:sizeof(params) options:NULL];
    return [self GenericMetalDispatch:brighten Input:image Parameters:parameters];
}

-(UIImage*) GaussianBlur:(UIImage*) image {
    return NULL;
}

-(UIImage*) LaplacianOfGaussianSharpen:(UIImage*) image {
    return NULL;
}

-(UIImage*) TwirlDistortion:(UIImage*) image {
    return NULL;
}

@end

