% stack_slices_to_3D.m
% Combines 2D NIfTI slices into 3D volumes per phase for nnU-Net
clc; clear; close all;
%  Folder paths 
baseDir = 'C:\Users\guhaa2\OneDrive - Cedars-Sinai Health System\Malagi, Archana''s files - MVD project with AG\nnUNet_prepared_data';
imgDir = fullfile(baseDir, 'imagesTr');
maskDir = fullfile(baseDir, 'labelsTr');
outImgDir = fullfile(baseDir, 'stacked_imagesTr');
outMaskDir = fullfile(baseDir, 'stacked_labelsTr');
if ~exist(outImgDir, 'dir'); mkdir(outImgDir); end
if ~exist(outMaskDir, 'dir'); mkdir(outMaskDir); end
% ---- Find NIfTI files 
imgFiles = dir(fullfile(imgDir, '*.nii*'));
fileNames = {imgFiles.name};
tokens = regexp(fileNames, '(subj\d+_phase\d+)_slice\d+_(000\d)\.nii', 'tokens');
validIdx = ~cellfun(@isempty, tokens);
tokens = tokens(validIdx);
imgFiles = imgFiles(validIdx);
uniqueGroups = unique(cellfun(@(x) x{1}{1}, tokens, 'UniformOutput', false));
fprintf('Found %d subject-phase groups\n', numel(uniqueGroups));
%  Process each subject-phase 
for g = 1:numel(uniqueGroups)
    groupID = uniqueGroups{g};
    fprintf('Processing %s ...\n', groupID);
    idx = find(contains({imgFiles.name}, groupID));
    ch0 = imgFiles(contains({imgFiles(idx).name}, '0000')); % Magnitude
    ch1 = imgFiles(contains({imgFiles(idx).name}, '0001')); % T2*/Mask
    ch0 = sort_nat_struct(ch0);
    ch1 = sort_nat_struct(ch1);
    for ch = 0:1
        if ch == 0
            fileSet = ch0;
        else
            fileSet = ch1;
        end
        if isempty(fileSet)
            continue;
        end
        info = niftiinfo(fullfile(imgDir, fileSet(1).name));
        sliceData = [];
        for i = 1:numel(fileSet)
            slice = niftiread(fullfile(imgDir, fileSet(i).name));
            sliceData(:,:,i) = slice;
        end
        % Update header to reflect 3D stack 
        info.ImageSize = size(sliceData);
        if numel(info.PixelDimensions) < 3
            info.PixelDimensions(3) = 1; % Assign a default slice thickness (1mm)
        end
        % Save corrected 3D image
        outFile = sprintf('%s_%04d.nii', groupID, ch);
        niftiwrite(sliceData, fullfile(outImgDir, outFile), info, 'Compressed', true);
    end
    %  Stack corresponding label masks 
    maskSet = dir(fullfile(maskDir, sprintf('%s_slice*.nii', groupID)));
    if ~isempty(maskSet)
        maskSet = sort_nat_struct(maskSet);
        infoMask = niftiinfo(fullfile(maskDir, maskSet(1).name));
        mask3D = [];
        for i = 1:numel(maskSet)
            maskSlice = niftiread(fullfile(maskDir, maskSet(i).name));
            mask3D(:,:,i) = maskSlice;
        end

        infoMask.ImageSize = size(mask3D);
        if numel(infoMask.PixelDimensions) < 3
            infoMask.PixelDimensions(3) = 1;
        end

        outMaskFile = sprintf('%s.nii', groupID);
        niftiwrite(mask3D, fullfile(outMaskDir, outMaskFile), infoMask, 'Compressed', true);
    end
end
fprintf('\n 3D volumes saved to:\n%s\n%s\n', outImgDir, outMaskDir);
% Helper functions 
function sortedStruct = sort_nat_struct(s)
    names = {s.name};
    [~, idx] = sort_nat(names);
    sortedStruct = s(idx);
end
function [sorted, ndx] = sort_nat(C)
    [~, ndx] = sort(regexprep(C,'(\d+)','${num2str(str2double($1), ''%010d'')}'));
    sorted = C(ndx);
end
