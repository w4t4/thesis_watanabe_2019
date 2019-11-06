% transform matrix(image) [iy ix 3] to [3 ix*iy]


function out = w3dto2d(xyz)

    [iy,ix,iz] = size(xyz);
    permuted = permute(xyz,[3 2 1]);
    reshaped = reshape(permuted,[iz,iy*ix]);
    out = reshaped;

 end
