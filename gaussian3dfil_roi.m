% Performs Gaussian 3D filtering, limited by a ROI (or VOI)
% returns filtered values only in the volume specified by the ROI
% (C) Jussi Tohka
% Department of Signal Processing,
% Tampere University of Technology, Finland
% The method is described in 
% J. Tohka. Volume of interest (VOI) limited linear filtering. 
% http://www.cs.tut.fi/~jupeto/roi_limited_filtering.pdf
% --------------------------------------------------------------
% Permission to use, copy, modify, and distribute this software 
% for any purpose and without fee is hereby
% granted, provided that the above copyright notice appear in all
% copies.  The author and Tampere University of Technology make no representations
% about the suitability of this software for any purpose.  It is
% provided "as is" without express or implied warranty.
% -------------------------------------------------------------
% filimg is the filtered image
% img is the image
% mask is the roi mask
% fwhm is the fwhm of the filter
% voxel_dims is a 3-component vector of voxel sizes in millimeters
% w is the width of the kernel (optional)

function filimg = gaussian3dfil_roi(img,mask,fwhm,voxel_dims,w);
    % take care that the mask is binary
    mask = mask > 0.5;
    % construct the kernel;
    
    
    sigma = fwhm/(2*sqrt(2 * log(2) ));
    sigma = sigma./voxel_dims;
    if ~exist('w','var')
      w = 2*ceil(2.5*max(sigma)) + 1
    end
    siz = [w w w];  
    [x,y,z] = ...
	meshgrid(-(siz(2)-1)/2:(siz(2)-1)/2,-(siz(1)-1)/2:(siz(1)-1)/2,-(siz(3)-1)/2:(siz(3)-1)/2);
    ker = exp(-(x.*x/sigma(1)^2 + y.*y/sigma(2)^2 + z.*z/sigma(3)^2)/2);
    ker = ker/sum(sum(sum(ker)));
    % limit the image
    img = img.*mask;
    % filter the image
    filimg = convn(img,ker,'same');
    % compute the correction
    corr = convn(mask,ker,'same');
    filimg = mask.*filimg./corr;
   
    