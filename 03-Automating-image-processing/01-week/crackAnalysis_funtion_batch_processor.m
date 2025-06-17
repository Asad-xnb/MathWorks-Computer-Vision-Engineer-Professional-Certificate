function results = crackAnalysis(img)

gray = im2gray(img);
gfilt = imgaussfilt(gray, 1);

%Segmentation
%Multi-level thresholding 
% Textured concrete 
% and finally filter out all regions

thresh = multithresh(gfilt, 2);
levels = imquantize(gfilt, thresh);

bw = levels  > 1;
bw = ~bw;

bw = imclose(bw, strel("disk", 4, 0));
bw = bwpropfilt(bw, "Area", [50, inf]);

% Region Analysis
rp = regionprops("table", bw, "Area");
distToEdge = bwdist(~bw);
maxWidth = 2 * max(distToEdge, [], "all");

% generating output structure variable
results.BW = bw;
results.NumRegions = height(rp);
results.Area = sum(rp.Area);
results.MaxWidth = maxWidth;

end