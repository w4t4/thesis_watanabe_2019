% transform matrix(image) [3 ix*iy] to [iy ix 3]

function out = w2dto3d(xy,ix,iy,iz)

    reshaped = reshape(xy,[iz ix iy]);
    permuted = permute(reshaped,[3 2 1]);
    out = permuted;

end