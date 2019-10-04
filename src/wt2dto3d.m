function out = wt2dto3d(xy,ix,iy,iz)

    reshaped = reshape(xy,[iz ix iy]);
    permuted = permute(reshaped,[3 2 1]);
    out = permuted;

end