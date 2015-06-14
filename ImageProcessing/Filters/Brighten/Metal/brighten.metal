struct BrightenParameters 
{
    float amount;    
};

kernel void brighten(
    texture2d<float, access::read> input [[texture(0)]],
    texture2d<float, access::write> output [[texture(1)]],
    uint2 gid [[thread_position_in_grid]],
    constant BrightenParameters& parameters [[buffer(0)]]
    )
{
    float4 inColor = input.read(gid);
    float4 outColor = clamp(inColor + float4(parameters.amount, parameters.amount, parameters.amount, 0.,
                float4(0, 0, 0, 0), float4(1, 1, 1, 1));
    output.write(outColor, gid);
}

