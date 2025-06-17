function [BW,props] = processPuzzle(X)
%processPuzzle segments and analyzes the puzzle piece regions in the "MathWorks Puzzle" collection.
%  [BW,props] = processPuzzle(X) preprocesses and binarizes the image X using the adaptive method.
%  Morphological operations and region filtering are then applied to improve the initial mask. The
%  final segmentation mask is returned in the variable BW, and a list of region areas is returned
%  in the variable props.
%------------------------------------------------------

% Apply Gaussian filter
X = imgaussfilt(X,0.8);

% Convert image to grayscale
X = im2gray(X);

% Adjust data to span data range
X = imadjust(X);

% Threshold image - adaptive threshold
BW = imbinarize(X, 'adaptive', 'Sensitivity', 0.60, 'ForegroundPolarity', 'bright');

% Open mask with disk
radius = 3;
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imopen(BW, se);

% Close mask with disk
radius = 5;
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imclose(BW, se);

% Fill holes
BW = imfill(BW, 'holes');

% Remove portions of the image that touch an outside edge
BW = imclearborder(BW);

% Filter image based on image properties
BW = bwpropfilt(BW, 'Area', [5000, inf]);

% Get properties
props = regionprops(BW, {'Area'});

% Uncomment the following line to return the properties in a table.
props = struct2table(props);

end
